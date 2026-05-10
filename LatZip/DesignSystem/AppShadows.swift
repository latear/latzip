//
//  AppShadows.swift
//  LatZip
//
//  Flat design: near-zero elevation — no panel, card or floating shadows.
//  Only subtle hairline borders and tonal separators remain.

import SwiftUI

enum AppShadow {
    /// Hairline inset for search field (flat design — no elevation shadow).
    static let searchField = (color: Color.clear, radius: CGFloat(0), x: CGFloat(0), y: CGFloat(0))
}