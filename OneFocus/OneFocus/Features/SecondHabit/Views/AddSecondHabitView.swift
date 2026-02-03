import SwiftUI

struct AddSecondHabitView: View {
    let currentDay: Int
    let primaryHabitName: String
    let onStartOnboarding: () -> Void
    let onDismiss: () -> Void

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    Spacer(minLength: 40)

                    // Unlock icon
                    Text("🎉")
                        .font(.system(size: 80))

                    // Title
                    VStack(spacing: 8) {
                        Text("You can add a second habit!")
                            .font(.title1)
                            .fontWeight(.bold)
                            .foregroundColor(.textPrimary)
                            .multilineTextAlignment(.center)

                        Text("Day 21 Achievement Unlocked")
                            .font(.subheadline)
                            .foregroundColor(.textSecondary)
                    }
                    .padding(.horizontal, 20)

                    // Explanation card
                    VStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Running habits in parallel")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.textPrimary)

                            Text("You can now build two habits simultaneously. Research shows that after 21 days, your first habit is becoming automatic, making it easier to add a second.")
                                .font(.subheadline)
                                .foregroundColor(.textSecondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }

                        // Current habit indicator
                        HStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(Color.accentDim)
                                    .frame(width: 28, height: 28)

                                Text("1")
                                    .font(.caption1)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.accent)
                            }

                            Text(primaryHabitName)
                                .font(.subheadline)
                                .foregroundColor(.textPrimary)

                            Spacer()

                            Text("Day \(currentDay)")
                                .font(.caption1)
                                .foregroundColor(.accent)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(Color.accentDim)
                                .cornerRadius(10)
                        }
                        .padding(16)
                        .background(Color.bgTertiary)
                        .cornerRadius(12)
                    }
                    .padding(24)
                    .background(Color.bgSecondary)
                    .cornerRadius(20)
                    .padding(.horizontal, 20)

                    // Pro tip
                    HStack(alignment: .top, spacing: 12) {
                        Text("💡")
                            .font(.title3)

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Pro Tip")
                                .font(.caption1)
                                .fontWeight(.semibold)
                                .foregroundColor(.success)
                                .textCase(.uppercase)

                            Text("Choose a habit that complements your first one. Different times of day work best to avoid conflicts.")
                                .font(.footnote)
                                .foregroundColor(.textSecondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    .padding(16)
                    .background(
                        LinearGradient(
                            colors: [
                                Color.success.opacity(0.1),
                                Color.accentSecondary.opacity(0.1)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(16)
                    .padding(.horizontal, 20)

                    Spacer()

                    // Action button
                    Button(action: {
                        onStartOnboarding()
                    }) {
                        Text("Add Second Habit")
                            .font(.body)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(minHeight: 44)
                            .padding(.vertical, 17)
                            .background(
                                LinearGradient(
                                    colors: [.accent, .accentSecondary],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(14)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                    .accessibilityLabel("Add second habit")
                }
            }
            .background(Color.bgPrimary)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        onDismiss()
                    }) {
                        Text("Later")
                            .font(.body)
                            .foregroundColor(.accent)
                    }
                    .accessibilityLabel("Add habit later")
                }
            }
        }
    }
}

#Preview {
    AddSecondHabitView(
        currentDay: 21,
        primaryHabitName: "Morning Meditation",
        onStartOnboarding: {},
        onDismiss: {}
    )
}
