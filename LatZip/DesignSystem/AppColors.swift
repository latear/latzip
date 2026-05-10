//
//  AppColors.swift
//  LatZip
//

import AppKit
import SwiftUI

/// Colores semánticos (light / dark vía `NSColor` y opacidades sobre `Color.primary`).
enum AppColors {
    static var appBackground: Color { Color(nsColor: .windowBackgroundColor) }
    static var contentBackground: Color { Color(nsColor: .textBackgroundColor) }
    static var panelBackground: Color { Color(nsColor: .controlBackgroundColor) }
    /// Franja de cabecera de lista sobre `contentBackground`: sutil en claro y oscuro.
    static var listHeaderTint: Color { Color.primary.opacity(0.048) }

    static var textPrimary: Color { Color.primary }
    static var textSecondary: Color { Color.secondary }
    static var textTertiary: Color { Color(nsColor: .tertiaryLabelColor) }
    static var textQuaternary: Color { Color(nsColor: .quaternaryLabelColor) }

    static var rowHover: Color { Color.primary.opacity(0.068) }
    static var rowSelection: Color { Color.accentColor.opacity(0.20) }
    /// Línea entre filas: más suave que `separator` para no competir con la selección.
    static var rowSeparator: Color { Color.primary.opacity(0.055) }
    static var separator: Color { Color.primary.opacity(0.075) }
    static var separatorStrong: Color { Color.primary.opacity(0.10) }
    static var hairlineBorder: Color { Color.primary.opacity(0.06) }
    static var panelBorder: Color { Color.primary.opacity(0.08) }

    static var accentSoft: Color { Color.accentColor.opacity(0.14) }
    static var accentSoftStrong: Color { Color.accentColor.opacity(0.16) }
    static var crumbIdleFill: Color { Color.primary.opacity(0.055) }

    static var skeletonBase: Color { Color.primary.opacity(0.05) }
    static var skeletonHighlight: Color { Color.primary.opacity(0.095) }

    static var overlayDim: Color { Color.black.opacity(0.22) }
    static var dropHighlight: Color { Color.accentColor.opacity(0.08) }
    static var sidebarGradientTop: Color { Color.primary.opacity(0.035) }

    // Sidebar-specific chroming (dark rail in dark mode, warm panel in light mode)
    static var sidebarRailBackground: Color {
        Color(nsColor: NSColor(name: nil) { appearance in
            let isDark = appearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua
            return NSColor(hex: isDark ? "#1a1a1a" : "#f7f6e8")
        })
    }

    static var sidebarRailBorder: Color {
        Color(nsColor: NSColor(name: nil) { appearance in
            let isDark = appearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua
            return NSColor(hex: isDark ? "#333333" : "#d6d5c8")
        })
    }

    static var sidebarActivePill: Color {
        Color(nsColor: NSColor(name: nil) { appearance in
            let isDark = appearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua
            return isDark
                ? NSColor.white.withAlphaComponent(0.12)
                : NSColor.black.withAlphaComponent(0.10)
        })
    }

    static var sidebarHoverPill: Color {
        Color(nsColor: NSColor(name: nil) { appearance in
            let isDark = appearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua
            return isDark
                ? NSColor.white.withAlphaComponent(0.05)
                : NSColor.black.withAlphaComponent(0.05)
        })
    }
}

private extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8) & 0xFF) / 255
        let b = Double(int & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}

private extension NSColor {
    convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = CGFloat((int >> 16) & 0xFF) / 255
        let g = CGFloat((int >> 8) & 0xFF) / 255
        let b = CGFloat(int & 0xFF) / 255
        self.init(srgbRed: r, green: g, blue: b, alpha: 1)
    }
}
