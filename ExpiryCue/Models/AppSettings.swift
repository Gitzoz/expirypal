import Foundation
import SwiftData

@Model
final class AppSettings {
    @Attribute(.unique) var id: UUID
    var notificationsEnabled: Bool
    var notifyDaysBefore: Int
    var notifyOneDayBefore: Bool
    var notifyOnDay: Bool
    var notificationHour: Int
    var notificationMinute: Int

    init(
        id: UUID = UUID(),
        notificationsEnabled: Bool = true,
        notifyDaysBefore: Int = 3,
        notifyOneDayBefore: Bool = true,
        notifyOnDay: Bool = true,
        notificationHour: Int = 9,
        notificationMinute: Int = 0
    ) {
        self.id = id
        self.notificationsEnabled = notificationsEnabled
        self.notifyDaysBefore = Self.normalizedDaysBefore(notifyDaysBefore)
        self.notifyOneDayBefore = notifyOneDayBefore
        self.notifyOnDay = notifyOnDay
        self.notificationHour = Self.normalizedHour(notificationHour)
        self.notificationMinute = Self.normalizedMinute(notificationMinute)
    }

    var notificationTimeComponents: DateComponents {
        DateComponents(hour: notificationHour, minute: notificationMinute)
    }

    func apply(
        notificationsEnabled: Bool,
        notifyDaysBefore: Int,
        notifyOneDayBefore: Bool,
        notifyOnDay: Bool,
        notificationHour: Int,
        notificationMinute: Int
    ) {
        self.notificationsEnabled = notificationsEnabled
        self.notifyDaysBefore = Self.normalizedDaysBefore(notifyDaysBefore)
        self.notifyOneDayBefore = notifyOneDayBefore
        self.notifyOnDay = notifyOnDay
        self.notificationHour = Self.normalizedHour(notificationHour)
        self.notificationMinute = Self.normalizedMinute(notificationMinute)
    }

    private static func normalizedDaysBefore(_ value: Int) -> Int {
        max(1, value)
    }

    private static func normalizedHour(_ value: Int) -> Int {
        min(max(value, 0), 23)
    }

    private static func normalizedMinute(_ value: Int) -> Int {
        min(max(value, 0), 59)
    }
}
