import Foundation
import SwiftData

@MainActor
struct AppContainer {
    let modelContainer: ModelContainer
    let dashboardViewModel: DashboardViewModel
    let makeAddItemViewModel: () -> AddItemViewModel

    init(clock: Clock = SystemClock(), isStoredInMemoryOnly: Bool = false) {
        do {
            self.modelContainer = try ModelContainer(
                for: FoodItem.self,
                configurations: ModelConfiguration(isStoredInMemoryOnly: isStoredInMemoryOnly)
            )
        } catch {
            fatalError("Unable to create model container: \(error)")
        }

        let repository = SwiftDataFoodItemRepository(modelContext: modelContainer.mainContext, clock: clock)
        self.dashboardViewModel = DashboardViewModel(repository: repository, clock: clock)
        self.makeAddItemViewModel = {
            AddItemViewModel(repository: repository, clock: clock)
        }
    }
}
