import Foundation
import SwiftData

@MainActor
struct AppContainer {
    let modelContainer: ModelContainer
    let dashboardViewModel: DashboardViewModel
    let archiveViewModel: ArchiveViewModel
    let settingsViewModel: SettingsViewModel
    let makeAddItemViewModel: () -> AddItemViewModel
    let makeEditItemViewModel: (FoodItem) -> EditItemViewModel

    init(clock: Clock = SystemClock(), isStoredInMemoryOnly: Bool = false) {
        do {
            self.modelContainer = try ModelContainer(
                for: FoodItem.self, AppSettings.self,
                configurations: ModelConfiguration(isStoredInMemoryOnly: isStoredInMemoryOnly)
            )
        } catch {
            fatalError("Unable to create model container: \(error)")
        }

        let foodItemRepository = SwiftDataFoodItemRepository(modelContext: modelContainer.mainContext, clock: clock)
        let settingsRepository = SwiftDataAppSettingsRepository(modelContext: modelContainer.mainContext)
        let notificationService: NotificationSchedulingService = isStoredInMemoryOnly
            ? NoOpNotificationSchedulingService()
            : LocalNotificationSchedulingService(clock: clock)

        self.dashboardViewModel = DashboardViewModel(
            repository: foodItemRepository,
            settingsRepository: settingsRepository,
            notificationService: notificationService,
            clock: clock
        )
        self.archiveViewModel = ArchiveViewModel(repository: foodItemRepository)
        self.settingsViewModel = SettingsViewModel(
            settingsRepository: settingsRepository,
            foodItemRepository: foodItemRepository,
            notificationService: notificationService,
            clock: clock
        )
        self.makeAddItemViewModel = {
            AddItemViewModel(
                repository: foodItemRepository,
                settingsRepository: settingsRepository,
                notificationService: notificationService,
                clock: clock
            )
        }
        self.makeEditItemViewModel = { item in
            EditItemViewModel(
                item: item,
                repository: foodItemRepository,
                settingsRepository: settingsRepository,
                notificationService: notificationService
            )
        }
    }
}
