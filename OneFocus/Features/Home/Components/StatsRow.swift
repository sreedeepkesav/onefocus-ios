import SwiftUI

struct StatsRow: View {
    let journey: Journey

    var completionRate: Int {
        guard journey.currentDay > 0 else { return 0 }
        return Int((Double(journey.completedDays.count) / Double(journey.currentDay)) * 100)
    }

    var body: some View {
        HStack(spacing: 12) {
            // Streak stat
            StatCard(
                value: "\(journey.currentStreak)",
                label: "Day Streak",
                icon: "flame.fill"
            )

            // Completion rate
            StatCard(
                value: "\(completionRate)%",
                label: "Complete",
                icon: "chart.line.uptrend.xyaxis"
            )

            // Flex days
            StatCard(
                value: "\(journey.flexDaysRemaining)",
                label: "Flex Days",
                icon: "star.fill"
            )
        }
    }
}

struct StatCard: View {
    let value: String
    let label: String
    let icon: String

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(
                    LinearGradient(
                        colors: [.accent, .accentSecondary],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(
                    LinearGradient(
                        colors: [.accent, .success],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )

            Text(label)
                .font(.caption1)
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 18)
        .background(Color.bgSecondary)
        .cornerRadius(16)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(value) \(label)")
    }
}

#Preview {
    let journey = Journey()
    journey.completedDays = ["2024-01-26", "2024-01-27", "2024-01-28"]

    return StatsRow(journey: journey)
        .padding()
        .background(Color.bgPrimary)
}
