//
//  MainArchiveShellView.swift
//  LatZip
//
//  Flat design: clean welcome zone with dashed border, flat tab strip, no floating effects.

import SwiftUI
import UniformTypeIdentifiers

struct MainArchiveShellView: View {
    @EnvironmentObject private var app: ArchiveAppState
    @State private var shellDropTargeted = false

    var body: some View {
        Group {
            if app.workspaces.isEmpty {
                welcomeDropZone
            } else {
                workspaceArea
                    .onAppear {
                        app.ensureValidWorkspaceSelection()
                    }
                    .onChange(of: app.workspaces.count) { _ in
                        app.ensureValidWorkspaceSelection()
                    }
            }
        }
        .frame(minWidth: 980, minHeight: 640)
        .background(AppColors.appBackground.opacity(0.001))
        .overlay {
            if shellDropTargeted && app.workspaces.isEmpty {
                RoundedRectangle(cornerRadius: AppRadius.large, style: .continuous)
                    .strokeBorder(Color.accentColor.opacity(0.35), lineWidth: 1.5)
                    .background(
                        RoundedRectangle(cornerRadius: AppRadius.large, style: .continuous)
                            .fill(Color.accentColor.opacity(0.05))
                    )
                    .padding(AppSpacing.xxl)
                    .allowsHitTesting(false)
                    .transition(.opacity.animation(AppAnimation.standard))
            }
        }
        .onDrop(of: [.fileURL], isTargeted: $shellDropTargeted, perform: handleDrop)
        .onOpenURL { url in
            if url.isFileURL {
                app.openArchive(url: url)
            }
        }
        .sheet(isPresented: Binding(
            get: { app.showKeyboardShortcuts },
            set: { app.showKeyboardShortcuts = $0 }
        )) {
            KeyboardShortcutsGuideView()
        }
    }

    private func handleDrop(_ items: [NSItemProvider]) -> Bool {
        guard let item = items.first else { return false }
        item.loadItem(forTypeIdentifier: UTType.fileURL.identifier, options: nil) { data, _ in
            guard let data = data as? Data,
                  let url = URL(dataRepresentation: data, relativeTo: nil) else { return }
            DispatchQueue.main.async {
                app.openArchive(url: url)
            }
        }
        return true
    }

    @ViewBuilder
    private var workspaceArea: some View {
        if let id = app.selectedWorkspaceId,
           let ws = app.workspaces.first(where: { $0.id == id }) {
            ArchiveWorkspaceView(viewModel: ws)
                .id(ws.id)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    private var welcomeDropZone: some View {
        VStack(spacing: AppSpacing.xxl) {
            ZStack {
                RoundedRectangle(cornerRadius: AppRadius.large, style: .continuous)
                    .strokeBorder(
                        AppColors.textPrimary.opacity(shellDropTargeted ? 0.20 : 0.10),
                        style: StrokeStyle(lineWidth: 1.25, dash: [6, 4])
                    )
                    .background(
                        RoundedRectangle(cornerRadius: AppRadius.large, style: .continuous)
                            .fill(AppColors.contentBackground)
                    )
                    .frame(width: 440, height: 240)
                    .animation(AppAnimation.standard, value: shellDropTargeted)

                VStack(spacing: AppSpacing.md) {
                    Image(systemName: "arrow.down.doc")
                        .font(.system(size: 48, weight: .light))
                        .foregroundStyle(AppColors.textSecondary)
                        .symbolRenderingMode(.hierarchical)
                    Text(String(localized: "welcome.drop_title"))
                        .font(AppTypography.welcomeTitle)
                        .foregroundStyle(AppColors.textPrimary)
                    Text(shellDropTargeted ? String(localized: "welcome.drop_active") : String(localized: "welcome.drop_subtitle"))
                        .font(AppTypography.body)
                        .foregroundStyle(AppColors.textSecondary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: 380)
                        .animation(AppAnimation.standard, value: shellDropTargeted)
                }
            }

            HStack(spacing: AppSpacing.md) {
                Button(String(localized: "welcome.new_zip_button")) {
                    app.createNewEmptyZipArchive()
                }
                .keyboardShortcut("n", modifiers: [.command])
                .controlSize(.large)
                .buttonStyle(.bordered)

                Button(String(localized: "welcome.open_button")) {
                    app.openPanel()
                }
                .keyboardShortcut("o", modifiers: [.command])
                .controlSize(.large)
                .buttonStyle(.borderedProminent)
            }

            if !app.recentURLs.isEmpty {
                VStack(alignment: .leading, spacing: AppSpacing.sm) {
                    Text(String(localized: "welcome.recents"))
                        .font(AppTypography.sectionHeader)
                        .foregroundStyle(AppColors.textSecondary)
                        .textCase(.uppercase)
                        .tracking(AppLayoutMetrics.sectionTracking)
                    ForEach(app.recentURLs, id: \.path) { u in
                        Button {
                            app.openRecent(u)
                        } label: {
                            HStack(spacing: AppSpacing.sm) {
                                Image(systemName: "clock")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundStyle(AppColors.textTertiary)
                                    .frame(width: AppLayoutMetrics.sidebarIconColumn, alignment: .center)
                                Text(u.lastPathComponent)
                                    .font(AppTypography.body)
                                    .foregroundStyle(AppColors.textPrimary)
                                    .lineLimit(1)
                                Spacer(minLength: 0)
                            }
                            .padding(.vertical, AppSpacing.sm)
                            .padding(.horizontal, AppSpacing.sm)
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                        .appPointerHover()
                    }
                }
                .frame(maxWidth: 440, alignment: .leading)
                .padding(.top, AppSpacing.sm)
            }
        }
        .padding(AppSpacing.xxl)
    }
}
