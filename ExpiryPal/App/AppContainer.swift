import Foundation
import SwiftData

@MainActor
struct AppContainer {
    private static let schema = Schema([FoodItem.self, AppSettings.self])

    let modelContainer: ModelContainer
    let dashboardViewModel: DashboardViewModel
    let archiveViewModel: ArchiveViewModel
    let settingsViewModel: SettingsViewModel
    let makeAddItemViewModel: () -> AddItemViewModel
    let makeEditItemViewModel: (FoodItem) -> EditItemViewModel

    init(clock: Clock = SystemClock(), launchConfiguration: AppLaunchConfiguration = .current()) {
        let isStoredInMemoryOnly = launchConfiguration.usesInMemoryStore

        self.modelContainer = Self.makeModelContainer(isStoredInMemoryOnly: isStoredInMemoryOnly)

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

    private static func makeModelContainer(isStoredInMemoryOnly: Bool) -> ModelContainer {
        if let primaryContainer = try? configuredModelContainer(isStoredInMemoryOnly: isStoredInMemoryOnly) {
            return primaryContainer
        }

        if !isStoredInMemoryOnly,
           let fallbackContainer = try? configuredModelContainer(isStoredInMemoryOnly: true) {
            return fallbackContainer
        }

        preconditionFailure("Unable to create any SwiftData model container")
    }

    private static func configuredModelContainer(isStoredInMemoryOnly: Bool) throws -> ModelContainer {
        let configuration: ModelConfiguration
        if isStoredInMemoryOnly {
            configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        } else {
            let storeURL = try persistentStoreURL()
            configuration = ModelConfiguration(schema: schema, url: storeURL)
        }

        return try ModelContainer(for: schema, configurations: [configuration])
    }

    private static func persistentStoreURL(fileManager: FileManager = .default) throws -> URL {
        let appSupportDirectory = try fileManager.url(
            for: .applicationSupportDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )
        let storeDirectory = appSupportDirectory.appendingPathComponent("ExpiryPal", isDirectory: true)

        if !fileManager.fileExists(atPath: storeDirectory.path()) {
            try fileManager.createDirectory(at: storeDirectory, withIntermediateDirectories: true)
        }

        return storeDirectory.appendingPathComponent("ExpiryPal.store")
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
        guard let tomorrow = calendar.date(byAdding: .day, value: 1, to: today),
              let day2 = calendar.date(byAdding: .day, value: 2, to: today),
              let day5 = calendar.date(byAdding: .day, value: 5, to: today),
              let yesterday = calendar.date(byAdding: .day, value: -1, to: today),
              let twoDaysAgo = calendar.date(byAdding: .day, value: -2, to: today),
              let fiveDaysAgo = calendar.date(byAdding: .day, value: -5, to: today),
              let sixDaysAgo = calendar.date(byAdding: .day, value: -6, to: today),
              let oneHourAgo = calendar.date(byAdding: .hour, value: -1, to: now),
              let twoHoursAgo = calendar.date(byAdding: .hour, value: -2, to: now) else {
            return
        }

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
                expiryDate: yesterday,
                location: .pantry,
                quantity: 1,
                note: nil,
                status: .consumed,
                createdAt: fiveDaysAgo,
                updatedAt: oneHourAgo
            )
        )
        context.insert(
            FoodItem(
                name: "Parsley",
                expiryDate: twoDaysAgo,
                location: .fridge,
                quantity: nil,
                note: "Wilted",
                status: .discarded,
                createdAt: sixDaysAgo,
                updatedAt: twoHoursAgo
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

        do {
            try context.save()
        } catch {
            context.rollback()
        }
    }
}
