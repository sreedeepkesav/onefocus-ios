import SwiftUI

struct TriggerSetupView: View {
    let habitName: String
    @Binding var trigger: String
    let onContinue: () -> Void
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

            // Header
            VStack(spacing: 8) {
                Text("STEP 3 OF 3")
                    .font(.caption1)
                    .foregroundColor(.accent)
                    .kerning(1.5)

                Text("Set your trigger")
                    .font(.title1)
                    .fontWeight(.semibold)

                Text("Anchor your habit to an existing action")
                    .font(.subheadline)
                    .foregroundColor(.textSecondary)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 32)

            ScrollView {
                VStack(spacing: 20) {
                    // Intention builder
                    VStack(alignment: .leading, spacing: 20) {
                        HStack(spacing: 10) {
                            Text("INTENTION")
                                .font(.caption2)
                                .foregroundColor(.accent)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(Color.accentDim)
                                .cornerRadius(20)
                        }

                        // After I...
                        HStack(spacing: 12) {
                            Text("After I")
                                .font(.body)
                                .foregroundColor(.textSecondary)

                            TextField("", text: $trigger, prompt: Text("pour my coffee").foregroundColor(.textTertiary))
                                .font(.body)
                                .foregroundColor(.textPrimary)
                                .padding(14)
                                .background(Color.bgPrimary)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                )
                        }

                        // I will...
                        HStack(spacing: 12) {
                            Text("I will")
                                .font(.body)
                                .foregroundColor(.textSecondary)

                            Text(habitName.isEmpty ? "your habit" : habitName)
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.accent)
                        }
                    }
                    .padding(24)
                    .background(Color.bgSecondary)
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white.opacity(0.05), lineWidth: 1)
                    )

                    // Pro tip
                    HStack(alignment: .top, spacing: 12) {
                        Text("💡")
                            .font(.title3)

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Pro tip")
                                .font(.footnote)
                                .fontWeight(.semibold)
                                .foregroundColor(.success)

                            Text("Choose a trigger that happens every day at roughly the same time. Examples: \"wake up\", \"brush my teeth\", \"sit at my desk\"")
                                .font(.footnote)
                                .foregroundColor(.textSecondary)
                                .lineSpacing(4)
                        }
                    }
                    .padding(16)
                    .background(
                        LinearGradient(
                            colors: [Color.success.opacity(0.1), Color(hex: "64D2FF").opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(16)
                }
                .padding(.horizontal, 20)
            }

            Spacer()

            // Continue button
            Button(action: {
                HapticManager.shared.trigger(.light)
                onContinue()
            }) {
                Text("Continue")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(!trigger.isEmpty ? Color.accent : Color.bgTertiary)
                    .cornerRadius(14)
            }
            .disabled(trigger.isEmpty)
            .padding(.horizontal, 20)
            .padding(.bottom, 40)
        }
        .background(Color.bgPrimary)
    }
}

#Preview {
    TriggerSetupView(
        habitName: "Meditate",
        trigger: .constant(""),
        onContinue: {},
        onBack: {}
    )
}
