import SwiftUI
import Observation

@Observable
@MainActor
final class FailureAnalysisViewModel {
    var journey: Journey
    var whatWorked: String = ""
    var whatDidnt: String = ""
    var nextTimeChanges: String = ""

    var weeklyData: [WeekCompletionData] = []

    init(journey: Journey) {
        self.journey = journey
        self.weeklyData = journey.getWeeklyCompletionData()
    }

    func saveAnalysis() {
        DataService.shared.saveFailureAnalysis(
            whatWorked: whatWorked,
            whatDidnt: whatDidnt,
            nextTimeChanges: nextTimeChanges
        )
        HapticManager.shared.trigger(.success)
    }

    func startFreshJourney() {
        _ = DataService.shared.archiveFailedJourney()
        HapticManager.shared.trigger(.success)
    }

    var canSaveAnalysis: Bool {
        !whatWorked.isEmpty || !whatDidnt.isEmpty || !nextTimeChanges.isEmpty
    }

    var bestWeek: WeekCompletionData? {
        weeklyData.max(by: { $0.completionRate < $1.completionRate })
    }

    var worstWeek: WeekCompletionData? {
        weeklyData.min(by: { $0.completionRate < $1.completionRate })
    }

    var totalCompletionRate: Double {
        let totalCompleted = journey.completedDays.count
        let totalDays = journey.currentDay
        return totalDays > 0 ? Double(totalCompleted) / Double(totalDays) : 0
    }
}
