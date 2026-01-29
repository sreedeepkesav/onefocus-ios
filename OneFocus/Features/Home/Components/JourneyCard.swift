import SwiftUI

struct JourneyCard: View {
    let journey: Journey

    var body: some View {
        VStack(spacing: 0) {
            // Header with day and phase
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(journey.currentDay)")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.accent, .success],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )

                    Text("OF 66 DAYS")
                        .font(.caption1)
                        .foregroundColor(.textSecondary)
                        .textCase(.uppercase)
                        .tracking(1)
                }

                Spacer()

                // Phase badge
                Text(journey.currentPhase.rawValue)
                    .font(.caption1)
                    .fontWeight(.medium)
                    .foregroundColor(.accent)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.accentDim)
                    .cornerRadius(20)
            }
            .padding(.bottom, 20)

            // Progress visualization
            ZStack {
                // Progress ring
                ProgressRing(progress: journey.progress)
                    .frame(width: 80, height: 80)

                // Current streak in center
                VStack(spacing: 2) {
                    Text("\(journey.currentStreak)")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.textPrimary)

                    Text("streak")
                        .font(.caption2)
                        .foregroundColor(.textTertiary)
                        .textCase(.uppercase)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 16)

            // Flex days
            HStack {
                Text("Flex Days Remaining")
                    .font(.caption1)
                    .foregroundColor(.textSecondary)

                Spacer()

                HStack(spacing: 8) {
                    ForEach(0..<3, id: \.self) { index in
                        Circle()
                            .fill(index < journey.flexDaysRemaining ? Color.warning : Color.bgTertiary)
                            .frame(width: 12, height: 12)
                            .shadow(color: index < journey.flexDaysRemaining ? Color.warning.opacity(0.4) : .clear, radius: 4)
                    }
                }
            }
            .padding(.top, 16)
            .overlay(
                Rectangle()
                    .fill(Color.textSecondary.opacity(0.15))
                    .frame(height: 1),
                alignment: .top
            )
        }
        .padding(24)
        .background(
            ZStack {
                Color.bgSecondary

                LinearGradient(
                    colors: [Color.accent.opacity(0.08), .clear],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
        )
        .cornerRadius(24)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Journey progress: Day \(journey.currentDay) of 66, \(journey.currentStreak) day streak, \(journey.flexDaysRemaining) flex days remaining, \(journey.currentPhase.rawValue) phase")
    }
}

#Preview {
    let journey = Journey()
    journey.completedDays = ["2024-01-26", "2024-01-27", "2024-01-28"]

    return JourneyCard(journey: journey)
        .padding()
        .background(Color.bgPrimary)
}
