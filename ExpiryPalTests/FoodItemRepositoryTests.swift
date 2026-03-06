import Foundation
import SwiftData
import XCTest
@testable import ExpiryPal

@MainActor
final class FoodItemRepositoryTests: XCTestCase {
    func testAddItemTrimsNameAndFetchesSortedActiveItems() throws {
        let container = try makeContainer()
        let repository = SwiftDataFoodItemRepository(
            modelContext: container.mainContext,
            clock: TestClock(now: makeDate(year: 2026, month: 3, day: 6, hour: 9))
        )

        _ = try repository.addItem(
            name: "  Rice  ",
            expiryDate: makeDate(year: 2026, month: 3, day: 9, hour: 9),
            location: .pantry,
            quantity: nil,
            note: nil
        )
        _ = try repository.addItem(
            name: "Milk",
            expiryDate: makeDate(year: 2026, month: 3, day: 7, hour: 9),
            location: .fridge,
            quantity: nil,
            note: nil
        )

        let items = try repository.fetchActiveItemsSortedByExpiryDate()

        XCTAssertEqual(items.map(\.name), ["Milk", "Rice"])
    }

    func testFetchActiveItemsExcludesNonActiveStatuses() throws {
        let container = try makeContainer()
        let context = container.mainContext
        let repository = SwiftDataFoodItemRepository(
            modelContext: context,
            clock: TestClock(now: makeDate(year: 2026, month: 3, day: 6, hour: 9))
        )

        context.insert(
            FoodItem(
                name: "Archived",
                expiryDate: makeDate(year: 2026, month: 3, day: 7, hour: 9),
                location: .pantry,
                quantity: nil,
                note: nil,
                status: .discarded,
                createdAt: makeDate(year: 2026, month: 3, day: 6, hour: 9),
                updatedAt: makeDate(year: 2026, month: 3, day: 6, hour: 9)
            )
        )
        try context.save()

        let items = try repository.fetchActiveItemsSortedByExpiryDate()

        XCTAssertTrue(items.isEmpty)
    }

    func testAddItemRejectsBlankTrimmedName() throws {
        let container = try makeContainer()
        let repository = SwiftDataFoodItemRepository(
            modelContext: container.mainContext,
            clock: TestClock(now: makeDate(year: 2026, month: 3, day: 6, hour: 9))
        )

        XCTAssertThrowsError(
            try repository.addItem(
                name: "   ",
                expiryDate: makeDate(year: 2026, month: 3, day: 7, hour: 9),
                location: .fridge,
                quantity: nil,
                note: nil
            )
        ) { error in
            XCTAssertEqual(error as? FoodItemRepositoryError, .invalidName)
        }
    }

    func testAddItemAllowsNilQuantity() throws {
        let container = try makeContainer()
        let repository = SwiftDataFoodItemRepository(
            modelContext: container.mainContext,
            clock: TestClock(now: makeDate(year: 2026, month: 3, day: 6, hour: 9))
        )

        let item = try repository.addItem(
            name: "Bread",
            expiryDate: makeDate(year: 2026, month: 3, day: 8, hour: 9),
            location: .pantry,
            quantity: nil,
            note: nil
        )

        XCTAssertNil(item.quantity)
    }

    private func makeContainer() throws -> ModelContainer {
        try ModelContainer(
            for: FoodItem.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
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
