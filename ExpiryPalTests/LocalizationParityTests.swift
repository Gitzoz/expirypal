import Foundation
import XCTest

final class LocalizationParityTests: XCTestCase {
    func testDashboardKeysExistInEnglishAndGerman() throws {
        let root = repositoryRoot()
        let en = try localizationKeys(at: root.appendingPathComponent("ExpiryPal/Resources/en.lproj/Localizable.strings").path)
        let de = try localizationKeys(at: root.appendingPathComponent("ExpiryPal/Resources/de.lproj/Localizable.strings").path)

        let required = [
            "dashboard.title",
            "dashboard.section.today",
            "dashboard.section.next3days",
            "dashboard.section.later",
            "dashboard.section.all_active",
            "dashboard.action.add_item",
            "dashboard.empty.title",
            "dashboard.empty.message",
            "addItem.title",
            "addItem.action.cancel",
            "addItem.action.save",
            "addItem.field.name",
            "addItem.field.expiryDate",
            "addItem.field.location",
            "addItem.field.quantity",
            "addItem.field.note",
            "addItem.validation.nameRequired",
            "addItem.validation.quantityInvalid",
            "addItem.validation.generic",
            "location.fridge",
            "location.freezer",
            "location.pantry"
        ]

        for key in required {
            XCTAssertTrue(en.contains(key), "Missing EN key: \(key)")
            XCTAssertTrue(de.contains(key), "Missing DE key: \(key)")
        }
    }

    private func localizationKeys(at path: String) throws -> Set<String> {
        let data = try String(contentsOfFile: path, encoding: .utf8)
        let keys = data
            .split(separator: "\n")
            .compactMap { line -> String? in
                let trimmed = line.trimmingCharacters(in: .whitespaces)
                guard trimmed.hasPrefix("\"") else { return nil }
                guard let end = trimmed.dropFirst().firstIndex(of: "\"") else { return nil }
                return String(trimmed[trimmed.index(after: trimmed.startIndex)..<end])
            }
        return Set(keys)
    }

    private func repositoryRoot() -> URL {
        URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
    }
}
