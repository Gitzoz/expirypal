import Combine
import Foundation

@MainActor
final class AddItemViewModel: ObservableObject {
    @Published var name = ""
    @Published var expiryDate: Date
    @Published var location: StorageLocation = .fridge
    @Published var quantityText = ""
    @Published var note = ""
    @Published private(set) var validationMessageKey: String?
    @Published private(set) var didSave = false

    private let repository: FoodItemRepository
    private let settingsRepository: AppSettingsRepository
    private let notificationService: NotificationSchedulingService

    init(
        repository: FoodItemRepository,
        settingsRepository: AppSettingsRepository,
        notificationService: NotificationSchedulingService,
        clock: Clock,
        calendar: Calendar = .current
    ) {
        self.repository = repository
        self.settingsRepository = settingsRepository
        self.notificationService = notificationService
        self.expiryDate = calendar.startOfDay(for: clock.now)
    }

    func save() {
        didSave = false

        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else {
            validationMessageKey = "addItem.validation.nameRequired"
            return
        }

        let parsedQuantityResult = parsedQuantity()
        switch parsedQuantityResult {
        case .failure:
            validationMessageKey = "addItem.validation.quantityInvalid"
            return
        case .success(let quantity):
            do {
                let item = try repository.addItem(
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
                    validationMessageKey = "addItem.validation.nameRequired"
                case .itemNotFound:
                    validationMessageKey = "addItem.validation.generic"
                }
            } catch {
                validationMessageKey = "addItem.validation.generic"
            }
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
