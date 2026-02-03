import SwiftData
import Foundation

enum JourneyStatus: String, Codable {
    case active = "active"
    case completed = "completed"
    case failed = "failed"
}

@Model
final class Journey {
    @Attribute(.unique) var id: UUID
    var startDate: Date
    var completedDays: [String]  // ISO date strings "2024-01-26"
    var flexDaysUsed: Int
    var totalFocusTimeSeconds: Int
    var status: String  // Using String for SwiftData compatibility
    var failureAnalysisCompleted: Bool
    var failureAnalysisNotes: String?  // JSON string of analysis data
    var endDate: Date?  // When journey completed or failed

    init(startDate: Date = Date()) {
        self.id = UUID()
        self.startDate = Calendar.current.startOfDay(for: startDate)
        self.completedDays = []
        self.flexDaysUsed = 0
        self.totalFocusTimeSeconds = 0
        self.status = JourneyStatus.active.rawValue
        self.failureAnalysisCompleted = false
        self.failureAnalysisNotes = nil
        self.endDate = nil
    }

    var journeyStatus: JourneyStatus {
        get { JourneyStatus(rawValue: status) ?? .active }
        set { status = newValue.rawValue }
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

    /// Check if journey has failed
    var hasFailed: Bool {
        // Journey fails if:
        // 1. Day 66+ reached with < 63 completed days
        // 2. 3+ consecutive days missed (not using flex days appropriately)
        if currentDay >= 66 {
            return completedDays.count < 63
        }

        // Check for 3+ consecutive misses
        let calendar = Calendar.current
        var consecutiveMisses = 0
        var checkDate = Date()
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate]

        for _ in 0..<min(currentDay, 3) {
            let dateString = formatter.string(from: checkDate).prefix(10)
            if !completedDays.contains(String(dateString)) {
                consecutiveMisses += 1
                if consecutiveMisses >= 3 {
                    return true
                }
            } else {
                consecutiveMisses = 0
            }
            checkDate = calendar.date(byAdding: .day, value: -1, to: checkDate) ?? checkDate
        }

        return false
    }

    /// Get completion data by week (for failure analysis)
    func getWeeklyCompletionData() -> [WeekCompletionData] {
        var weeks: [WeekCompletionData] = []
        let calendar = Calendar.current
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate]

        for weekNum in 1...10 {
            let startDay = (weekNum - 1) * 7 + 1
            let endDay = min(weekNum * 7, 66)

            var completedInWeek = 0
            for day in startDay...endDay {
                if let dayDate = calendar.date(byAdding: .day, value: day - 1, to: startDate) {
                    let dateString = formatter.string(from: dayDate).prefix(10)
                    if completedDays.contains(String(dateString)) {
                        completedInWeek += 1
                    }
                }
            }

            let totalDays = endDay - startDay + 1
            let percentage = Double(completedInWeek) / Double(totalDays)

            weeks.append(WeekCompletionData(
                weekNumber: weekNum,
                completedDays: completedInWeek,
                totalDays: totalDays,
                completionRate: percentage
            ))
        }

        return weeks
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

struct WeekCompletionData: Identifiable {
    let id = UUID()
    let weekNumber: Int
    let completedDays: Int
    let totalDays: Int
    let completionRate: Double

    var displayText: String {
        "Week \(weekNumber): \(completedDays)/\(totalDays) days (\(Int(completionRate * 100))%)"
    }
}

struct FailureAnalysisData: Codable {
    let whatWorked: String
    let whatDidnt: String
    let nextTimeChanges: String
    let bestWeek: Int
    let worstWeek: Int
    let analyzedAt: Date
}
