import SwiftData
import Foundation

@Model
final class Journey {
    @Attribute(.unique) var id: UUID
    var startDate: Date
    var completedDays: [String]  // ISO date strings "2024-01-26"
    var flexDaysUsed: Int
    var totalFocusTimeSeconds: Int

    init(startDate: Date = Date()) {
        self.id = UUID()
        self.startDate = Calendar.current.startOfDay(for: startDate)
        self.completedDays = []
        self.flexDaysUsed = 0
        self.totalFocusTimeSeconds = 0
    }

    var currentDay: Int {
        let calendar = Calendar.current
        let days = calendar.dateComponents([.day], from: startDate, to: Date()).day ?? 0
        return min(max(days + 1, 1), 66)
    }

    var currentPhase: JourneyPhase {
        if currentDay <= 21 { return .foundation }
        if currentDay <= 42 { return .strengthening }
        return .cementing
    }

    var currentStreak: Int {
        var streak = 0
        var checkDate = Date()
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate]

        while streak < currentDay {
            let dateString = formatter.string(from: checkDate).prefix(10)
            if completedDays.contains(String(dateString)) {
                streak += 1
                checkDate = Calendar.current.date(byAdding: .day, value: -1, to: checkDate)!
            } else {
                break
            }
        }
        return streak
    }

    var flexDaysRemaining: Int {
        3 - flexDaysUsed
    }

    var progress: Double {
        Double(currentDay) / 66.0
    }

    func isCompletedToday(habitIndex: Int = 0) -> Bool {
        let today = todayKey(habitIndex: habitIndex)
        return completedDays.contains(today)
    }

    func markComplete(habitIndex: Int = 0) {
        let today = todayKey(habitIndex: habitIndex)
        if !completedDays.contains(today) {
            completedDays.append(today)
        }
    }

    private func todayKey(habitIndex: Int) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate]
        let dateStr = String(formatter.string(from: Date()).prefix(10))
        return habitIndex == 0 ? dateStr : "\(dateStr)_2"
    }
}

enum JourneyPhase: String {
    case foundation = "Building Foundation"
    case strengthening = "Strengthening"
    case cementing = "Cementing Habit"
}
