import SwiftUI

struct FocusView: View {
    let habit: Habit
    let onComplete: () -> Void
    let onDismiss: () -> Void

    @State private var viewModel = FocusViewModel()
    @Environment(\.accessibilityReduceMotion) var reduceMotion

    var body: some View {
        ZStack {
            Color.bgPrimary.ignoresSafeArea()

            VStack(spacing: 32) {
                Spacer()

                // Badge
                HStack(spacing: 8) {
                    Image(systemName: "wind")
                        .font(.caption2)

                    Text("Focus Mode")
                        .font(.caption1)
                        .textCase(.uppercase)
                        .tracking(1)
                }
                .foregroundColor(.accent)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.accentDim)
                .cornerRadius(20)

                // Habit name
                VStack(spacing: 8) {
                    Text(habit.name)
                        .font(.title1)
                        .fontWeight(.semibold)
                        .foregroundColor(.textPrimary)

                    if habit.type.requiresTrigger {
                        Text(habit.triggerDisplayText)
                            .font(.subheadline)
                            .foregroundColor(.textSecondary)
                    }
                }

                Spacer()

                // Breathing animation
                if !viewModel.isComplete {
                    VStack(spacing: 24) {
                        BreathingCircle(phase: viewModel.currentPhase)

                        // Progress indicator
                        HStack(spacing: 8) {
                            ForEach(0..<3, id: \.self) { index in
                                Circle()
                                    .fill(index < viewModel.cycleCount ? Color.accent : Color.bgSecondary)
                                    .frame(width: 8, height: 8)
                            }
                        }
                        .padding(.top, 16)

                        Text("Cycle \(viewModel.cycleCount + 1) of 3")
                            .font(.caption1)
                            .foregroundColor(.textSecondary)
                    }
                } else {
                    // Completion state
                    VStack(spacing: 16) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.success)

                        Text("Breathing Complete")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.textPrimary)
                    }
                }

                Spacer()

                // Actions
                HStack(spacing: 12) {
                    if !viewModel.isComplete {
                        // Skip button
                        Button(action: {
                            viewModel.skip()
                        }) {
                            Text("Skip")
                                .font(.body)
                                .fontWeight(.medium)
                                .foregroundColor(.textPrimary)
                                .frame(maxWidth: .infinity)
                                .frame(minHeight: 44)
                                .padding(.vertical, 16)
                                .background(Color.bgSecondary)
                                .cornerRadius(14)
                        }
                        .accessibilityLabel("Skip breathing exercise")
                    } else {
                        // Continue to mood check
                        Button(action: {
                            onComplete()
                        }) {
                            Text("Continue")
                                .font(.body)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(minHeight: 44)
                                .padding(.vertical, 16)
                                .background(
                                    LinearGradient(
                                        colors: [.accent, .accentSecondary],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(14)
                        }
                        .accessibilityLabel("Continue to mood check")
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }

            // Close button
            VStack {
                HStack {
                    Button(action: {
                        viewModel.stopBreathing()
                        onDismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.body)
                            .fontWeight(.semibold)
                            .foregroundColor(.textSecondary)
                            .frame(width: 44, height: 44)
                            .background(Color.bgSecondary)
                            .clipShape(Circle())
                    }
                    .accessibilityLabel("Close focus mode")

                    Spacer()
                }
                .padding(20)

                Spacer()
            }
        }
        .onAppear {
            if !viewModel.isComplete {
                viewModel.startBreathing()
            }
        }
        .onDisappear {
            viewModel.stopBreathing()
        }
    }
}

#Preview {
    FocusView(
        habit: Habit(
            name: "Morning Meditation",
            type: .binary,
            trigger: "wake up",
            triggerType: .anchor
        ),
        onComplete: {},
        onDismiss: {}
    )
}
