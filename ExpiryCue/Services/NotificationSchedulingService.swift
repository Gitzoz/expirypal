import Foundation

protocol NotificationSchedulingService {
    func syncNotifications(for item: FoodItem, settings: AppSettings)
    func syncNotifications(for items: [FoodItem], settings: AppSettings)
    func cancelNotifications(for itemID: UUID)
}
