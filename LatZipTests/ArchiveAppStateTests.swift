//
//  ArchiveAppStateTests.swift
//  LatZipTests
//

@testable import LatZip
import XCTest

final class ArchiveAppStateTests: XCTestCase {
    @MainActor
    func testOpeningSecondArchiveReplacesFirstWorkspace() throws {
        let app = ArchiveAppState()
        let firstURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("first.zip")
        let secondURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("second.zip")

        app.openArchive(url: firstURL)
        let firstWorkspace = try XCTUnwrap(app.selectedWorkspace)
        XCTAssertEqual(app.workspaces.count, 1)
        XCTAssertEqual(app.selectedWorkspaceId, firstWorkspace.id)

        app.openArchive(url: secondURL)

        let replacementWorkspace = try XCTUnwrap(app.selectedWorkspace)
        XCTAssertEqual(app.workspaces.count, 1)
        XCTAssertEqual(app.selectedWorkspaceId, replacementWorkspace.id)
        XCTAssertNotEqual(replacementWorkspace.id, firstWorkspace.id)
        XCTAssertEqual(replacementWorkspace.archiveURL, secondURL.standardizedFileURL)
    }

    @MainActor
    func testClosingWorkspaceReturnsToEmptyShell() throws {
        let app = ArchiveAppState()
        let url = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("open.zip")

        app.openArchive(url: url)
        let workspace = try XCTUnwrap(app.selectedWorkspace)

        app.closeWorkspace(workspace)

        XCTAssertTrue(app.workspaces.isEmpty)
        XCTAssertNil(app.selectedWorkspaceId)
        XCTAssertNil(app.selectedWorkspace)
    }

    func testSidebarLocalizationKeysExistInEnglishAndSpanishResources() throws {
        let expectedValues: [String: [String: String]] = [
            "en": [
                "sidebar.settings": "Settings",
                "toolbar.sidebar_toggle.help": "Show or hide the sidebar",
            ],
            "es": [
                "sidebar.settings": "Ajustes",
                "toolbar.sidebar_toggle.help": "Mostrar u ocultar la barra lateral",
            ],
        ]

        for (language, keys) in expectedValues {
            let strings = try localizedStrings(for: language)
            for (key, expectedValue) in keys {
                XCTAssertEqual(strings[key], expectedValue, "\(key) in \(language).lproj")
            }
        }
    }

    private func localizedStrings(for language: String) throws -> [String: String] {
        let url = try XCTUnwrap(
            Bundle.main.url(forResource: "Localizable", withExtension: "strings", subdirectory: "\(language).lproj")
        )
        let dictionary = try XCTUnwrap(NSDictionary(contentsOf: url) as? [String: String])
        return dictionary
    }
}
