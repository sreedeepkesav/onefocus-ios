import SwiftUI
import SwiftData

@Observable
@MainActor
final class HomeViewModel {
    private let dataService = DataService.shared

    var journey: Journey?
    var primaryHabit: Habit?
    var secondaryHabit: Habit?

    var showingFocusMode = false
    var selectedHabit: Habit?
    var showingMoodBefore = false
    var showingMoodAfter = false
    var showingCelebration = false

    init() {
        loadData()
    }

    func loadData() {
        journey = dataService.getOrCreateJourney()
        primaryHabit = dataService.getPrimaryHabit()
        secondaryHabit = dataService.getSecondaryHabit()
    }

    func isPrimaryCompleted() -> Bool {
        journey?.isCompletedToday(habitIndex: 0) ?? false
    }

    func isSecondaryCompleted() -> Bool {
        journey?.isCompletedToday(habitIndex: 1) ?? false
    }

    func startFocusMode(for habit: Habit) {
        selectedHabit = habit
        showingMoodBefore = true
    }

    func handleQuickCompletion(for habit: Habit) {
        selectedHabit = habit
        let habitIndex = habit.isSecondary ? 1 : 0

        // For binary habits, show mood check before and after
        if habit.type == .binary {
            showingMoodBefore = true
        } else {
            // For other types, go to focus mode
            showingFocusMode = true
        }
    }

    func completeMoodBefore(mood: Int, notes: String?) {
        guard let habit = selectedHabit else { return }

        // Save before mood
        let entry = MoodEntry(mood: mood, habitId: habit.id, isBefore: true)
        dataService.createMoodEntry(entry)

        showingMoodBefore = false

        // For binary habits, go directly to focus mode
        if habit.type == .binary {
            showingFocusMode = true
        }
    }

    func completeHabit() {
        guard let habit = selectedHabit, let journey = journey else { return }

        let habitIndex = habit.isSecondary ? 1 : 0
        journey.markComplete(habitIndex: habitIndex)

        showingFocusMode = false
        showingMoodAfter = true
    }

    func completeMoodAfter(mood: Int, notes: String?) {
        guard let habit = selectedHabit else { return }

        // Save after mood
        let entry = MoodEntry(mood: mood, habitId: habit.id, isBefore: false)
        dataService.createMoodEntry(entry)

        showingMoodAfter = false
        showingCelebration = true
    }

    func dismissCelebration() {
        showingCelebration = false
        selectedHabit = nil
        loadData()
    }

    var canAddSecondHabit: Bool {
        guard let journey = journey else { return false }
        return journey.currentDay >= 21 && secondaryHabit == nil
    }
}
