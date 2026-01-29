import SwiftUI

struct HabitCard: View {
    let habit: Habit
    let isCompleted: Bool
    let onTap: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Accent bar
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: isCompleted ? [.success, .accentSecondary] : [.accent, .accentSecondary],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 4)

            VStack(alignment: .leading, spacing: 12) {
                // Header with type badge
                HStack {
                    HStack(spacing: 6) {
                        Image(systemName: habit.typeIcon)
                            .font(.caption2)

                        Text(habit.typeLabel)
                            .font(.caption2)
                            .textCase(.uppercase)
                    }
                    .foregroundColor(.accent)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color.accentDim)
                    .cornerRadius(20)

                    Spacer()

                    if !habit.isSecondary {
                        Text("Primary")
                            .font(.caption2)
                            .foregroundColor(.textTertiary)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(Color.bgTertiary)
                            .cornerRadius(10)
                    }
                }

                // Habit name
                Text(habit.name)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.textPrimary)

                // Trigger
                if habit.type.requiresTrigger {
                    Text(habit.triggerDisplayText)
                        .font(.subheadline)
                        .foregroundColor(.textSecondary)
                }

                // Action button
                Button(action: onTap) {
                    HStack {
                        Spacer()

                        if isCompleted {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.headline)

                            Text("Completed")
                                .font(.headline)
                                .fontWeight(.semibold)
                        } else {
                            Text("Start Focus Mode")
                                .font(.headline)
                                .fontWeight(.semibold)
                        }

                        Spacer()
                    }
                    .padding(16)
                    .background(
                        isCompleted ?
                        Color.success.opacity(0.15) :
                        LinearGradient(
                            colors: [.accent, .accentSecondary],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .foregroundColor(isCompleted ? .success : .white)
                    .cornerRadius(14)
                }
                .accessibilityLabel(isCompleted ? "Completed for today" : "Start focus mode for \(habit.name)")
            }
            .padding(20)
        }
        .background(Color.bgSecondary)
        .cornerRadius(24)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(habit.name), \(habit.typeLabel) habit, \(isCompleted ? "completed" : "not completed")")
    }
}

#Preview {
    VStack(spacing: 16) {
        HabitCard(
            habit: Habit(
                name: "Morning Meditation",
                type: .binary,
                trigger: "wake up",
                triggerType: .anchor
            ),
            isCompleted: false,
            onTap: {}
        )

        HabitCard(
            habit: Habit(
                name: "Evening Reading",
                type: .timed,
                trigger: "dinner",
                triggerType: .anchor,
                timedMinutes: 20
            ),
            isCompleted: true,
            onTap: {}
        )
    }
    .padding()
    .background(Color.bgPrimary)
}
