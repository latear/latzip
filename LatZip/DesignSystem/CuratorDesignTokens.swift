//
//  CuratorDesignTokens.swift
//  LatZip — Flat Minimal Design Tokens
//

import SwiftUI

/// Shared visual tokens for a cohesive flat design across the app.
enum CuratorDesignTokens {
    static let accentBlue = Color(red: 0, green: 122 / 255, blue: 1)

    /// Sidebar rail background (dark in dark mode, warm light in light mode).
    static let sidebarMaterial: Color = Color.clear

    /// Header title for library views.
    static let libraryTitle = Font.system(size: 17, weight: .semibold)
    static let librarySubtitle = Font.system(size: 12, weight: .medium)

    /// Metadata label (flat style — no elevation).
    static let metadataLabel = Font.system(size: 11, weight: .medium)

    /// Unified corner radius — squared minimal, not oversized.
    static let cardRadius: CGFloat = 6
    static let buttonRadius: CGFloat = 4
    static let rowComfortPadding: CGFloat = 10

    /// Flat border widths (hairline — 0.75pt).
    static let hairlineWidth: CGFloat = 0.75
}