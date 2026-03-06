import Foundation

enum FoodItemRepositoryError: Error, Equatable {
    case invalidName
}

@MainActor
protocol FoodItemRepository {
    func fetchActiveItemsSortedByExpiryDate() throws -> [FoodItem]
    func addItem(
        name: String,
        expiryDate: Date,
        location: StorageLocation,
        quantity: Double?,
        note: String?
    ) throws -> FoodItem
}
