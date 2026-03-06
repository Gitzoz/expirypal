import Foundation
@testable import ExpiryPal

final class NotificationSchedulingServiceSpy: NotificationSchedulingService {
    private(set) var syncedItemIDs: [UUID] = []
    private(set) var syncedBatchItemIDs: [[UUID]] = []
    private(set) var syncedSettings: [AppSettings] = []
    private(set) var cancelledItemIDs: [UUID] = []

    func syncNotifications(for item: FoodItem, settings: AppSettings) {
        syncedItemIDs.append(item.id)
        syncedSettings.append(settings)
    }

    func syncNotifications(for items: [FoodItem], settings: AppSettings) {
        syncedBatchItemIDs.append(items.map(\.id))
        syncedSettings.append(settings)
    }

    func cancelNotifications(for itemID: UUID) {
        cancelledItemIDs.append(itemID)
    }
}
