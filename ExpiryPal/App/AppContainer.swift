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

    init(clock: Clock = SystemClock(), launchConfiguration: AppLaunchConfiguration = .current()) {
        let isStoredInMemoryOnly = launchConfiguration.usesInMemoryStore

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

        if launchConfiguration.screenshotScene != nil {
            Self.seedScreenshotData(in: modelContainer.mainContext, clock: clock)
        }

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

    private static func seedScreenshotData(in context: ModelContext, clock: Clock) {
        let existingItemCount = (try? context.fetchCount(FetchDescriptor<FoodItem>())) ?? 0
        let existingSettingsCount = (try? context.fetchCount(FetchDescriptor<AppSettings>())) ?? 0

        guard existingItemCount == 0, existingSettingsCount == 0 else {
            return
        }

        let calendar = Calendar(identifier: .gregorian)
        let now = clock.now
        let today = calendar.startOfDay(for: now)
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)!
        let day2 = calendar.date(byAdding: .day, value: 2, to: today)!
        let day5 = calendar.date(byAdding: .day, value: 5, to: today)!

        context.insert(
            FoodItem(
                name: "Spinach",
                expiryDate: today,
                location: .fridge,
                quantity: 1,
                note: "Use for pasta",
                createdAt: now,
                updatedAt: now
            )
        )
        context.insert(
            FoodItem(
                name: AppLaunchConfiguration.screenshotEditItemName,
                expiryDate: tomorrow,
                location: .fridge,
                quantity: 2,
                note: "Breakfast",
                createdAt: now,
                updatedAt: now
            )
        )
        context.insert(
            FoodItem(
                name: "Sourdough Bread",
                expiryDate: day2,
                location: .pantry,
                quantity: 1,
                note: nil,
                createdAt: now,
                updatedAt: now
            )
        )
        context.insert(
            FoodItem(
                name: "Frozen Berries",
                expiryDate: day5,
                location: .freezer,
                quantity: 1,
                note: nil,
                createdAt: now,
                updatedAt: now
            )
        )
        context.insert(
            FoodItem(
                name: "Tomato Soup",
                expiryDate: calendar.date(byAdding: .day, value: -1, to: today)!,
                location: .pantry,
                quantity: 1,
                note: nil,
                status: .consumed,
                createdAt: calendar.date(byAdding: .day, value: -5, to: today)!,
                updatedAt: calendar.date(byAdding: .hour, value: -1, to: now)!
            )
        )
        context.insert(
            FoodItem(
                name: "Parsley",
                expiryDate: calendar.date(byAdding: .day, value: -2, to: today)!,
                location: .fridge,
                quantity: nil,
                note: "Wilted",
                status: .discarded,
                createdAt: calendar.date(byAdding: .day, value: -6, to: today)!,
                updatedAt: calendar.date(byAdding: .hour, value: -2, to: now)!
            )
        )
        context.insert(
            AppSettings(
                notificationsEnabled: true,
                notifyDaysBefore: 4,
                notifyOneDayBefore: true,
                notifyOnDay: true,
                notificationHour: 8,
                notificationMinute: 30
            )
        )

        try? context.save()
    }
}
