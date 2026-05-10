//
//  SidebarItemView.swift
//  LatZip
//
//  Flat design: subtle tonal active/hover states, no glossy pills.

import SwiftUI

struct SidebarItemView: View {
    let title: String
    let systemImage: String
    let isActive: Bool
    let action: () -> Void
    @State private var isHovering = false

    var body: some View {
        Button(action: action) {
            HStack(spacing: AppSpacing.md) {
                Image(systemName: systemImage)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(isActive ? AppColors.textPrimary : AppColors.textSecondary)
                    .frame(width: AppLayoutMetrics.sidebarIconColumn, alignment: .center)
                Text(title)
                    .font(.system(size: 13, weight: isActive ? .medium : .regular))
                    .foregroundStyle(AppColors.textPrimary)
                    .lineLimit(1)
                Spacer(minLength: 0)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(backgroundFill)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .onHover { inside in
            isHovering = inside
        }
        .appPointerHover()
    }

    private var backgroundFill: Color {
        if isActive {
            return isDarkMode ? Color.white.opacity(0.08) : Color.black.opacity(0.06)
        }
        if isHovering {
            return isDarkMode ? Color.white.opacity(0.04) : Color.black.opacity(0.035)
        }
        return .clear
    }

    private var isDarkMode: Bool {
        NSApp.effectiveAppearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua
    }
}