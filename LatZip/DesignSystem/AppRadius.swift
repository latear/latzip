//
//  AppRadius.swift
//  LatZip
//
//  Squared minimal design: minimal corner radii, mostly 4–6, max 8 only where needed.

import CoreGraphics

enum AppRadius {
    /// Small radius for controls (buttons, chips, tags).
    static let small: CGFloat = 4
    /// Medium radius for inputs, pills, and small containers.
    static let medium: CGFloat = 6
    /// Large radius for panels, cards, and previews. Only used where space demands it.
    static let large: CGFloat = 8
    /// Sheet / modal radius. Kept to 8 for consistency.
    static let sheet: CGFloat = 8
}