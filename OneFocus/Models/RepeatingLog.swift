import SwiftData
import Foundation

@Model
final class RepeatingLog {
    @Attribute(.unique) var id: UUID
    var dateKey: String  // "2024-01-26_0" (date + habit index)
    var count: Int

    init(dateKey: String, count: Int = 1) {
        self.id = UUID()
        self.dateKey = dateKey
        self.count = count
    }
}
