import SwiftData
import XCTest
@testable import ExpiryPal

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

    private func makeContainer() throws -> ModelContainer {
        try ModelContainer(
            for: AppSettings.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
    }
}
