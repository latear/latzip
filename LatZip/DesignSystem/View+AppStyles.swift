//
//  View+AppStyles.swift
//  LatZip
//
//  Flat design: hairline border cards, no shadows or glow.

import AppKit
import SwiftUI

extension View {
    /// Cursor de mano en elementos clicables (macOS).
    func appPointerHover() -> some View {
        modifier(AppPointerHoverModifier())
    }

    /// Flat card with hairline border — no shadow, no glow.
    func appCardChrome(cornerRadius: CGFloat = AppRadius.medium) -> some View {
        background {
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(AppColors.panelBackground)
        }
        .overlay {
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .strokeBorder(AppColors.hairlineBorder, lineWidth: 0.75)
        }
    }
}

private struct AppPointerHoverModifier: ViewModifier {
    func body(content: Content) -> some View {
        content.onHover { inside in
            if inside {
                NSCursor.pointingHand.push()
            } else {
                NSCursor.pop()
            }
        }
    }
}