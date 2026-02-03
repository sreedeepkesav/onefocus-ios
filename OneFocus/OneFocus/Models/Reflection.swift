import SwiftData
import Foundation

@Model
final class Reflection {
    @Attribute(.unique) var id: UUID
    var createdAt: Date
    var weekNumber: Int  // Which week (1-10 for 66 day journey)
    var whatHelped: String
    var whatHindered: String
    var patternsNoticed: String
    var skipped: Bool

    init(weekNumber: Int, whatHelped: String = "", whatHindered: String = "", patternsNoticed: String = "", skipped: Bool = false) {
        self.id = UUID()
        self.createdAt = Date()
        self.weekNumber = weekNumber
        self.whatHelped = whatHelped
        self.whatHindered = whatHindered
        self.patternsNoticed = patternsNoticed
        self.skipped = skipped
    }

    var weekLabel: String {
        "Week \(weekNumber)"
    }

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: createdAt)
    }

    var isEmpty: Bool {
        whatHelped.isEmpty && whatHindered.isEmpty && patternsNoticed.isEmpty
    }
}
