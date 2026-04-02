import Foundation
import UserNotifications
import XCTest
@testable import ExpiryCue

final class NotificationSchedulingServiceTests: XCTestCase {
    func testSyncNotificationsCreatesStableIdentifiersAndCancelsFirst() {
        let center = UserNotificationCenterSpy()
        let clock = TestClock(now: makeDate(year: 2026, month: 3, day: 6, hour: 9))
        let service = LocalNotificationSchedulingService(center: center, clock: clock, calendar: Calendar(identifier: .gregorian), locale: Locale(identifier: "en_US"), bundle: .main)
        let item = FoodItem(
            name: "Milk",
            expiryDate: makeDate(year: 2026, month: 3, day: 10, hour: 12),
            location: .fridge,
            quantity: nil,
            note: nil,
            createdAt: clock.now,
            updatedAt: clock.now
        )
        let settings = AppSettings()

        service.syncNotifications(for: item, settings: settings)

        XCTAssertEqual(center.removedIdentifiers.first ?? [], [
            "fooditem.\(item.id.uuidString).d3",
            "fooditem.\(item.id.uuidString).d1",
            "fooditem.\(item.id.uuidString).d0"
        ])
        XCTAssertEqual(center.addedRequests.map(\.identifier).sorted(), [
            "fooditem.\(item.id.uuidString).d0",
            "fooditem.\(item.id.uuidString).d1",
            "fooditem.\(item.id.uuidString).d3"
        ])
    }

    func testSyncNotificationsSkipsPastTriggers() {
        let center = UserNotificationCenterSpy()
        let clock = TestClock(now: makeDate(year: 2026, month: 3, day: 6, hour: 10))
        let service = LocalNotificationSchedulingService(center: center, clock: clock, calendar: Calendar(identifier: .gregorian), locale: Locale(identifier: "en_US"), bundle: .main)
        let item = FoodItem(
            name: "Milk",
            expiryDate: makeDate(year: 2026, month: 3, day: 6, hour: 12),
            location: .fridge,
            quantity: nil,
            note: nil,
            createdAt: clock.now,
            updatedAt: clock.now
        )
        let settings = AppSettings(notificationHour: 9, notificationMinute: 0)

        service.syncNotifications(for: item, settings: settings)

        XCTAssertTrue(center.addedRequests.isEmpty)
    }

    func testSyncNotificationsForItemsRemovesAllWhenDisabled() {
        let center = UserNotificationCenterSpy()
        let clock = TestClock(now: makeDate(year: 2026, month: 3, day: 6, hour: 9))
        let service = LocalNotificationSchedulingService(center: center, clock: clock)
        let item = FoodItem(
            name: "Milk",
            expiryDate: makeDate(year: 2026, month: 3, day: 10, hour: 12),
            location: .fridge,
            quantity: nil,
            note: nil,
            createdAt: clock.now,
            updatedAt: clock.now
        )
        let settings = AppSettings(notificationsEnabled: false)

        service.syncNotifications(for: [item], settings: settings)

        XCTAssertEqual(center.removeAllCallCount, 1)
        XCTAssertTrue(center.addedRequests.isEmpty)
    }

    func testNoOpNotificationServiceAcceptsAllCalls() {
        let service = NoOpNotificationSchedulingService()
        let now = makeDate(year: 2026, month: 3, day: 6, hour: 9)
        let item = FoodItem(
            name: "Bread",
            expiryDate: makeDate(year: 2026, month: 3, day: 8, hour: 9),
            location: .pantry,
            quantity: nil,
            note: nil,
            createdAt: now,
            updatedAt: now
        )
        let settings = AppSettings()

        service.syncNotifications(for: item, settings: settings)
        service.syncNotifications(for: [item], settings: settings)
        service.cancelNotifications(for: item.id)
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
