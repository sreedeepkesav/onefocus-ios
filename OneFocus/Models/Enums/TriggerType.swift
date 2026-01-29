import Foundation

enum TriggerType: String, Codable, CaseIterable, Identifiable {
    case anchor      // "After I ___"
    case throughout  // No specific trigger
    case context     // Context cues

    var id: String { rawValue }

    var label: String {
        switch self {
        case .anchor: return "After a specific action"
        case .throughout: return "Throughout the day"
        case .context: return "At specific moments"
        }
    }

    var description: String {
        switch self {
        case .anchor: return "Use the traditional \"After I ___\" format"
        case .throughout: return "No specific trigger - log whenever you do it"
        case .context: return "Set context cues like \"with meals\" or \"during work\""
        }
    }

    var isRecommendedForRepeating: Bool {
        self == .throughout
    }
}
