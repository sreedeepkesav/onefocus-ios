import SwiftUI

struct ReflectionView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: ReflectionViewModel

    let onComplete: () -> Void

    init(weekNumber: Int, onComplete: @escaping () -> Void) {
        _viewModel = State(initialValue: ReflectionViewModel(weekNumber: weekNumber))
        self.onComplete = onComplete
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.bgPrimary.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 32) {
                        // Header
                        VStack(spacing: 12) {
                            Text("🔍")
                                .font(.system(size: 48))
                                .accessibilityHidden(true)

                            Text("Weekly Reflection")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.textPrimary)

                            Text("Week \(viewModel.weekNumber)")
                                .font(.headline)
                                .foregroundColor(.accent)

                            Text("Take 2 minutes to reflect on your journey")
                                .font(.subheadline)
                                .foregroundColor(.textSecondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top, 24)

                        // Questions
                        VStack(spacing: 24) {
                            ReflectionQuestionCard(
                                icon: "checkmark.seal.fill",
                                question: "What helped you succeed this week?",
                                placeholder: "E.g., morning routine, support from friends...",
                                text: $viewModel.whatHelped
                            )

                            ReflectionQuestionCard(
                                icon: "exclamationmark.triangle.fill",
                                question: "What made it hard to show up?",
                                placeholder: "E.g., late nights, stressful work...",
                                text: $viewModel.whatHindered
                            )

                            ReflectionQuestionCard(
                                icon: "chart.line.uptrend.xyaxis",
                                question: "Did you notice any patterns?",
                                placeholder: "E.g., weekends are harder, mornings work best...",
                                text: $viewModel.patternsNoticed
                            )
                        }

                        // Action Buttons
                        VStack(spacing: 16) {
                            Button {
                                viewModel.submit {
                                    onComplete()
                                    dismiss()
                                }
                            } label: {
                                HStack {
                                    if viewModel.isSubmitting {
                                        ProgressView()
                                            .tint(.white)
                                    } else {
                                        Text("Save Reflection")
                                    }
                                }
                                .font(.body)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(16)
                                .background(
                                    viewModel.canSubmit
                                        ? LinearGradient(
                                            colors: [.accent, .accentSecondary],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                        : LinearGradient(
                                            colors: [.textSecondary.opacity(0.3), .textSecondary.opacity(0.3)],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                )
                                .cornerRadius(16)
                            }
                            .disabled(!viewModel.canSubmit || viewModel.isSubmitting)
                            .accessibilityLabel("Save your weekly reflection")
                            .accessibilityHint(viewModel.canSubmit ? "Saves your answers" : "Fill in at least one question to save")

                            Button {
                                viewModel.skip {
                                    onComplete()
                                    dismiss()
                                }
                            } label: {
                                Text("Skip This Week")
                                    .font(.body)
                                    .foregroundColor(.textSecondary)
                            }
                            .accessibilityLabel("Skip this week's reflection")
                        }
                        .padding(.bottom, 32)
                    }
                    .padding(.horizontal, 20)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                        HapticManager.shared.trigger(.light)
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.textSecondary)
                            .symbolRenderingMode(.hierarchical)
                    }
                    .accessibilityLabel("Close reflection")
                }
            }
        }
    }
}

struct ReflectionQuestionCard: View {
    let icon: String
    let question: String
    let placeholder: String
    @Binding var text: String

    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.accent)
                    .accessibilityHidden(true)

                Text(question)
                    .font(.headline)
                    .foregroundColor(.textPrimary)
            }

            ZStack(alignment: .topLeading) {
                if text.isEmpty {
                    Text(placeholder)
                        .font(.body)
                        .foregroundColor(.textSecondary)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .accessibilityHidden(true)
                }

                TextEditor(text: $text)
                    .font(.body)
                    .foregroundColor(.textPrimary)
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                    .frame(minHeight: 100)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .focused($isFocused)
                    .accessibilityLabel(question)
                    .accessibilityHint("Text field for your answer")
            }
            .background(Color.bgTertiary)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isFocused ? Color.accent : Color.clear, lineWidth: 2)
            )
        }
        .padding(16)
        .background(Color.bgSecondary)
        .cornerRadius(16)
    }
}

#Preview {
    ReflectionView(weekNumber: 1) {
        print("Reflection completed")
    }
}
