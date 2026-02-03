import SwiftUI

enum BreathingPhase {
    case inhale
    case hold
    case exhale

    var label: String {
        switch self {
        case .inhale: return "Inhale"
        case .hold: return "Hold"
        case .exhale: return "Exhale"
        }
    }

    var duration: Double {
        switch self {
        case .inhale: return 4.0
        case .hold: return 7.0
        case .exhale: return 8.0
        }
    }

    var scale: CGFloat {
        switch self {
        case .inhale: return 1.4
        case .hold: return 1.4
        case .exhale: return 1.0
        }
    }

    var next: BreathingPhase {
        switch self {
        case .inhale: return .hold
        case .hold: return .exhale
        case .exhale: return .inhale
        }
    }
}

struct BreathingCircle: View {
    let phase: BreathingPhase
    @Environment(\.accessibilityReduceMotion) var reduceMotion

    var body: some View {
        ZStack {
            // Outer glow during hold phase
            if phase == .hold && !reduceMotion {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [Color.accent.opacity(0.4), .clear],
                            center: .center,
                            startRadius: 60,
                            endRadius: 140
                        )
                    )
                    .frame(width: 280, height: 280)
            }

            // Main breathing circle
            Circle()
                .fill(
                    LinearGradient(
                        colors: [.accent, .accentSecondary],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 200, height: 200)
                .scaleEffect(reduceMotion ? 1.2 : phase.scale)
                .animation(
                    reduceMotion ? .none : .easeInOut(duration: phase.duration),
                    value: phase
                )
                .shadow(color: Color.accent.opacity(0.5), radius: 20)

            // Phase label
            VStack(spacing: 8) {
                Text(phase.label)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)

                // Countdown for current phase (optional enhancement)
                Text(String(format: "%.0f", phase.duration))
                    .font(.caption1)
                    .foregroundColor(.white.opacity(0.7))
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(phase.label) for \(Int(phase.duration)) seconds")
        .accessibilityHint("4-7-8 breathing exercise")
    }
}

#Preview {
    VStack(spacing: 40) {
        BreathingCircle(phase: .inhale)
        BreathingCircle(phase: .hold)
        BreathingCircle(phase: .exhale)
    }
    .padding()
    .background(Color.bgPrimary)
}
