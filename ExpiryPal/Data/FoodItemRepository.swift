import Foundation

protocol FoodItemRepository {
    func fetchActiveItemsSortedByExpiryDate() throws -> [FoodItem]
}
