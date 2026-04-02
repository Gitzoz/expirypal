import Combine
import Foundation

@MainActor
final class DashboardViewModel: ObservableObject {
    @Published private(set) var allActiveItems: [FoodItem] = []
    @Published private(set) var todayItems: [FoodItem] = []
    @Published private(set) var next3DaysItems: [FoodItem] = []
    @Published private(set) var laterItems: [FoodItem] = []

    private let repository: FoodItemRepository
    private let settingsRepository: AppSettingsRepository
    private let notificationService: NotificationSchedulingService
    private let clock: Clock
    private let calendar: Calendar

    init(
        repository: FoodItemRepository,
        settingsRepository: AppSettingsRepository,
        notificationService: NotificationSchedulingService,
        clock: Clock,
        calendar: Calendar = .current
    ) {
        self.repository = repository
        self.settingsRepository = settingsRepository
        self.notificationService = notificationService
        self.clock = clock
        self.calendar = calendar
    }

    func load() {
        do {
            let items = try repository.fetchActiveItemsSortedByExpiryDate()
            allActiveItems = items

            todayItems = items.filter { segment(for: $0.expiryDate) == .today }
            next3DaysItems = items.filter { segment(for: $0.expiryDate) == .next3Days }
            laterItems = items.filter { segment(for: $0.expiryDate) == .later }
        } catch {
            allActiveItems = []
            todayItems = []
            next3DaysItems = []
            laterItems = []
        }
    }

    func markConsumed(id: UUID) {
        updateStatus(id: id, status: .consumed)
    }

    func markDiscarded(id: UUID) {
        updateStatus(id: id, status: .discarded)
    }

    private func updateStatus(id: UUID, status: ItemStatus) {
        do {
            _ = try repository.updateStatus(id: id, status: status)
            notificationService.cancelNotifications(for: id)
            _ = try settingsRepository.loadSettings()
            load()
        } catch {
            load()
        }
    }

    private func segment(for expiryDate: Date) -> DashboardSegment {
        DashboardSegmentation.segment(for: expiryDate, now: clock.now, calendar: calendar)
    }
}
