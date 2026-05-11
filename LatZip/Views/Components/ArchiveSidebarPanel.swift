//
//  ArchiveSidebarPanel.swift
//  LatZip
//
//  Flat design: flat rail sidebar, subtle separator border, no glossy effects.

import SwiftUI

struct ArchiveSidebarPanel: View {
    @EnvironmentObject private var app: ArchiveAppState
    @ObservedObject var viewModel: ArchiveWorkspaceViewModel

    var body: some View {
        VStack(spacing: 0) {
            sidebarBrandHeader

            List {
                if !app.recentURLs.isEmpty {
                    SidebarSectionView(title: String(localized: "sidebar.recents"), systemImage: "clock") {
                        ForEach(app.recentURLs, id: \.path) { url in
                            SidebarItemView(
                                title: url.lastPathComponent,
                                systemImage: "clock.arrow.circlepath",
                                isActive: url.standardizedFileURL == viewModel.archiveURL.standardizedFileURL
                            ) {
                                app.openRecent(url)
                            }
                            .listRowInsets(EdgeInsets(top: AppSpacing.xs, leading: AppSpacing.md, bottom: AppSpacing.xs, trailing: AppSpacing.md))
                        }
                    }
                }

                if !app.favoriteURLs.isEmpty {
                    SidebarSectionView(title: String(localized: "sidebar.favorites"), systemImage: "star") {
                        ForEach(app.favoriteURLs, id: \.path) { url in
                            SidebarItemView(
                                title: url.lastPathComponent,
                                systemImage: "star.fill",
                                isActive: url.standardizedFileURL == viewModel.archiveURL.standardizedFileURL
                            ) {
                                app.openRecent(url)
                            }
                            .listRowInsets(EdgeInsets(top: AppSpacing.xs, leading: AppSpacing.md, bottom: AppSpacing.xs, trailing: AppSpacing.md))
                            .contextMenu {
                                Button(String(localized: "sidebar.favorite_remove")) {
                                    app.toggleFavorite(url)
                                }
                            }
                        }
                    }
                }

                SidebarSectionView(title: String(localized: "sidebar.structure"), systemImage: "rectangle.split.3x1") {
                    SidebarTreeView(rootNodes: viewModel.rootNodes, currentPath: viewModel.browseFolderPath, onSelect: { path in
                        withAnimation(AppAnimation.standard) {
                            viewModel.selectFolder(path: path)
                        }
                    }, onFileSelect: { path in
                        withAnimation(AppAnimation.standard) {
                            viewModel.selectFileAndNavigate(fileFullPath: path)
                        }
                    })
                }
                .animation(AppAnimation.standard, value: viewModel.browseFolderPath)
            }
            .listStyle(.sidebar)
            .scrollContentBackground(.hidden)

            sidebarFooter
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColors.sidebarRailBackground)
    }

    private var sidebarBrandHeader: some View {
        HStack {
            Spacer()

            HStack(spacing: AppSpacing.md) {
                Image(systemName: "bolt.fill")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(AppColors.textPrimary)
                    .frame(width: 20, height: 20)

                Text("LatZip")
                    .font(.system(size: 19, weight: .semibold))
                    .foregroundStyle(AppColors.textPrimary)
            }

            Spacer()
        }
        .frame(height: 38, alignment: .center)
        .padding(.horizontal, AppSpacing.lg)
        .padding(.top, AppSpacing.sm)
        .padding(.bottom, AppSpacing.md)
    }

    private var sidebarFooter: some View {
        Button {
            NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
        } label: {
            HStack(spacing: AppSpacing.md) {
                Image(systemName: "gearshape")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(AppColors.textSecondary)
                    .frame(width: AppLayoutMetrics.sidebarIconColumn, alignment: .center)

                Text(String(localized: "sidebar.settings"))
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(AppColors.textSecondary)

                Spacer()
            }
            .padding(.horizontal, AppSpacing.lg)
            .padding(.leading, AppSpacing.sm)
            .padding(.vertical, AppSpacing.md)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .background(AppColors.sidebarRailBackground)
    }

    private func sidebarLeafIcon(for node: ArchiveNode) -> String {
        if node.isNestedArchiveCandidate { return "doc.zipper" }
        return "doc"
    }

}

struct SidebarTreeView: View {
    let rootNodes: [ArchiveNode]
    let currentPath: String
    let onSelect: (String) -> Void
    let onFileSelect: (String) -> Void

    var body: some View {
        ForEach(rootNodes, id: \.fullPath) { node in
            SidebarFolderRow(node: node, currentPath: currentPath, onSelect: onSelect, onFileSelect: onFileSelect, depth: 0)
        }
    }
}

struct SidebarFolderRow: View {
    let node: ArchiveNode
    let currentPath: String
    let onSelect: (String) -> Void
    let onFileSelect: (String) -> Void
    let depth: Int

    @State private var isExpanded: Bool = false

    private var isSelected: Bool { currentPath == node.fullPath }
    private var isInCurrentPath: Bool {
        !currentPath.isEmpty && currentPath.hasPrefix(node.fullPath + "/")
    }

    private var indentPadding: CGFloat { AppSpacing.md + CGFloat(depth * 16) }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 6) {
                Button {
                    withAnimation(AppAnimation.standard) {
                        isExpanded.toggle()
                    }
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.caption2)
                        .foregroundStyle(AppColors.textSecondary)
                        .rotationEffect(.degrees(isExpanded ? 90 : 0))
                        .frame(width: 14, height: 14)
                        .opacity(node.children?.isEmpty == false ? 1 : 0)
                }
                .buttonStyle(.plain)
                .disabled(node.children?.isEmpty == true)

                ZStack(alignment: .leading) {
                    Button {
                        withAnimation(AppAnimation.standard) {
                            onSelect(node.fullPath)
                        }
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "folder.fill")
                                .symbolRenderingMode(.hierarchical)
                                .foregroundStyle(AppColors.textSecondary)
                            Text(node.name)
                                .font(AppTypography.body)
                                .foregroundStyle(AppColors.textPrimary)
                        }
                    }
                    .buttonStyle(.plain)
                    .opacity(0)

                    HStack(spacing: 6) {
                        Image(systemName: "folder.fill")
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(AppColors.textSecondary)
                        Text(node.name)
                            .font(AppTypography.body)
                            .foregroundStyle(AppColors.textPrimary)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
                .onTapGesture(count: 2) {
                    withAnimation(AppAnimation.standard) {
                        isExpanded.toggle()
                    }
                }
                .onTapGesture {
                    withAnimation(AppAnimation.standard) {
                        onSelect(node.fullPath)
                    }
                }
            }
            .frame(minHeight: AppLayoutMetrics.sidebarItemMinHeight, alignment: .leading)
            .padding(.leading, indentPadding)
            .padding(.trailing, AppSpacing.sm)
            .background(isSelected ? AppColors.sidebarActivePill : Color.clear)

            if isExpanded, let children = node.children {
                ForEach(children, id: \.fullPath) { child in
                    if child.isFolder {
                        SidebarFolderRow(node: child, currentPath: currentPath, onSelect: onSelect, onFileSelect: onFileSelect, depth: depth + 1)
                    } else {
                        Button {
                            withAnimation(AppAnimation.standard) {
                                onFileSelect(child.fullPath)
                            }
                        } label: {
                            HStack(spacing: 4) {
                                Image(systemName: "doc")
                                    .font(AppTypography.body)
                                    .foregroundStyle(AppColors.textSecondary)
                                    .symbolRenderingMode(.hierarchical)
                                Text(child.name)
                                    .font(AppTypography.body)
                                    .foregroundStyle(AppColors.textSecondary)
                            }
                        }
                        .buttonStyle(.plain)
                        .frame(minHeight: AppLayoutMetrics.sidebarItemMinHeight, alignment: .leading)
                        .padding(.leading, indentPadding + 14 + 6)
                    }
                }
            }
        }
        .onAppear {
            if isInCurrentPath && !isExpanded {
                isExpanded = true
            }
        }
        .onChange(of: currentPath) { newPath in
            if node.fullPath.isEmpty || newPath.hasPrefix(node.fullPath + "/") {
                if !isExpanded {
                    withAnimation(AppAnimation.standard) {
                        isExpanded = true
                    }
                }
            }
        }
    }
}
