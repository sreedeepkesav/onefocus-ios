import SwiftUI

struct WelcomeView: View {
    let onContinue: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 28) {
                // Floating app icon
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color.accent, Color.accentSecondary],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 88, height: 88)
                        .shadow(color: .accentGlow, radius: 32, x: 0, y: 8)

                    Text("1")
                        .font(.system(size: 42, weight: .bold))
                        .foregroundColor(.white)
                }
                .offset(y: floatingOffset)
                .animation(
                    .easeInOut(duration: 3)
                        .repeatForever(autoreverses: true),
                    value: floatingOffset
                )

                // Title
                Text("OneFocus")
                    .font(.system(size: 38, weight: .bold))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.textPrimary, .accent],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )

                // Subtitle
                Text("Moving forward, one habit at a time.")
                    .font(.body)
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 20)

            Spacer()
                .frame(height: 40)

            // Science cards
            VStack(spacing: 12) {
                ScienceCard(
                    icon: "🧠",
                    title: "66 days to automate",
                    description: "Research shows it takes 66 days on average to form a habit",
                    stat: nil,
                    gradient: [.accent, .accentSecondary]
                )

                ScienceCard(
                    icon: "⚡",
                    title: "Triggers create habits",
                    description: "Anchor new habits to existing behaviors for 2x success",
                    stat: nil,
                    gradient: [Color(hex: "FFD60A"), Color(hex: "FF9F0A")]
                )

                ScienceCard(
                    icon: "🎯",
                    title: "One focus at a time",
                    description: "Multi-tasking habits reduces success by 65%",
                    stat: nil,
                    gradient: [.success, Color(hex: "64D2FF")]
                )
            }
            .padding(.horizontal, 20)

            Spacer()

            // Continue button
            Button(action: {
                HapticManager.shared.trigger(.light)
                onContinue()
            }) {
                Text("Begin Your Journey")
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
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(
                colors: [.bgPrimary, Color.accent.opacity(0.05)],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }

    @State private var floatingOffset: CGFloat = -8
}

#Preview {
    WelcomeView(onContinue: {})
}
