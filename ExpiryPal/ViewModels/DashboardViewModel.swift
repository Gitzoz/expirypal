import Foundation
import Combine

@MainActor
final class DashboardViewModel: ObservableObject {
    @Published private(set) var allActiveItems: [FoodItem] = []
    @Published private(set) var todayItems: [FoodItem] = []
    @Published private(set) var next3DaysItems: [FoodItem] = []
    @Published private(set) var laterItems: [FoodItem] = []

    private let repository: FoodItemRepository
    private let clock: Clock
    private let calendar: Calendar

    init(repository: FoodItemRepository, clock: Clock, calendar: Calendar = .current) {
        self.repository = repository
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

    private func segment(for expiryDate: Date) -> DashboardSegment {
        DashboardSegmentation.segment(for: expiryDate, now: clock.now, calendar: calendar)
    }
}
