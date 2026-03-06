import Foundation

@MainActor
struct AppContainer {
    let dashboardViewModel: DashboardViewModel

    init(clock: Clock = SystemClock(), repository: FoodItemRepository) {
        self.dashboardViewModel = DashboardViewModel(repository: repository, clock: clock)
    }
}
