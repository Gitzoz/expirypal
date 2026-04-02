import Foundation
import UserNotifications

struct LocalNotificationSchedulingService: NotificationSchedulingService {
    private let center: UserNotificationCenterProtocol
    private let clock: Clock
    private let calendar: Calendar
    private let locale: Locale
    private let bundle: Bundle

    init(
        center: UserNotificationCenterProtocol = UNUserNotificationCenter.current(),
        clock: Clock,
        calendar: Calendar = .current,
        locale: Locale = .current,
        bundle: Bundle = .main
    ) {
        self.center = center
        self.clock = clock
        self.calendar = calendar
        self.locale = locale
        self.bundle = bundle
    }

    func syncNotifications(for item: FoodItem, settings: AppSettings) {
        cancelNotifications(for: item.id)

        guard settings.notificationsEnabled, item.status == .active else {
            return
        }

        for request in requests(for: item, settings: settings) {
            center.add(request, withCompletionHandler: nil)
        }
    }

    func syncNotifications(for items: [FoodItem], settings: AppSettings) {
        center.removeAllPendingNotificationRequests()

        guard settings.notificationsEnabled else {
            return
        }

        for item in items where item.status == .active {
            for request in requests(for: item, settings: settings) {
                center.add(request, withCompletionHandler: nil)
            }
        }
    }

    func cancelNotifications(for itemID: UUID) {
        center.removePendingNotificationRequests(withIdentifiers: identifiers(for: itemID))
    }

    private func requests(for item: FoodItem, settings: AppSettings) -> [UNNotificationRequest] {
        let definitions: [(identifierSuffix: String, enabled: Bool, daysBefore: Int)] = [
            ("d3", settings.notificationsEnabled, settings.notifyDaysBefore),
            ("d1", settings.notifyOneDayBefore, 1),
            ("d0", settings.notifyOnDay, 0)
        ]

        var requests: [UNNotificationRequest] = []
        for definition in definitions where definition.enabled {
            guard let triggerDate = triggerDate(
                for: item.expiryDate,
                daysBefore: definition.daysBefore,
                hour: settings.notificationHour,
                minute: settings.notificationMinute
            ) else {
                continue
            }

            let content = UNMutableNotificationContent()
            content.title = title(for: definition.daysBefore)
            content.body = body(for: item.name, daysBefore: definition.daysBefore)
            content.sound = .default

            let components = calendar.dateComponents(
                [.year, .month, .day, .hour, .minute],
                from: triggerDate
            )
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            let request = UNNotificationRequest(
                identifier: "fooditem.\(item.id.uuidString).\(definition.identifierSuffix)",
                content: content,
                trigger: trigger
            )
            requests.append(request)
        }

        return requests
    }

    private func identifiers(for itemID: UUID) -> [String] {
        [
            "fooditem.\(itemID.uuidString).d3",
            "fooditem.\(itemID.uuidString).d1",
            "fooditem.\(itemID.uuidString).d0"
        ]
    }

    private func triggerDate(for expiryDate: Date, daysBefore: Int, hour: Int, minute: Int) -> Date? {
        let expiryStart = calendar.startOfDay(for: expiryDate)
        guard let scheduledDay = calendar.date(byAdding: .day, value: -daysBefore, to: expiryStart),
              let scheduledDate = calendar.date(
                bySettingHour: hour,
                minute: minute,
                second: 0,
                of: scheduledDay
              ) else {
            return nil
        }

        guard scheduledDate > clock.now else {
            return nil
        }

        return scheduledDate
    }

    private func title(for daysBefore: Int) -> String {
        switch daysBefore {
        case 0:
            return localized("notification.title.today")
        case 1:
            return localized("notification.title.tomorrow")
        default:
            return localized("notification.title.future")
        }
    }

    private func body(for itemName: String, daysBefore: Int) -> String {
        switch daysBefore {
        case 0:
            return String(format: localized("notification.body.today"), locale: locale, itemName)
        case 1:
            return String(format: localized("notification.body.tomorrow"), locale: locale, itemName)
        default:
            return String(format: localized("notification.body.future"), locale: locale, itemName, daysBefore)
        }
    }

    private func localized(_ key: String) -> String {
        bundle.localizedString(forKey: key, value: nil, table: nil)
    }
}
