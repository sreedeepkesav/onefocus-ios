import SwiftUI

@Observable
@MainActor
final class MoodViewModel {
    var selectedMood: Int?
    var notes: String = ""

    let moods: [(emoji: String, label: String, value: Int)] = [
        ("😢", "Terrible", 1),
        ("😕", "Bad", 2),
        ("😐", "Okay", 3),
        ("🙂", "Good", 4),
        ("😄", "Great", 5)
    ]

    var canContinue: Bool {
        selectedMood != nil
    }

    func selectMood(_ value: Int) {
        selectedMood = value
    }

    func getMoodColor(_ value: Int) -> Color {
        switch value {
        case 1: return .mood1
        case 2: return .mood2
        case 3: return .mood3
        case 4: return .mood4
        case 5: return .mood5
        default: return .textSecondary
        }
    }
}
