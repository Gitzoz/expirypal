import Foundation

enum ItemStatus: String, Codable, CaseIterable {
    case active
    case consumed
    case discarded
}
