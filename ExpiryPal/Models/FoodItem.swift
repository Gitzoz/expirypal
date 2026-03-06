import Foundation

struct FoodItem: Identifiable {
    let id: UUID
    let name: String
    let expiryDate: Date
    let location: StorageLocation
    let quantity: Double?
    let note: String?
    let status: ItemStatus
    let createdAt: Date
    let updatedAt: Date

    init(
        id: UUID = UUID(),
        name: String,
        expiryDate: Date,
        location: StorageLocation,
        quantity: Double? = nil,
        note: String? = nil,
        status: ItemStatus = .active,
        createdAt: Date,
        updatedAt: Date
    ) {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        precondition(!trimmedName.isEmpty, "FoodItem name must be non-empty after trimming")

        self.id = id
        self.name = trimmedName
        self.expiryDate = expiryDate
        self.location = location
        self.quantity = quantity
        self.note = note
        self.status = status
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
