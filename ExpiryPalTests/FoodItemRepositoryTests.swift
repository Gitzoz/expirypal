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

    func testFetchArchivedItemsIncludesOnlyNonActiveStatuses() throws {
        let container = try makeContainer()
        let context = container.mainContext
        let repository = SwiftDataFoodItemRepository(
            modelContext: context,
            clock: TestClock(now: makeDate(year: 2026, month: 3, day: 6, hour: 9))
        )

        context.insert(
            FoodItem(
                name: "Discarded Soup",
                expiryDate: makeDate(year: 2026, month: 3, day: 7, hour: 9),
                location: .pantry,
                quantity: nil,
                note: nil,
                status: .discarded,
                createdAt: makeDate(year: 2026, month: 3, day: 6, hour: 9),
                updatedAt: makeDate(year: 2026, month: 3, day: 7, hour: 9)
            )
        )
        context.insert(
            FoodItem(
                name: "Active Milk",
                expiryDate: makeDate(year: 2026, month: 3, day: 8, hour: 9),
                location: .fridge,
                quantity: nil,
                note: nil,
                status: .active,
                createdAt: makeDate(year: 2026, month: 3, day: 6, hour: 9),
                updatedAt: makeDate(year: 2026, month: 3, day: 6, hour: 9)
            )
        )
        try context.save()

        let items = try repository.fetchArchivedItemsSortedByUpdatedAtDescending()

        XCTAssertEqual(items.map(\.name), ["Discarded Soup"])
    }

    func testUpdateItemChangesFieldsAndUpdatedAt() throws {
        let clock = TestClock(now: makeDate(year: 2026, month: 3, day: 6, hour: 9))
        let container = try makeContainer()
        let repository = SwiftDataFoodItemRepository(modelContext: container.mainContext, clock: clock)
        let item = try repository.addItem(
            name: "Milk",
            expiryDate: makeDate(year: 2026, month: 3, day: 7, hour: 9),
            location: .fridge,
            quantity: nil,
            note: nil
        )
        clock.now = makeDate(year: 2026, month: 3, day: 6, hour: 12)

        let updated = try repository.updateItem(
            id: item.id,
            name: "Yogurt",
            expiryDate: makeDate(year: 2026, month: 3, day: 8, hour: 9),
            location: .pantry,
            quantity: 2,
            note: "Breakfast"
        )

        XCTAssertEqual(updated.name, "Yogurt")
        XCTAssertEqual(updated.location, .pantry)
        XCTAssertEqual(updated.quantity, 2)
        XCTAssertEqual(updated.updatedAt, clock.now)
    }

    func testUpdateStatusMovesItemOutOfActiveQueries() throws {
        let container = try makeContainer()
        let repository = SwiftDataFoodItemRepository(
            modelContext: container.mainContext,
            clock: TestClock(now: makeDate(year: 2026, month: 3, day: 6, hour: 9))
        )
        let item = try repository.addItem(
            name: "Milk",
            expiryDate: makeDate(year: 2026, month: 3, day: 7, hour: 9),
            location: .fridge,
            quantity: nil,
            note: nil
        )

        _ = try repository.updateStatus(id: item.id, status: .consumed)

        XCTAssertTrue(try repository.fetchActiveItemsSortedByExpiryDate().isEmpty)
        XCTAssertEqual(try repository.fetchArchivedItemsSortedByUpdatedAtDescending().map(\.name), ["Milk"])
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

    func testAppInMemoryRepositorySupportsArchiveAndLookupFlows() throws {
        let now = makeDate(year: 2026, month: 3, day: 6, hour: 9)
        let archived = FoodItem(
            name: "Soup",
            expiryDate: makeDate(year: 2026, month: 3, day: 5, hour: 9),
            location: .pantry,
            quantity: nil,
            note: nil,
            status: .discarded,
            createdAt: now,
            updatedAt: makeDate(year: 2026, month: 3, day: 6, hour: 10)
        )
        let active = FoodItem(
            name: "Milk",
            expiryDate: makeDate(year: 2026, month: 3, day: 7, hour: 9),
            location: .fridge,
            quantity: nil,
            note: nil,
            createdAt: now,
            updatedAt: now
        )
        let repository = ExpiryPal.InMemoryFoodItemRepository(items: [active, archived], clock: TestClock(now: now))

        let archivedItems = try repository.fetchArchivedItemsSortedByUpdatedAtDescending()
        let fetchedItem = try repository.fetchItem(id: active.id)

        XCTAssertEqual(archivedItems.map(\.name), ["Soup"])
        XCTAssertEqual(fetchedItem?.id, active.id)
    }

    func testAppInMemoryRepositoryRejectsInvalidOperations() {
        let now = makeDate(year: 2026, month: 3, day: 6, hour: 9)
        let repository = ExpiryPal.InMemoryFoodItemRepository(items: [], clock: TestClock(now: now))

        XCTAssertThrowsError(
            try repository.addItem(
                name: "   ",
                expiryDate: makeDate(year: 2026, month: 3, day: 7, hour: 9),
                location: .fridge,
                quantity: nil,
                note: nil
            )
        )

        XCTAssertThrowsError(
            try repository.updateItem(
                id: UUID(),
                name: "Milk",
                expiryDate: makeDate(year: 2026, month: 3, day: 7, hour: 9),
                location: .fridge,
                quantity: nil,
                note: nil
            )
        )

        XCTAssertThrowsError(
            try repository.updateStatus(id: UUID(), status: .consumed)
        )
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
