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

        let trimmedNote = note?.trimmingCharacters(in: .whitespacesAndNewlines)
        let timestamp = clock.now
        let item = FoodItem(
            name: trimmedName,
            expiryDate: expiryDate,
            location: location,
            quantity: quantity,
            note: trimmedNote?.isEmpty == true ? nil : trimmedNote,
            status: .active,
            createdAt: timestamp,
            updatedAt: timestamp
        )

        modelContext.insert(item)
        try modelContext.save()
        return item
    }
}
