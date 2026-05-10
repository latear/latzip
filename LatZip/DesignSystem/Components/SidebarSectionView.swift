//
//  SidebarSectionView.swift
//  LatZip
//

import SwiftUI

/// Section header for sidebar with flat, restrained styling.
struct SidebarSectionView<Content: View>: View {
    let title: String
    let systemImage: String
    @ViewBuilder let content: () -> Content

    var body: some View {
        Section {
            content()
        } header: {
            HStack(alignment: .center, spacing: AppSpacing.sm) {
                Image(systemName: systemImage)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(AppColors.textSecondary)
                    .frame(width: AppLayoutMetrics.sidebarIconColumn, alignment: .center)
                Text(title)
                    .font(.system(size: 10.5, weight: .semibold))
                    .foregroundStyle(AppColors.textSecondary)
                    .textCase(.uppercase)
                    .tracking(0.8)
                Spacer(minLength: 0)
            }
            .padding(.top, AppSpacing.md)
            .padding(.bottom, AppSpacing.xs)
            .padding(.horizontal, AppLayoutMetrics.sidebarSectionHeaderHorizontalInset)
        }
    }
}