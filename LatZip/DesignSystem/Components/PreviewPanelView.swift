//
//  PreviewPanelView.swift
//  LatZip
//
//  Flat design: flat sections, no elevated card chrome.

import SwiftUI

struct PreviewPanelView<Preview: View, Metadata: View>: View {
    let title: String
    let subtitle: String
    @ViewBuilder let preview: () -> Preview
    @ViewBuilder let metadata: () -> Metadata

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                Text(title)
                    .font(AppTypography.appTitle)
                    .foregroundStyle(AppColors.textPrimary)
                    .lineLimit(2)
                Text(subtitle)
                    .font(AppTypography.sectionHeader)
                    .fontWeight(.semibold)
                    .foregroundStyle(AppColors.textTertiary)
                    .textCase(.uppercase)
                    .tracking(AppLayoutMetrics.sectionTracking * 0.85)
            }
            .padding(.bottom, AppSpacing.xs)

            preview()
                .padding(.top, AppSpacing.xs)
                .transition(.opacity.combined(with: .move(edge: .bottom)))
                .animation(AppAnimation.panelReveal, value: title)

            Rectangle()
                .fill(AppColors.separator)
                .frame(maxWidth: .infinity)
                .frame(height: 0.5)
                .padding(.top, AppSpacing.lg)
                .padding(.bottom, AppSpacing.sm)

            metadata()
        }
        .frame(minWidth: 300, idealWidth: 340, maxWidth: 400, maxHeight: .infinity, alignment: .topLeading)
        .background(AppColors.appBackground)
        .padding(AppSpacing.lg)
    }
}