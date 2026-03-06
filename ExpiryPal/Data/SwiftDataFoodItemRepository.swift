import Foundation
import SwiftData

@MainActor
final class SwiftDataFoodItemRepository: FoodItemRepository {
    private let modelContext: ModelContext
    private let clock: Clock

    init(modelContext: ModelContext, clock: Clock) {
        self.modelContext = modelContext
        self.clock = clock
    }

    func fetchActiveItemsSortedByExpiryDate() throws -> [FoodItem] {
        let descriptor = FetchDescriptor<FoodItem>(
            predicate: #Predicate<FoodItem> { item in
                item.statusRaw == "active"
            },
            sortBy: [SortDescriptor(\FoodItem.expiryDate, order: .forward)]
        )

        return try modelContext.fetch(descriptor)
    }

    func fetchArchivedItemsSortedByUpdatedAtDescending() throws -> [FoodItem] {
        let descriptor = FetchDescriptor<FoodItem>(
            predicate: #Predicate<FoodItem> { item in
                item.statusRaw != "active"
            },
            sortBy: [SortDescriptor(\FoodItem.updatedAt, order: .reverse)]
        )

        return try modelContext.fetch(descriptor)
    }

    func fetchItem(id: UUID) throws -> FoodItem? {
        let descriptor = FetchDescriptor<FoodItem>(
            predicate: #Predicate<FoodItem> { item in
                item.id == id
            }
        )
        return try modelContext.fetch(descriptor).first
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

        let trimmedNote = normalizedNote(note)
        let timestamp = clock.now
        let item = FoodItem(
            name: trimmedName,
            expiryDate: expiryDate,
            location: location,
            quantity: quantity,
            note: trimmedNote,
            status: .active,
            createdAt: timestamp,
            updatedAt: timestamp
        )

        modelContext.insert(item)
        try modelContext.save()
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
        guard let item = try fetchItem(id: id) else {
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
        try modelContext.save()
        return item
    }

    func updateStatus(id: UUID, status: ItemStatus) throws -> FoodItem {
        guard let item = try fetchItem(id: id) else {
            throw FoodItemRepositoryError.itemNotFound
        }

        item.status = status
        item.updatedAt = clock.now
        try modelContext.save()
        return item
    }

    private func normalizedNote(_ value: String?) -> String? {
        let trimmed = value?.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed?.isEmpty == true ? nil : trimmed
    }
}
