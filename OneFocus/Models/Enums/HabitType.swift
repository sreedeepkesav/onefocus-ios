import Foundation

enum HabitType: String, Codable, CaseIterable, Identifiable {
    case binary
    case timed
    case increment
    case reduction
    case repeating

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .binary: return "checkmark.circle"
        case .timed: return "timer"
        case .increment: return "chart.line.uptrend.xyaxis"
        case .reduction: return "chart.line.downtrend.xyaxis"
        case .repeating: return "arrow.2.squarepath"
        }
    }

    var emoji: String {
        switch self {
        case .binary: return "✓"
        case .timed: return "⏱"
        case .increment: return "📈"
        case .reduction: return "📉"
        case .repeating: return "🔄"
        }
    }

    var label: String {
        switch self {
        case .binary: return "Daily"
        case .timed: return "Timed"
        case .increment: return "Build Up"
        case .reduction: return "Cut Down"
        case .repeating: return "Repeating"
        }
    }

    var description: String {
        switch self {
        case .binary: return "Yes or no each day"
        case .timed: return "Duration-based habit"
        case .increment: return "Increase over time"
        case .reduction: return "Reduce a behavior"
        case .repeating: return "Multiple times daily"
        }
    }

    var requiresTrigger: Bool {
        self != .repeating
    }

    var example: String {
        switch self {
        case .binary: return "Meditate, Journal"
        case .timed: return "Read, Practice piano"
        case .increment: return "5 → 50 pushups"
        case .reduction: return "10 → 0 cigarettes"
        case .repeating: return "Drink 8 glasses of water"
        }
    }
}
