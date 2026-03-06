import Combine
import Foundation

@MainActor
final class ArchiveViewModel: ObservableObject {
    @Published private(set) var archivedItems: [FoodItem] = []

    private let repository: FoodItemRepository

    init(repository: FoodItemRepository) {
        self.repository = repository
    }

    func load() {
        do {
            archivedItems = try repository.fetchArchivedItemsSortedByUpdatedAtDescending()
        } catch {
            archivedItems = []
        }
    }
}
