import Foundation

enum FoodItemRepositoryError: Error, Equatable {
    case invalidName
    case itemNotFound
}

@MainActor
protocol FoodItemRepository {
    func fetchActiveItemsSortedByExpiryDate() throws -> [FoodItem]
    func fetchArchivedItemsSortedByUpdatedAtDescending() throws -> [FoodItem]
    func fetchItem(id: UUID) throws -> FoodItem?
    func addItem(
        name: String,
        expiryDate: Date,
        location: StorageLocation,
        quantity: Double?,
        note: String?
    ) throws -> FoodItem
    func updateItem(
        id: UUID,
        name: String,
        expiryDate: Date,
        location: StorageLocation,
        quantity: Double?,
        note: String?
    ) throws -> FoodItem
    func updateStatus(id: UUID, status: ItemStatus) throws -> FoodItem
}
