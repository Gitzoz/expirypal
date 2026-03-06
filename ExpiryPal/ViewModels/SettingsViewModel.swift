import Combine
import Foundation

@MainActor
final class SettingsViewModel: ObservableObject {
    @Published var notificationsEnabled = true
    @Published var notifyDaysBefore = 3
    @Published var notifyOneDayBefore = true
    @Published var notifyOnDay = true
    @Published var notificationTime: Date
    @Published private(set) var didSave = false
    @Published private(set) var validationMessageKey: String?

    private let settingsRepository: AppSettingsRepository
    private let foodItemRepository: FoodItemRepository
    private let notificationService: NotificationSchedulingService
    private let clock: Clock
    private let calendar: Calendar

    init(
        settingsRepository: AppSettingsRepository,
        foodItemRepository: FoodItemRepository,
        notificationService: NotificationSchedulingService,
        clock: Clock,
        calendar: Calendar = .current
    ) {
        self.settingsRepository = settingsRepository
        self.foodItemRepository = foodItemRepository
        self.notificationService = notificationService
        self.clock = clock
        self.calendar = calendar
        self.notificationTime = calendar.date(bySettingHour: 9, minute: 0, second: 0, of: clock.now) ?? clock.now
    }

    func load() {
        do {
            let settings = try settingsRepository.loadSettings()
            apply(settings: settings)
            validationMessageKey = nil
        } catch {
            validationMessageKey = "settings.validation.generic"
        }
    }

    func save() {
        didSave = false

        let components = calendar.dateComponents([.hour, .minute], from: notificationTime)
        let hour = components.hour ?? 9
        let minute = components.minute ?? 0

        do {
            let settings = try settingsRepository.updateSettings(
                notificationsEnabled: notificationsEnabled,
                notifyDaysBefore: notifyDaysBefore,
                notifyOneDayBefore: notifyOneDayBefore,
                notifyOnDay: notifyOnDay,
                notificationHour: hour,
                notificationMinute: minute
            )
            let activeItems = try foodItemRepository.fetchActiveItemsSortedByExpiryDate()
            notificationService.syncNotifications(for: activeItems, settings: settings)
            apply(settings: settings)
            validationMessageKey = nil
            didSave = true
        } catch {
            validationMessageKey = "settings.validation.generic"
        }
    }

    private func apply(settings: AppSettings) {
        notificationsEnabled = settings.notificationsEnabled
        notifyDaysBefore = settings.notifyDaysBefore
        notifyOneDayBefore = settings.notifyOneDayBefore
        notifyOnDay = settings.notifyOnDay
        notificationTime = calendar.date(bySettingHour: settings.notificationHour, minute: settings.notificationMinute, second: 0, of: clock.now) ?? clock.now
    }
}
