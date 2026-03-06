import Foundation
@testable import ExpiryPal

@MainActor
final class InMemoryAppSettingsRepository: AppSettingsRepository {
    var settings: AppSettings
    var loadCount = 0

    init(settings: AppSettings = AppSettings()) {
        self.settings = settings
    }

    func loadSettings() throws -> AppSettings {
        loadCount += 1
        return settings
    }

    func updateSettings(
        notificationsEnabled: Bool,
        notifyDaysBefore: Int,
        notifyOneDayBefore: Bool,
        notifyOnDay: Bool,
        notificationHour: Int,
        notificationMinute: Int
    ) throws -> AppSettings {
        settings.apply(
            notificationsEnabled: notificationsEnabled,
            notifyDaysBefore: notifyDaysBefore,
            notifyOneDayBefore: notifyOneDayBefore,
            notifyOnDay: notifyOnDay,
            notificationHour: notificationHour,
            notificationMinute: notificationMinute
        )
        return settings
    }
}
