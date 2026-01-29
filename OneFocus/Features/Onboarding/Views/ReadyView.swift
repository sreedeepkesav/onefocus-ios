import SwiftUI

struct ReadyView: View {
    let habitName: String
    let habitType: HabitType
    let trigger: String
    let triggerType: TriggerType
    let onStart: () -> Void
    let onBack: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            // Navigation bar
            HStack {
                Button(action: onBack) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .font(.body)
                        Text("Back")
                    }
                    .foregroundColor(.accent)
                }
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)

            ScrollView {
                VStack(spacing: 32) {
                    // Header
                    VStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [Color.accent, Color.accentSecondary],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 80, height: 80)
                                .shadow(color: .accentGlow, radius: 24)

                            Image(systemName: "checkmark")
                                .font(.system(size: 36, weight: .bold))
                                .foregroundColor(.white)
                        }

                        Text("You're all set!")
                            .font(.title1)
                            .fontWeight(.bold)

                        Text("Your 66-day journey begins now")
                            .font(.subheadline)
                            .foregroundColor(.textSecondary)
                    }
                    .padding(.top, 20)

                    // Journey summary
                    VStack(spacing: 16) {
                        // Habit
                        VStack(alignment: .leading, spacing: 12) {
                            Text("YOUR HABIT")
                                .font(.caption1)
                                .foregroundColor(.textSecondary)
                                .kerning(0.5)

                            HStack(spacing: 12) {
                                Image(systemName: habitType.icon)
                                    .font(.title2)
                                    .foregroundColor(.accent)
                                    .frame(width: 40)

                                VStack(alignment: .leading, spacing: 2) {
                                    Text(habitName)
                                        .font(.title3)
                                        .fontWeight(.semibold)

                                    Text(habitType.label)
                                        .font(.caption1)
                                        .foregroundColor(.textSecondary)
                                }

                                Spacer()
                            }
                        }
                        .padding(20)
                        .background(Color.bgSecondary)
                        .cornerRadius(16)

                        // Trigger
                        if !trigger.isEmpty || triggerType == .throughout {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("YOUR TRIGGER")
                                    .font(.caption1)
                                    .foregroundColor(.textSecondary)
                                    .kerning(0.5)

                                HStack(spacing: 12) {
                                    Image(systemName: "bolt.fill")
                                        .font(.title2)
                                        .foregroundColor(.warning)
                                        .frame(width: 40)

                                    VStack(alignment: .leading, spacing: 2) {
                                        if triggerType == .throughout {
                                            Text("Throughout the day")
                                                .font(.body)
                                                .fontWeight(.medium)
                                        } else if triggerType == .context {
                                            Text(trigger)
                                                .font(.body)
                                                .fontWeight(.medium)
                                        } else {
                                            Text("After I \(trigger)")
                                                .font(.body)
                                                .fontWeight(.medium)
                                        }

                                        Text("Daily reminder")
                                            .font(.caption1)
                                            .foregroundColor(.textSecondary)
                                    }

                                    Spacer()
                                }
                            }
                            .padding(20)
                            .background(Color.bgSecondary)
                            .cornerRadius(16)
                        }

                        // Journey timeline
                        VStack(alignment: .leading, spacing: 12) {
                            Text("YOUR JOURNEY")
                                .font(.caption1)
                                .foregroundColor(.textSecondary)
                                .kerning(0.5)

                            VStack(spacing: 14) {
                                TimelineRow(
                                    day: "Day 1-21",
                                    title: "Building Foundation",
                                    icon: "🌱"
                                )

                                TimelineRow(
                                    day: "Day 22-42",
                                    title: "Strengthening",
                                    icon: "💪"
                                )

                                TimelineRow(
                                    day: "Day 43-66",
                                    title: "Cementing Habit",
                                    icon: "🔒"
                                )
                            }
                            .padding(20)
                            .background(Color.bgSecondary)
                            .cornerRadius(16)
                        }

                        // Flex days info
                        HStack(alignment: .top, spacing: 12) {
                            Text("💎")
                                .font(.title3)

                            VStack(alignment: .leading, spacing: 4) {
                                Text("3 flex days included")
                                    .font(.footnote)
                                    .fontWeight(.semibold)

                                Text("Life happens. You have 3 days you can miss without breaking your journey.")
                                    .font(.footnote)
                                    .foregroundColor(.textSecondary)
                                    .lineSpacing(4)
                            }
                        }
                        .padding(16)
                        .background(Color.accentDim)
                        .cornerRadius(16)
                    }
                    .padding(.horizontal, 20)
                }
            }

            Spacer()

            // Start button
            Button(action: {
                HapticManager.shared.trigger(.success)
                onStart()
            }) {
                Text("Start My Journey")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accent)
                    .cornerRadius(14)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 40)
        }
        .background(Color.bgPrimary)
    }
}

struct TimelineRow: View {
    let day: String
    let title: String
    let icon: String

    var body: some View {
        HStack(spacing: 12) {
            Text(icon)
                .font(.title3)
                .frame(width: 32)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.body)
                    .fontWeight(.medium)

                Text(day)
                    .font(.caption1)
                    .foregroundColor(.textSecondary)
            }

            Spacer()
        }
    }
}

#Preview {
    ReadyView(
        habitName: "Meditate",
        habitType: .binary,
        trigger: "pour my coffee",
        triggerType: .anchor,
        onStart: {},
        onBack: {}
    )
}
