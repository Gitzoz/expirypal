import Foundation
import XCTest
@testable import ExpiryPal

@MainActor
final class AddItemViewModelTests: XCTestCase {
    func testSaveRejectsBlankName() throws {
        let clock = TestClock(now: makeDate(year: 2026, month: 3, day: 6, hour: 9))
        let repository = InMemoryFoodItemRepository(items: [], clock: clock)
        let viewModel = AddItemViewModel(
            repository: repository,
            settingsRepository: InMemoryAppSettingsRepository(),
            notificationService: NotificationSchedulingServiceSpy(),
            clock: clock
        )

        viewModel.name = "   "
        viewModel.save()

        XCTAssertEqual(viewModel.validationMessageKey, "addItem.validation.nameRequired")
        XCTAssertFalse(viewModel.didSave)
        XCTAssertTrue(repository.items.isEmpty)
    }

    func testSavePersistsTrimmedItem() throws {
        let clock = TestClock(now: makeDate(year: 2026, month: 3, day: 6, hour: 9))
        let repository = InMemoryFoodItemRepository(items: [], clock: clock)
        let notificationSpy = NotificationSchedulingServiceSpy()
        let viewModel = AddItemViewModel(
            repository: repository,
            settingsRepository: InMemoryAppSettingsRepository(),
            notificationService: notificationSpy,
            clock: clock
        )

        viewModel.name = "  Yogurt  "
        viewModel.quantityText = "2.5"
        viewModel.note = "Breakfast"
        viewModel.save()

        XCTAssertNil(viewModel.validationMessageKey)
        XCTAssertTrue(viewModel.didSave)
        XCTAssertEqual(repository.items.count, 1)
        XCTAssertEqual(repository.items.first?.name, "Yogurt")
        XCTAssertEqual(repository.items.first?.quantity, 2.5)
        XCTAssertEqual(notificationSpy.syncedItemIDs, [repository.items.first!.id])
    }

    func testSaveAllowsBlankQuantity() throws {
        let clock = TestClock(now: makeDate(year: 2026, month: 3, day: 6, hour: 9))
        let repository = InMemoryFoodItemRepository(items: [], clock: clock)
        let viewModel = AddItemViewModel(
            repository: repository,
            settingsRepository: InMemoryAppSettingsRepository(),
            notificationService: NotificationSchedulingServiceSpy(),
            clock: clock
        )

        viewModel.name = "Apples"
        viewModel.quantityText = "   "
        viewModel.save()

        XCTAssertNil(viewModel.validationMessageKey)
        XCTAssertTrue(viewModel.didSave)
        XCTAssertEqual(repository.items.count, 1)
        XCTAssertNil(repository.items.first?.quantity)
    }

    func testSaveRejectsInvalidQuantity() throws {
        let clock = TestClock(now: makeDate(year: 2026, month: 3, day: 6, hour: 9))
        let repository = InMemoryFoodItemRepository(items: [], clock: clock)
        let viewModel = AddItemViewModel(
            repository: repository,
            settingsRepository: InMemoryAppSettingsRepository(),
            notificationService: NotificationSchedulingServiceSpy(),
            clock: clock
        )

        viewModel.name = "Beans"
        viewModel.quantityText = "abc"
        viewModel.save()

        XCTAssertEqual(viewModel.validationMessageKey, "addItem.validation.quantityInvalid")
        XCTAssertFalse(viewModel.didSave)
        XCTAssertTrue(repository.items.isEmpty)
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
