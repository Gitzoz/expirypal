import Foundation
@testable import ExpiryPal

@MainActor
final class InMemoryFoodItemRepository: FoodItemRepository {
    var items: [FoodItem]
    private let clock: Clock

    init(items: [FoodItem], clock: Clock) {
        self.items = items
        self.clock = clock
    }

    func fetchActiveItemsSortedByExpiryDate() throws -> [FoodItem] {
        items
            .filter { $0.status == .active }
            .sorted { $0.expiryDate < $1.expiryDate }
    }

    func fetchArchivedItemsSortedByUpdatedAtDescending() throws -> [FoodItem] {
        items
            .filter { $0.status != .active }
            .sorted { $0.updatedAt > $1.updatedAt }
    }

    func fetchItem(id: UUID) throws -> FoodItem? {
        items.first { $0.id == id }
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

        let item = FoodItem(
            name: trimmedName,
            expiryDate: expiryDate,
            location: location,
            quantity: quantity,
            note: normalizedNote(note),
            status: .active,
            createdAt: clock.now,
            updatedAt: clock.now
        )
        items.append(item)
        return item
    }

    func updateItem(
        id: UUID,
        name: String,
        expiryDate: Date,
        location: StorageLocation,
        quantity: Double?,
        note: String?
    ) throws -> FoodItem {
        guard let item = items.first(where: { $0.id == id }) else {
            throw FoodItemRepositoryError.itemNotFound
        }

        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else {
            throw FoodItemRepositoryError.invalidName
        }

        item.name = trimmedName
        item.expiryDate = expiryDate
        item.location = location
        item.quantity = quantity
        item.note = normalizedNote(note)
        item.updatedAt = clock.now
        return item
    }

    func updateStatus(id: UUID, status: ItemStatus) throws -> FoodItem {
        guard let item = items.first(where: { $0.id == id }) else {
            throw FoodItemRepositoryError.itemNotFound
        }

        item.status = status
        item.updatedAt = clock.now
        return item
    }

    private func normalizedNote(_ value: String?) -> String? {
        let trimmed = value?.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed?.isEmpty == true ? nil : trimmed
    }
}
