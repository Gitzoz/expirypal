import Foundation
import XCTest
@testable import ExpiryPal

final class FoodItemModelTests: XCTestCase {
    func testInitializerTrimsWhitespaceFromName() {
        let item = FoodItem(
            name: "  Milk  ",
            expiryDate: makeDate(year: 2026, month: 3, day: 7),
            location: .fridge,
            quantity: nil,
            note: nil,
            createdAt: makeDate(year: 2026, month: 3, day: 6),
            updatedAt: makeDate(year: 2026, month: 3, day: 6)
        )

        XCTAssertEqual(item.name, "Milk")
    }

    func testNameSetterKeepsTrimmedValue() {
        let item = FoodItem(
            name: "Milk",
            expiryDate: makeDate(year: 2026, month: 3, day: 7),
            location: .fridge,
            quantity: nil,
            note: nil,
            createdAt: makeDate(year: 2026, month: 3, day: 6),
            updatedAt: makeDate(year: 2026, month: 3, day: 6)
        )

        item.name = "  Yogurt  "

        XCTAssertEqual(item.name, "Yogurt")
    }

    func testInvalidRawValuesFallbackSafely() {
        let item = FoodItem(
            name: "Milk",
            expiryDate: makeDate(year: 2026, month: 3, day: 7),
            location: .fridge,
            quantity: nil,
            note: nil,
            createdAt: makeDate(year: 2026, month: 3, day: 6),
            updatedAt: makeDate(year: 2026, month: 3, day: 6)
        )
        item.locationRaw = "unknown"
        item.statusRaw = "broken"

        XCTAssertEqual(item.location, .fridge)
        XCTAssertEqual(item.status, .active)
    }

    private func makeDate(year: Int, month: Int, day: Int) -> Date {
        var components = DateComponents()
        components.calendar = Calendar(identifier: .gregorian)
        components.timeZone = TimeZone(secondsFromGMT: 0)
        components.year = year
        components.month = month
        components.day = day
        components.hour = 9
        return components.date ?? Date(timeIntervalSince1970: 0)
    }
}
