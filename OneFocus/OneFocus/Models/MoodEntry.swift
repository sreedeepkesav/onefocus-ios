import SwiftData
import Foundation

@Model
final class MoodEntry {
    @Attribute(.unique) var id: UUID
    var timestamp: Date
    var mood: Int  // 1-5
    var habitId: UUID?
    var isBefore: Bool  // Before or after habit completion

    init(mood: Int, habitId: UUID? = nil, isBefore: Bool = true) {
        self.id = UUID()
        self.timestamp = Date()
        self.mood = mood
        self.habitId = habitId
        self.isBefore = isBefore
    }
}
