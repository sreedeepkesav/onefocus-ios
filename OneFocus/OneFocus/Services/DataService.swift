import SwiftData
import Foundation

@MainActor
final class DataService {
    static let shared = DataService()

    let container: ModelContainer

    private init() {
        let schema = Schema([
            Habit.self,
            Journey.self,
            MoodEntry.self,
            RepeatingLog.self,
            Reflection.self
        ])

        let config = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false,
            groupContainer: .identifier("group.com.onefocus.shared")
        )

        do {
            container = try ModelContainer(for: schema, configurations: config)
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }

    var context: ModelContext {
        container.mainContext
    }

    // MARK: - Habit Operations

    func getPrimaryHabit() -> Habit? {
        let descriptor = FetchDescriptor<Habit>(
            predicate: #Predicate { !$0.isSecondary },
            sortBy: [SortDescriptor(\.createdAt)]
        )
        return try? context.fetch(descriptor).first
    }

    func getSecondaryHabit() -> Habit? {
        let descriptor = FetchDescriptor<Habit>(
            predicate: #Predicate { $0.isSecondary },
            sortBy: [SortDescriptor(\.createdAt)]
        )
        return try? context.fetch(descriptor).first
    }

    func createHabit(_ habit: Habit) {
        context.insert(habit)
        try? context.save()
    }

    // MARK: - Journey Operations

    func getOrCreateJourney() -> Journey {
        let descriptor = FetchDescriptor<Journey>()
        if let journey = try? context.fetch(descriptor).first {
            return journey
        }
        let journey = Journey()
        context.insert(journey)
        try? context.save()
        return journey
    }

    // MARK: - Repeating Logs

    func getRepeatingCount(for habitIndex: Int, on date: Date = Date()) -> Int {
        let dateKey = makeRepeatingKey(date: date, habitIndex: habitIndex)
        let descriptor = FetchDescriptor<RepeatingLog>(
            predicate: #Predicate { $0.dateKey == dateKey }
        )
        return (try? context.fetch(descriptor).first?.count) ?? 0
    }

    func incrementRepeating(for habitIndex: Int, on date: Date = Date()) {
        let dateKey = makeRepeatingKey(date: date, habitIndex: habitIndex)
        let descriptor = FetchDescriptor<RepeatingLog>(
            predicate: #Predicate { $0.dateKey == dateKey }
        )

        if let log = try? context.fetch(descriptor).first {
            log.count += 1
        } else {
            let log = RepeatingLog(dateKey: dateKey)
            context.insert(log)
        }
        try? context.save()
    }

    private func makeRepeatingKey(date: Date, habitIndex: Int) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate]
        let dateStr = String(formatter.string(from: date).prefix(10))
        return "\(dateStr)_\(habitIndex)"
    }

    // MARK: - Mood Entries

    func createMoodEntry(_ entry: MoodEntry) {
        context.insert(entry)
        try? context.save()
    }

    // MARK: - Analytics

    func getCompletionStats() -> (rate: Double, bestStreak: Int, currentStreak: Int) {
        let journey = getOrCreateJourney()
        
        let daysPassed = journey.currentDay
        let daysCompleted = journey.completedDays.count
        let rate = daysPassed > 0 ? Double(daysCompleted) / Double(daysPassed) : 0
        
        // Calculate best streak
        let sortedDates = journey.completedDays
            .compactMap { dateString -> Date? in
                let formatter = ISO8601DateFormatter()
                formatter.formatOptions = [.withFullDate]
                return formatter.date(from: dateString)
            }
            .sorted()
        
        var maxStreak = 0
        var currentStreakCount = 0
        
        if !sortedDates.isEmpty {
            maxStreak = 1
            currentStreakCount = 1
            
            for i in 1..<sortedDates.count {
                let prevDate = sortedDates[i - 1]
                let currentDate = sortedDates[i]
                
                let calendar = Calendar.current
                if let daysBetween = calendar.dateComponents([.day], from: prevDate, to: currentDate).day,
                   daysBetween == 1 {
                    currentStreakCount += 1
                    maxStreak = max(maxStreak, currentStreakCount)
                } else {
                    currentStreakCount = 1
                }
            }
        }
        
        return (rate: rate, bestStreak: maxStreak, currentStreak: journey.currentStreak)
    }
    
    func getTotalFocusTime() -> Int {
        let journey = getOrCreateJourney()
        return journey.totalFocusTimeSeconds
    }

    // MARK: - Reflection Operations

    func createReflection(_ reflection: Reflection) {
        context.insert(reflection)
        try? context.save()
    }

    func getReflection(forWeek weekNumber: Int) -> Reflection? {
        let descriptor = FetchDescriptor<Reflection>(
            predicate: #Predicate { $0.weekNumber == weekNumber },
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        return try? context.fetch(descriptor).first
    }

    func getAllReflections() -> [Reflection] {
        let descriptor = FetchDescriptor<Reflection>(
            sortBy: [SortDescriptor(\.weekNumber, order: .reverse)]
        )
        return (try? context.fetch(descriptor)) ?? []
    }

    func isReflectionDue() -> (isDue: Bool, weekNumber: Int) {
        let journey = getOrCreateJourney()
        let currentDay = journey.currentDay

        // Reflection triggers on Day 7, 14, 21, 28, 35, 42, 49, 56, 63
        guard currentDay % 7 == 0 && currentDay <= 66 else {
            return (false, 0)
        }

        let weekNumber = currentDay / 7

        // Check if reflection for this week already exists
        if let _ = getReflection(forWeek: weekNumber) {
            return (false, 0)
        }

        return (true, weekNumber)
    }

    // MARK: - Failure Analysis Operations

    func checkJourneyFailure() -> Bool {
        let journey = getOrCreateJourney()
        return journey.hasFailed && journey.journeyStatus == .active
    }

    func saveFailureAnalysis(whatWorked: String, whatDidnt: String, nextTimeChanges: String) {
        let journey = getOrCreateJourney()
        let weeklyData = journey.getWeeklyCompletionData()

        // Find best and worst weeks
        let bestWeek = weeklyData.max(by: { $0.completionRate < $1.completionRate })?.weekNumber ?? 1
        let worstWeek = weeklyData.min(by: { $0.completionRate < $1.completionRate })?.weekNumber ?? 1

        let analysis = FailureAnalysisData(
            whatWorked: whatWorked,
            whatDidnt: whatDidnt,
            nextTimeChanges: nextTimeChanges,
            bestWeek: bestWeek,
            worstWeek: worstWeek,
            analyzedAt: Date()
        )

        // Save as JSON string
        if let jsonData = try? JSONEncoder().encode(analysis),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            journey.failureAnalysisNotes = jsonString
            journey.failureAnalysisCompleted = true
            journey.journeyStatus = .failed
            journey.endDate = Date()
            try? context.save()
        }
    }

    func archiveFailedJourney() -> Journey? {
        let journey = getOrCreateJourney()
        guard journey.journeyStatus == .failed else { return nil }

        // Create new journey
        let newJourney = Journey()
        context.insert(newJourney)
        try? context.save()

        return journey
    }

    func getArchivedJourneys() -> [Journey] {
        let descriptor = FetchDescriptor<Journey>(
            predicate: #Predicate { $0.status != JourneyStatus.active.rawValue },
            sortBy: [SortDescriptor(\.endDate, order: .reverse)]
        )
        return (try? context.fetch(descriptor)) ?? []
    }
}
