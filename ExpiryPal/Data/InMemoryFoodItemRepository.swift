import Foundation

@MainActor
final class InMemoryFoodItemRepository: FoodItemRepository {
    private var items: [FoodItem]

    init(items: [FoodItem]) {
        self.items = items
    }

    func fetchActiveItemsSortedByExpiryDate() throws -> [FoodItem] {
        items
            .filter { $0.status == .active }
            .sorted { $0.expiryDate < $1.expiryDate }
    }

    func addItem(
        name: String,
        expiryDate: Date,
        location: StorageLocation,
        quantity: Double?,
        note: String?
    ) throws -> FoodItem {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedName.isEmpty else {
            throw FoodItemRepositoryError.invalidName
        }

        let timestamp = expiryDate
        let item = FoodItem(
            name: trimmedName,
            expiryDate: expiryDate,
            location: location,
            quantity: quantity,
            note: note,
            status: .active,
            createdAt: timestamp,
            updatedAt: timestamp
        )
        items.append(item)
        return item
    }
}
