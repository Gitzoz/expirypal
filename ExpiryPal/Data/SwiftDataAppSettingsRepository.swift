import Foundation
import SwiftData

@MainActor
final class SwiftDataAppSettingsRepository: AppSettingsRepository {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func loadSettings() throws -> AppSettings {
        let settings = try ensureSingleSettingsRecord()
        try modelContext.save()
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
        let settings = try ensureSingleSettingsRecord()
        settings.apply(
            notificationsEnabled: notificationsEnabled,
            notifyDaysBefore: notifyDaysBefore,
            notifyOneDayBefore: notifyOneDayBefore,
            notifyOnDay: notifyOnDay,
            notificationHour: notificationHour,
            notificationMinute: notificationMinute
        )
        try modelContext.save()
        return settings
    }

    private func ensureSingleSettingsRecord() throws -> AppSettings {
        let descriptor = FetchDescriptor<AppSettings>()
        var settingsRecords = try modelContext.fetch(descriptor)

        if settingsRecords.isEmpty {
            let settings = AppSettings()
            modelContext.insert(settings)
            return settings
        }

        let primary = settingsRecords.removeFirst()
        for duplicate in settingsRecords {
            modelContext.delete(duplicate)
        }
        return primary
    }
}
