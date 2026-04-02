import Foundation
import SwiftData

@Model
final class FoodItem {
    @Attribute(.unique) var id: UUID
    private var nameRaw: String
    var expiryDate: Date
    var locationRaw: String
    var quantity: Double?
    var note: String?
    var statusRaw: String
    var createdAt: Date
    var updatedAt: Date

    var name: String {
        get { nameRaw }
        set { nameRaw = Self.normalizedName(newValue) }
    }

    var location: StorageLocation {
        get {
            StorageLocation(rawValue: locationRaw) ?? .fridge
        }
        set { locationRaw = newValue.rawValue }
    }

    var status: ItemStatus {
        get {
            ItemStatus(rawValue: statusRaw) ?? .active
        }
        set { statusRaw = newValue.rawValue }
    }

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
        self.id = id
        self.nameRaw = Self.normalizedName(name)
        self.expiryDate = expiryDate
        self.locationRaw = location.rawValue
        self.quantity = quantity
        self.note = note
        self.statusRaw = status.rawValue
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    private static func normalizedName(_ value: String) -> String {
        value.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
