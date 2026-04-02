import Foundation
import XCTest
@testable import ExpiryCue

@MainActor
final class EditItemViewModelTests: XCTestCase {
    func testSaveUpdatesExistingItemAndSchedulesNotifications() throws {
        let clock = TestClock(now: makeDate(year: 2026, month: 3, day: 6, hour: 9))
        let item = FoodItem(
            name: "Milk",
            expiryDate: makeDate(year: 2026, month: 3, day: 7, hour: 9),
            location: .fridge,
            quantity: 1,
            note: nil,
            createdAt: clock.now,
            updatedAt: clock.now
        )
        let repository = InMemoryFoodItemRepository(items: [item], clock: clock)
        let settingsRepository = InMemoryAppSettingsRepository()
        let notificationSpy = NotificationSchedulingServiceSpy()
        let viewModel = EditItemViewModel(
            item: item,
            repository: repository,
            settingsRepository: settingsRepository,
            notificationService: notificationSpy
        )

        viewModel.name = "Greek Yogurt"
        viewModel.quantityText = "2"
        viewModel.save()

        XCTAssertTrue(viewModel.didSave)
        XCTAssertEqual(item.name, "Greek Yogurt")
        XCTAssertEqual(item.quantity, 2)
        XCTAssertEqual(notificationSpy.syncedItemIDs, [item.id])
    }

    func testSaveRejectsBlankName() {
        let clock = TestClock(now: makeDate(year: 2026, month: 3, day: 6, hour: 9))
        let item = FoodItem(
            name: "Milk",
            expiryDate: makeDate(year: 2026, month: 3, day: 7, hour: 9),
            location: .fridge,
            quantity: nil,
            note: nil,
            createdAt: clock.now,
            updatedAt: clock.now
        )
        let viewModel = EditItemViewModel(
            item: item,
            repository: InMemoryFoodItemRepository(items: [item], clock: clock),
            settingsRepository: InMemoryAppSettingsRepository(),
            notificationService: NotificationSchedulingServiceSpy()
        )

        viewModel.name = "   "
        viewModel.save()

        XCTAssertEqual(viewModel.validationMessageKey, "editItem.validation.nameRequired")
        XCTAssertFalse(viewModel.didSave)
    }

    func testMarkConsumedCancelsNotificationsAndCompletesArchiveFlow() {
        let clock = TestClock(now: makeDate(year: 2026, month: 3, day: 6, hour: 9))
        let item = FoodItem(
            name: "Milk",
            expiryDate: makeDate(year: 2026, month: 3, day: 7, hour: 9),
            location: .fridge,
            quantity: nil,
            note: nil,
            createdAt: clock.now,
            updatedAt: clock.now
        )
        let notificationSpy = NotificationSchedulingServiceSpy()
        let viewModel = EditItemViewModel(
            item: item,
            repository: InMemoryFoodItemRepository(items: [item], clock: clock),
            settingsRepository: InMemoryAppSettingsRepository(),
            notificationService: notificationSpy
        )

        viewModel.markConsumed()

        XCTAssertTrue(viewModel.didArchive)
        XCTAssertEqual(item.status, .consumed)
        XCTAssertEqual(notificationSpy.cancelledItemIDs, [item.id])
    }

    func testSaveRejectsInvalidQuantity() {
        let clock = TestClock(now: makeDate(year: 2026, month: 3, day: 6, hour: 9))
        let item = FoodItem(
            name: "Milk",
            expiryDate: makeDate(year: 2026, month: 3, day: 7, hour: 9),
            location: .fridge,
            quantity: nil,
            note: nil,
            createdAt: clock.now,
            updatedAt: clock.now
        )
        let viewModel = EditItemViewModel(
            item: item,
            repository: InMemoryFoodItemRepository(items: [item], clock: clock),
            settingsRepository: InMemoryAppSettingsRepository(),
            notificationService: NotificationSchedulingServiceSpy()
        )

        viewModel.quantityText = "abc"
        viewModel.save()

        XCTAssertEqual(viewModel.validationMessageKey, "editItem.validation.quantityInvalid")
        XCTAssertFalse(viewModel.didSave)
    }

    func testMarkDiscardedCancelsNotificationsAndCompletesArchiveFlow() {
        let clock = TestClock(now: makeDate(year: 2026, month: 3, day: 6, hour: 9))
        let item = FoodItem(
            name: "Soup",
            expiryDate: makeDate(year: 2026, month: 3, day: 8, hour: 9),
            location: .pantry,
            quantity: nil,
            note: nil,
            createdAt: clock.now,
            updatedAt: clock.now
        )
        let notificationSpy = NotificationSchedulingServiceSpy()
        let viewModel = EditItemViewModel(
            item: item,
            repository: InMemoryFoodItemRepository(items: [item], clock: clock),
            settingsRepository: InMemoryAppSettingsRepository(),
            notificationService: notificationSpy
        )

        viewModel.markDiscarded()

        XCTAssertTrue(viewModel.didArchive)
        XCTAssertEqual(item.status, .discarded)
        XCTAssertEqual(notificationSpy.cancelledItemIDs, [item.id])
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
