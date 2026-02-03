import SwiftUI

struct CelebrationView: View {
    let day: Int
    let streak: Int
    let phase: JourneyPhase
    let onDismiss: () -> Void

    @State private var isAnimating = false

    var body: some View {
        ZStack {
            // Gradient background
            LinearGradient(
                colors: [
                    Color.bgPrimary,
                    Color.success.opacity(0.05)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 32) {
                Spacer()

                // Checkmark animation
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.success)
                    .scaleEffect(isAnimating ? 1.0 : 0)
                    .opacity(isAnimating ? 1.0 : 0)
                    .animation(
                        .spring(response: 0.6, dampingFraction: 0.6),
                        value: isAnimating
                    )

                VStack(spacing: 8) {
                    Text("Day \(day) Complete!")
                        .font(.title1)
                        .fontWeight(.bold)
                        .foregroundColor(.textPrimary)

                    Text(motivationalMessage)
                        .font(.body)
                        .foregroundColor(.textSecondary)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .frame(maxWidth: 280)
                }

                // Stats
                HStack(spacing: 40) {
                    VStack(spacing: 4) {
                        Text("\(streak)")
                            .font(.system(size: 40, weight: .bold))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.accent, .success],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )

                        Text("Day Streak")
                            .font(.caption1)
                            .foregroundColor(.textSecondary)
                            .textCase(.uppercase)
                            .tracking(1)
                    }

                    VStack(spacing: 4) {
                        Text("\(day)")
                            .font(.system(size: 40, weight: .bold))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.accent, .success],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )

                        Text("of 66 Days")
                            .font(.caption1)
                            .foregroundColor(.textSecondary)
                            .textCase(.uppercase)
                            .tracking(1)
                    }
                }
                .padding(.vertical, 20)

                // Phase badge
                Text(phase.rawValue)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.success)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color.success.opacity(0.15))
                    .cornerRadius(20)

                Spacer()

                // Return home button
                Button(action: {
                    onDismiss()
                }) {
                    Text("Back to Home")
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
                .accessibilityLabel("Return to home screen")
            }
        }
        .onAppear {
            withAnimation {
                isAnimating = true
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Day \(day) complete! \(streak) day streak. \(motivationalMessage)")
    }

    private var motivationalMessage: String {
        switch phase {
        case .foundation:
            if day <= 7 {
                return "Great start! You're building the foundation."
            } else if day <= 14 {
                return "Two weeks in! Keep the momentum going."
            } else {
                return "Foundation phase almost complete!"
            }
        case .strengthening:
            if day <= 28 {
                return "You're strengthening your habit daily."
            } else if day <= 35 {
                return "Over halfway there! Stay consistent."
            } else {
                return "Strengthening phase nearly done!"
            }
        case .cementing:
            if day <= 56 {
                return "You're cementing this habit for life."
            } else if day < 66 {
                return "Almost there! Keep going strong."
            } else {
                return "Congratulations! 66 days complete!"
            }
        }
    }
}

#Preview {
    CelebrationView(
        day: 15,
        streak: 12,
        phase: .foundation,
        onDismiss: {}
    )
}
