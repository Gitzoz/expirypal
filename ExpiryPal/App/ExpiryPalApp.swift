import SwiftUI

@main
struct ExpiryPalApp: App {
    private let container: AppContainer

    init() {
        let isUITesting = ProcessInfo.processInfo.arguments.contains("UITEST_MODE")
        self.container = AppContainer(isStoredInMemoryOnly: isUITesting)
    }

    var body: some Scene {
        WindowGroup {
            DashboardView(
                viewModel: container.dashboardViewModel,
                makeAddItemViewModel: container.makeAddItemViewModel
            )
        }
    }
}
