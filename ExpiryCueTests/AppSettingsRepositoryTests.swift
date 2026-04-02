import SwiftData
import XCTest
@testable import ExpiryCue

@MainActor
final class AppSettingsRepositoryTests: XCTestCase {
    func testLoadSettingsCreatesDefaultRecord() throws {
        let container = try makeContainer()
        let repository = SwiftDataAppSettingsRepository(modelContext: container.mainContext)

        let settings = try repository.loadSettings()

        XCTAssertTrue(settings.notificationsEnabled)
        XCTAssertEqual(settings.notifyDaysBefore, 3)
        XCTAssertEqual(try container.mainContext.fetch(FetchDescriptor<AppSettings>()).count, 1)
    }

    func testLoadSettingsCollapsesDuplicatesToOneRecord() throws {
        let container = try makeContainer()
        let context = container.mainContext
        context.insert(AppSettings())
        context.insert(AppSettings(notificationsEnabled: false))
        try context.save()
        let repository = SwiftDataAppSettingsRepository(modelContext: context)

        _ = try repository.loadSettings()

        XCTAssertEqual(try context.fetch(FetchDescriptor<AppSettings>()).count, 1)
    }

    func testUpdateSettingsPersistsChangedValues() throws {
        let container = try makeContainer()
        let repository = SwiftDataAppSettingsRepository(modelContext: container.mainContext)

        let settings = try repository.updateSettings(
            notificationsEnabled: false,
            notifyDaysBefore: 5,
            notifyOneDayBefore: false,
            notifyOnDay: false,
            notificationHour: 14,
            notificationMinute: 45
        )

        XCTAssertFalse(settings.notificationsEnabled)
        XCTAssertEqual(settings.notifyDaysBefore, 5)
        XCTAssertFalse(settings.notifyOneDayBefore)
        XCTAssertFalse(settings.notifyOnDay)
        XCTAssertEqual(settings.notificationHour, 14)
        XCTAssertEqual(settings.notificationMinute, 45)
    }

    private func makeContainer() throws -> ModelContainer {
        try ModelContainer(
            for: AppSettings.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
    }
}
