import Foundation
import Observation

@Observable
final class OnboardingViewModel {
    var currentStep = 0
    var selectedType: HabitType?
    var habitName = ""
    var trigger = ""
    var triggerType: TriggerType = .anchor
    var startValue: Int?
    var targetValue: Int?
    var dailyTarget: Int = 8
    var timedMinutes: Int = 10

    var isValid: Bool {
        switch currentStep {
        case 0: return true // Welcome
        case 1: return selectedType != nil
        case 2: return !habitName.isEmpty
        case 3:
            // TriggerSetup - required for non-repeating
            if selectedType?.requiresTrigger == true {
                return !trigger.isEmpty
            }
            return true
        case 4:
            // TriggerRepeating - always optional for repeating
            return true
        case 5: return true // Ready
        default: return false
        }
    }

    var totalSteps: Int {
        // Welcome, Type, Name, Trigger (conditional), Ready
        if selectedType == .repeating {
            return 5 // Welcome, Type, Name, TriggerRepeating, Ready
        } else {
            return 4 // Welcome, Type, Name, TriggerSetup, Ready
        }
    }

    func next() {
        currentStep += 1
    }

    func back() {
        if currentStep > 0 {
            currentStep -= 1
        }
    }

    func placeholder(for type: HabitType) -> String {
        switch type {
        case .binary:
            return "e.g., Meditate, Journal, Exercise"
        case .timed:
            return "e.g., Read, Practice piano"
        case .increment:
            return "e.g., Pushups, Pages read"
        case .reduction:
            return "e.g., Cigarettes, Scrolling time"
        case .repeating:
            return "e.g., Drink water, Stand up"
        }
    }

    @MainActor
    func complete() async {
        guard let type = selectedType else { return }

        let habit = Habit(
            name: habitName,
            type: type,
            trigger: trigger,
            triggerType: triggerType,
            isSecondary: false,
            startValue: startValue,
            targetValue: targetValue,
            dailyTarget: type == .repeating ? dailyTarget : nil,
            timedMinutes: type == .timed ? timedMinutes : nil
        )

        DataService.shared.createHabit(habit)
        _ = DataService.shared.getOrCreateJourney()

        // Mark onboarding complete
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
    }
}
