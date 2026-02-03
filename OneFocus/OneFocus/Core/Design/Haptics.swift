import UIKit
import SwiftUI

enum HapticType {
    case light
    case medium
    case heavy
    case success
    case warning
    case error
    case selection
}

final class HapticManager {
    static let shared = HapticManager()
    private init() {}

    func trigger(_ type: HapticType) {
        switch type {
        case .light:
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        case .medium:
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        case .heavy:
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        case .success:
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        case .warning:
            UINotificationFeedbackGenerator().notificationOccurred(.warning)
        case .error:
            UINotificationFeedbackGenerator().notificationOccurred(.error)
        case .selection:
            UISelectionFeedbackGenerator().selectionChanged()
        }
    }
}

extension View {
    func haptic(_ type: HapticType) -> some View {
        self.simultaneousGesture(
            TapGesture().onEnded { _ in
                HapticManager.shared.trigger(type)
            }
        )
    }
}
