import Foundation
import XCTest
@testable import ExpiryPal

@MainActor
final class DashboardSegmentationTests: XCTestCase {
    private let calendar = Calendar(identifier: .gregorian)

    func testOverdueItemIsInToday() throws {
        let now = makeDate(year: 2026, month: 3, day: 5, hour: 9)
        let clock = TestClock(now: now)
        let overdue = makeItem(name: "Milk", expiryDate: makeDate(year: 2026, month: 3, day: 4, hour: 20))
        let repository = InMemoryFoodItemRepository(items: [overdue], clock: clock)
        let viewModel = DashboardViewModel(
            repository: repository,
            settingsRepository: InMemoryAppSettingsRepository(),
            notificationService: NotificationSchedulingServiceSpy(),
            clock: clock,
            calendar: calendar
        )

        viewModel.load()

        XCTAssertEqual(viewModel.todayItems.count, 1)
        XCTAssertEqual(viewModel.next3DaysItems.count, 0)
        XCTAssertEqual(viewModel.laterItems.count, 0)
    }

    func testBoundaryDatesAreSegmentedCorrectly() throws {
        let now = makeDate(year: 2026, month: 3, day: 5, hour: 9)
        let startOfToday = calendar.startOfDay(for: now)
        let startOfTomorrow = calendar.date(byAdding: .day, value: 1, to: startOfToday)!
        let day4 = calendar.date(byAdding: .day, value: 4, to: startOfToday)!

        let items = [
            makeItem(name: "Today", expiryDate: startOfToday),
            makeItem(name: "Next3", expiryDate: startOfTomorrow),
            makeItem(name: "Later", expiryDate: day4)
        ]

        let viewModel = DashboardViewModel(
            repository: InMemoryFoodItemRepository(items: items, clock: TestClock(now: now)),
            settingsRepository: InMemoryAppSettingsRepository(),
            notificationService: NotificationSchedulingServiceSpy(),
            clock: TestClock(now: now),
            calendar: calendar
        )

        viewModel.load()

        XCTAssertEqual(viewModel.todayItems.map(\.name), ["Today"])
        XCTAssertEqual(viewModel.next3DaysItems.map(\.name), ["Next3"])
        XCTAssertEqual(viewModel.laterItems.map(\.name), ["Later"])
    }

    func testOnlyActiveItemsAppearAndAreSortedAscending() throws {
        let now = makeDate(year: 2026, month: 3, day: 5, hour: 9)
        let clock = TestClock(now: now)
        let items = [
            makeItem(name: "B", expiryDate: makeDate(year: 2026, month: 3, day: 8, hour: 9), status: .active),
            makeItem(name: "Discarded", expiryDate: makeDate(year: 2026, month: 3, day: 6, hour: 9), status: .discarded),
            makeItem(name: "A", expiryDate: makeDate(year: 2026, month: 3, day: 6, hour: 9), status: .active)
        ]

        let viewModel = DashboardViewModel(
            repository: InMemoryFoodItemRepository(items: items, clock: clock),
            settingsRepository: InMemoryAppSettingsRepository(),
            notificationService: NotificationSchedulingServiceSpy(),
            clock: clock,
            calendar: calendar
        )

        viewModel.load()

        XCTAssertEqual(viewModel.allActiveItems.map(\.name), ["A", "B"])
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
        return calendar.date(from: comps)!
    }

    private func makeItem(name: String, expiryDate: Date, status: ItemStatus = .active) -> FoodItem {
        FoodItem(
            id: UUID(),
            name: name,
            expiryDate: expiryDate,
            location: .fridge,
            quantity: nil,
            note: nil,
            status: status,
            createdAt: expiryDate,
            updatedAt: expiryDate
        )
    }
}
