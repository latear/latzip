//
//  ArchiveKeychainPreference.swift
//  LatZip
//

import Foundation

/// Preferencia global: permitir guardar contraseñas de archivos cifrados en el Llavero.
enum ArchiveKeychainPreference {
    /// Canonical key documented in AGENTS.md / UserDefaults table.
    static let userDefaultsKey = "latzip.archivePasswordKeychainEnabled"
    /// Legacy key kept for backward-compat migration.
    private static let legacyUserDefaultsKey = "latzip.archivePasswordKeychain"

    static var isEnabled: Bool {
        let defaults = UserDefaults.standard
        if defaults.object(forKey: userDefaultsKey) != nil {
            return defaults.bool(forKey: userDefaultsKey)
        }
        if defaults.object(forKey: legacyUserDefaultsKey) != nil {
            return defaults.bool(forKey: legacyUserDefaultsKey)
        }
        return false
    }

    static func setEnabled(_ enabled: Bool) {
        let defaults = UserDefaults.standard
        defaults.set(enabled, forKey: userDefaultsKey)
        // Write-through migration: once touched, old key is retired.
        defaults.removeObject(forKey: legacyUserDefaultsKey)
    }
}
