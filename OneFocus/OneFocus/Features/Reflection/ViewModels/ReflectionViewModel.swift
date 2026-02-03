import SwiftUI
import SwiftData

@Observable
@MainActor
final class ReflectionViewModel {
    private let dataService = DataService.shared

    var whatHelped: String = ""
    var whatHindered: String = ""
    var patternsNoticed: String = ""

    var weekNumber: Int
    var timeRemaining: Int = 120  // 2 minutes in seconds
    var isSubmitting: Bool = false

    init(weekNumber: Int) {
        self.weekNumber = weekNumber
    }

    var canSubmit: Bool {
        !whatHelped.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
        !whatHindered.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
        !patternsNoticed.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var progressPercentage: Double {
        Double(120 - timeRemaining) / 120.0
    }

    func submit(onComplete: @escaping () -> Void) {
        guard canSubmit else { return }

        isSubmitting = true

        let reflection = Reflection(
            weekNumber: weekNumber,
            whatHelped: whatHelped.trimmingCharacters(in: .whitespacesAndNewlines),
            whatHindered: whatHindered.trimmingCharacters(in: .whitespacesAndNewlines),
            patternsNoticed: patternsNoticed.trimmingCharacters(in: .whitespacesAndNewlines),
            skipped: false
        )

        dataService.createReflection(reflection)

        HapticManager.shared.trigger(.success)
        isSubmitting = false

        onComplete()
    }

    func skip(onComplete: @escaping () -> Void) {
        let reflection = Reflection(
            weekNumber: weekNumber,
            skipped: true
        )

        dataService.createReflection(reflection)

        HapticManager.shared.trigger(.light)
        onComplete()
    }
}
