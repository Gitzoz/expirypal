import Foundation

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
}
