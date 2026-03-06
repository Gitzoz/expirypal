import Foundation
import XCTest
@testable import ExpiryPal

@MainActor
final class SettingsViewModelTests: XCTestCase {
    func testLoadUsesPersistedSettings() {
        let settings = AppSettings(
            notificationsEnabled: false,
            notifyDaysBefore: 5,
            notifyOneDayBefore: false,
            notifyOnDay: true,
            notificationHour: 14,
            notificationMinute: 30
        )
        let viewModel = SettingsViewModel(
            settingsRepository: InMemoryAppSettingsRepository(settings: settings),
            foodItemRepository: InMemoryFoodItemRepository(items: [], clock: TestClock(now: makeDate(year: 2026, month: 3, day: 6, hour: 9))),
            notificationService: NotificationSchedulingServiceSpy(),
            clock: TestClock(now: makeDate(year: 2026, month: 3, day: 6, hour: 9))
        )

        viewModel.load()

        XCTAssertFalse(viewModel.notificationsEnabled)
        XCTAssertEqual(viewModel.notifyDaysBefore, 5)
        XCTAssertFalse(viewModel.notifyOneDayBefore)
    }

    func testSavePersistsSettingsAndReschedulesActiveItems() {
        let clock = TestClock(now: makeDate(year: 2026, month: 3, day: 6, hour: 9))
        let activeItem = FoodItem(
            name: "Bread",
            expiryDate: makeDate(year: 2026, month: 3, day: 8, hour: 9),
            location: .pantry,
            quantity: nil,
            note: nil,
            createdAt: clock.now,
            updatedAt: clock.now
        )
        let settingsRepository = InMemoryAppSettingsRepository()
        let foodRepository = InMemoryFoodItemRepository(items: [activeItem], clock: clock)
        let notificationSpy = NotificationSchedulingServiceSpy()
        let viewModel = SettingsViewModel(
            settingsRepository: settingsRepository,
            foodItemRepository: foodRepository,
            notificationService: notificationSpy,
            clock: clock
        )

        viewModel.load()
        viewModel.notificationsEnabled = false
        viewModel.notifyDaysBefore = 2
        viewModel.save()

        XCTAssertTrue(viewModel.didSave)
        XCTAssertFalse(settingsRepository.settings.notificationsEnabled)
        XCTAssertEqual(settingsRepository.settings.notifyDaysBefore, 2)
        XCTAssertEqual(notificationSpy.syncedBatchItemIDs, [[activeItem.id]])
    }

    private func makeDate(year: Int, month: Int, day: Int, hour: Int) -> Date {
        var comps = DateComponents()
        comps.year = year
        comps.month = month
        comps.day = day
        comps.hour = hour
        comps.minute = 0
        comps.second = 0
        comps.timeZone = TimeZone(secondsFromGMT: 0)
        return Calendar(identifier: .gregorian).date(from: comps)!
    }
}
