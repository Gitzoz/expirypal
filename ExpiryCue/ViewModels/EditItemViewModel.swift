import Combine
import Foundation

@MainActor
final class EditItemViewModel: ObservableObject {
    @Published var name: String
    @Published var expiryDate: Date
    @Published var location: StorageLocation
    @Published var quantityText: String
    @Published var note: String
    @Published private(set) var validationMessageKey: String?
    @Published private(set) var didSave = false
    @Published private(set) var didArchive = false

    let itemID: UUID
    private let repository: FoodItemRepository
    private let settingsRepository: AppSettingsRepository
    private let notificationService: NotificationSchedulingService

    init(
        item: FoodItem,
        repository: FoodItemRepository,
        settingsRepository: AppSettingsRepository,
        notificationService: NotificationSchedulingService
    ) {
        self.itemID = item.id
        self.name = item.name
        self.expiryDate = item.expiryDate
        self.location = item.location
        self.quantityText = item.quantity.map { String($0) } ?? ""
        self.note = item.note ?? ""
        self.repository = repository
        self.settingsRepository = settingsRepository
        self.notificationService = notificationService
    }

    func save() {
        didSave = false
        didArchive = false

        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else {
            validationMessageKey = "editItem.validation.nameRequired"
            return
        }

        switch parsedQuantity() {
        case .failure:
            validationMessageKey = "editItem.validation.quantityInvalid"
        case .success(let quantity):
            do {
                let item = try repository.updateItem(
                    id: itemID,
                    name: trimmedName,
                    expiryDate: expiryDate,
                    location: location,
                    quantity: quantity,
                    note: note
                )
                let settings = try settingsRepository.loadSettings()
                notificationService.syncNotifications(for: item, settings: settings)
                validationMessageKey = nil
                didSave = true
            } catch let error as FoodItemRepositoryError {
                switch error {
                case .invalidName:
                    validationMessageKey = "editItem.validation.nameRequired"
                case .itemNotFound:
                    validationMessageKey = "editItem.validation.generic"
                }
            } catch {
                validationMessageKey = "editItem.validation.generic"
            }
        }
    }

    func markConsumed() {
        updateStatus(.consumed)
    }

    func markDiscarded() {
        updateStatus(.discarded)
    }

    private func updateStatus(_ status: ItemStatus) {
        do {
            _ = try repository.updateStatus(id: itemID, status: status)
            notificationService.cancelNotifications(for: itemID)
            validationMessageKey = nil
            didArchive = true
        } catch {
            validationMessageKey = "editItem.validation.generic"
        }
    }

    private func parsedQuantity() -> Result<Double?, QuantityValidationError> {
        let trimmed = quantityText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            return .success(nil)
        }

        if let value = Double(trimmed) {
            return .success(value)
        }

        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .decimal
        if let value = formatter.number(from: trimmed)?.doubleValue {
            return .success(value)
        }

        return .failure(.invalid)
    }
}

private enum QuantityValidationError: Error {
    case invalid
}
