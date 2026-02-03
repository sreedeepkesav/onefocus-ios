import SwiftUI

struct TriggerRepeatingView: View {
    @Binding var triggerType: TriggerType
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
                Text("OPTIONAL")
                    .font(.caption1)
                    .foregroundColor(.accent)
                    .kerning(1.5)

                Text("Set a trigger")
                    .font(.title1)
                    .fontWeight(.semibold)

                Text("You can skip this or choose a reminder style")
                    .font(.subheadline)
                    .foregroundColor(.textSecondary)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 32)

            ScrollView {
                VStack(spacing: 12) {
                    // Throughout the day (recommended)
                    TriggerTypeOption(
                        type: .throughout,
                        isSelected: triggerType == .throughout,
                        isRecommended: true,
                        action: {
                            HapticManager.shared.trigger(.selection)
                            triggerType = .throughout
                            trigger = ""
                        }
                    )

                    // At specific moments
                    TriggerTypeOption(
                        type: .context,
                        isSelected: triggerType == .context,
                        isRecommended: false,
                        action: {
                            HapticManager.shared.trigger(.selection)
                            triggerType = .context
                        }
                    )

                    // Context input (if selected)
                    if triggerType == .context {
                        TextField("", text: $trigger, prompt: Text("e.g., With meals, During work").foregroundColor(.textTertiary))
                            .font(.body)
                            .foregroundColor(.textPrimary)
                            .padding(16)
                            .background(Color.bgSecondary)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
                            )
                            .padding(.horizontal, 20)
                            .transition(.opacity)
                    }

                    // After a specific action
                    TriggerTypeOption(
                        type: .anchor,
                        isSelected: triggerType == .anchor,
                        isRecommended: false,
                        action: {
                            HapticManager.shared.trigger(.selection)
                            triggerType = .anchor
                        }
                    )

                    // Anchor input (if selected)
                    if triggerType == .anchor {
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
                        .padding(20)
                        .background(Color.bgSecondary)
                        .cornerRadius(16)
                        .padding(.horizontal, 20)
                        .transition(.opacity)
                    }
                }
                .padding(.horizontal, 20)
            }

            Spacer()

            // Continue/Skip button
            Button(action: {
                HapticManager.shared.trigger(.light)
                onContinue()
            }) {
                Text(triggerType == .throughout ? "Continue" : "Continue")
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

struct TriggerTypeOption: View {
    let type: TriggerType
    let isSelected: Bool
    let isRecommended: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(alignment: .top, spacing: 14) {
                // Radio button
                ZStack {
                    Circle()
                        .stroke(isSelected ? Color.accent : Color.white.opacity(0.2), lineWidth: 2)
                        .frame(width: 24, height: 24)

                    if isSelected {
                        Circle()
                            .fill(Color.accent)
                            .frame(width: 24, height: 24)

                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.white)
                    }
                }
                .padding(.top, 2)

                // Content
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(type.label)
                            .font(.body)
                            .fontWeight(.semibold)

                        if isRecommended {
                            Text("RECOMMENDED")
                                .font(.caption2)
                                .foregroundColor(.success)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 2)
                                .background(Color.success.opacity(0.15))
                                .cornerRadius(10)
                        }
                    }

                    Text(type.description)
                        .font(.footnote)
                        .foregroundColor(.textSecondary)
                        .lineSpacing(4)
                }

                Spacer()
            }
            .padding(18)
            .background(
                ZStack {
                    Color.bgSecondary

                    if isSelected {
                        Color.accentDim
                    }
                }
            )
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? Color.accent : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    TriggerRepeatingView(
        triggerType: .constant(.throughout),
        trigger: .constant(""),
        onContinue: {},
        onBack: {}
    )
}
