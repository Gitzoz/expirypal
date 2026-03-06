import SwiftUI

@main
struct ExpiryPalApp: App {
    private let container: AppContainer

    init() {
        let now = Date()
        let sampleItems = [
            FoodItem(name: "Milk", expiryDate: now, location: .fridge, createdAt: now, updatedAt: now),
            FoodItem(name: "Peas", expiryDate: Calendar.current.date(byAdding: .day, value: 2, to: now)!, location: .freezer, createdAt: now, updatedAt: now),
            FoodItem(name: "Rice", expiryDate: Calendar.current.date(byAdding: .day, value: 7, to: now)!, location: .pantry, createdAt: now, updatedAt: now)
        ]
        let repository = InMemoryFoodItemRepository(items: sampleItems)
        self.container = AppContainer(repository: repository)
    }

    var body: some Scene {
        WindowGroup {
            DashboardView(viewModel: container.dashboardViewModel)
        }
    }
}
