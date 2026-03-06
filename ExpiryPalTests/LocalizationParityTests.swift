import XCTest

final class LocalizationParityTests: XCTestCase {
    func testDashboardKeysExistInEnglishAndGerman() throws {
        let english = try loadStrings(languageCode: "en")
        let german = try loadStrings(languageCode: "de")
        let requiredKeys = [
            "tab.dashboard",
            "tab.archive",
            "tab.settings",
            "dashboard.title",
            "dashboard.section.today",
            "dashboard.section.next3days",
            "dashboard.section.later",
            "dashboard.section.all_active",
            "dashboard.action.add_item",
            "dashboard.action.consume",
            "dashboard.action.discard",
            "dashboard.empty.title",
            "dashboard.empty.message",
            "archive.title",
            "archive.empty.title",
            "archive.empty.message",
            "archive.status.consumed",
            "archive.status.discarded",
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
            "editItem.title",
            "editItem.action.cancel",
            "editItem.action.save",
            "editItem.action.markConsumed",
            "editItem.action.markDiscarded",
            "editItem.field.name",
            "editItem.field.expiryDate",
            "editItem.field.location",
            "editItem.field.quantity",
            "editItem.field.note",
            "editItem.section.status",
            "editItem.validation.nameRequired",
            "editItem.validation.quantityInvalid",
            "editItem.validation.generic",
            "settings.title",
            "settings.section.notifications",
            "settings.action.save",
            "settings.field.notificationsEnabled",
            "settings.field.notifyDaysBefore",
            "settings.field.notifyOneDayBefore",
            "settings.field.notifyOnDay",
            "settings.field.notificationTime",
            "settings.validation.generic",
            "location.fridge",
            "location.freezer",
            "location.pantry",
            "notification.title.future",
            "notification.title.tomorrow",
            "notification.title.today",
            "notification.body.future",
            "notification.body.tomorrow",
            "notification.body.today"
        ]

        for key in requiredKeys {
            XCTAssertNotNil(english[key], "Missing English key: \(key)")
            XCTAssertNotNil(german[key], "Missing German key: \(key)")
        }
    }

    private func loadStrings(languageCode: String) throws -> [String: String] {
        let url = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appendingPathComponent("ExpiryPal/Resources/\(languageCode).lproj/Localizable.strings")

        return NSDictionary(contentsOf: url) as? [String: String] ?? [:]
    }
}
