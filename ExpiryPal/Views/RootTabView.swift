import SwiftUI

struct RootTabView: View {
    let dashboardViewModel: DashboardViewModel
    let archiveViewModel: ArchiveViewModel
    let settingsViewModel: SettingsViewModel
    let makeAddItemViewModel: () -> AddItemViewModel
    let makeEditItemViewModel: (FoodItem) -> EditItemViewModel

    var body: some View {
        TabView {
            DashboardView(
                viewModel: dashboardViewModel,
                makeAddItemViewModel: makeAddItemViewModel,
                makeEditItemViewModel: makeEditItemViewModel
            )
            .tabItem {
                Label("tab.dashboard", systemImage: "list.bullet.rectangle")
            }

            ArchiveView(
                viewModel: archiveViewModel,
                makeEditItemViewModel: makeEditItemViewModel
            )
            .tabItem {
                Label("tab.archive", systemImage: "archivebox")
            }

            SettingsView(viewModel: settingsViewModel)
                .tabItem {
                    Label("tab.settings", systemImage: "gearshape")
                }
        }
    }
}
