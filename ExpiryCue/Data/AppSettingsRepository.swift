import Foundation

@MainActor
protocol AppSettingsRepository {
    func loadSettings() throws -> AppSettings
    func updateSettings(
        notificationsEnabled: Bool,
        notifyDaysBefore: Int,
        notifyOneDayBefore: Bool,
        notifyOnDay: Bool,
        notificationHour: Int,
        notificationMinute: Int
    ) throws -> AppSettings
}
