//
//  PanelCardView.swift
//  LatZip
//
//  Flat design: flat tonal surface, hairline border, no shadow or gradient strip.

import SwiftUI

struct PanelCardView<Content: View>: View {
    @ViewBuilder let content: () -> Content

    var body: some View {
        content()
            .padding(.horizontal, AppSpacing.xl)
            .padding(.vertical, AppSpacing.xl)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .background(AppColors.contentBackground)
            .overlay {
                RoundedRectangle(cornerRadius: AppRadius.medium, style: .continuous)
                    .strokeBorder(AppColors.hairlineBorder, lineWidth: 0.75)
            }
            .padding(AppSpacing.md)
    }
}