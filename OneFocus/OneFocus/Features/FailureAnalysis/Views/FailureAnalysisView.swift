import SwiftUI

struct FailureAnalysisView: View {
    @State private var viewModel: FailureAnalysisViewModel
    @Environment(\.dismiss) private var dismiss
    let onComplete: () -> Void

    init(journey: Journey, onComplete: @escaping () -> Void) {
        self._viewModel = State(initialValue: FailureAnalysisViewModel(journey: journey))
        self.onComplete = onComplete
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 12) {
                        Text("📊")
                            .font(.system(size: 48))
                            .accessibilityHidden(true)

                        Text("Learning from This Journey")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.textPrimary)
                            .multilineTextAlignment(.center)

                        Text("Every attempt teaches us something valuable")
                            .font(.subheadline)
                            .foregroundColor(.textSecondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 20)
                    .padding(.horizontal, 20)

                    // Stats summary
                    StatsSummaryCard(
                        completedDays: viewModel.journey.completedDays.count,
                        totalDays: viewModel.journey.currentDay,
                        completionRate: viewModel.totalCompletionRate
                    )
                    .padding(.horizontal, 20)

                    // Heatmap
                    CompletionHeatmapView(journey: viewModel.journey)
                        .padding(.horizontal, 20)

                    // Week breakdown
                    WeekBreakdownView(weeklyData: viewModel.weeklyData)
                        .padding(.horizontal, 20)

                    // Reflection questions
                    ReflectionQuestionsView(
                        whatWorked: $viewModel.whatWorked,
                        whatDidnt: $viewModel.whatDidnt,
                        nextTimeChanges: $viewModel.nextTimeChanges
                    )
                    .padding(.horizontal, 20)

                    // Action buttons
                    VStack(spacing: 12) {
                        Button(action: {
                            viewModel.saveAnalysis()
                            viewModel.startFreshJourney()
                            HapticManager.shared.trigger(.success)
                            onComplete()
                            dismiss()
                        }) {
                            HStack {
                                Image(systemName: "arrow.clockwise")
                                Text("Start Fresh Journey")
                            }
                            .font(.body)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(16)
                            .background(
                                LinearGradient(
                                    colors: [.accent, .accentSecondary],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(14)
                        }

                        Button(action: {
                            if viewModel.canSaveAnalysis {
                                viewModel.saveAnalysis()
                            }
                            dismiss()
                        }) {
                            Text(viewModel.canSaveAnalysis ? "Save Insights" : "Skip")
                                .font(.body)
                                .fontWeight(.medium)
                                .foregroundColor(.textSecondary)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
            }
            .background(Color.bgPrimary)
            .navigationBarTitleDisplayMode(.inline)
            .interactiveDismissDisabled()
        }
    }
}

struct StatsSummaryCard: View {
    let completedDays: Int
    let totalDays: Int
    let completionRate: Double

    var body: some View {
        HStack(spacing: 20) {
            VStack(spacing: 4) {
                Text("\(completedDays)")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.success)

                Text("Days Completed")
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }
            .frame(maxWidth: .infinity)

            Divider()
                .frame(height: 40)
                .background(Color.textTertiary)

            VStack(spacing: 4) {
                Text("\(Int(completionRate * 100))%")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.warning)

                Text("Completion Rate")
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }
            .frame(maxWidth: .infinity)
        }
        .padding(20)
        .background(Color.bgSecondary)
        .cornerRadius(16)
    }
}

struct ReflectionQuestionsView: View {
    @Binding var whatWorked: String
    @Binding var whatDidnt: String
    @Binding var nextTimeChanges: String

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Reflection Questions")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.textPrimary)

            VStack(alignment: .leading, spacing: 16) {
                QuestionField(
                    icon: "checkmark.circle.fill",
                    iconColor: .success,
                    question: "What worked well?",
                    placeholder: "E.g., morning routine, visual reminders...",
                    text: $whatWorked
                )

                QuestionField(
                    icon: "xmark.circle.fill",
                    iconColor: .error,
                    question: "What didn't work?",
                    placeholder: "E.g., too ambitious, conflicting schedule...",
                    text: $whatDidnt
                )

                QuestionField(
                    icon: "lightbulb.fill",
                    iconColor: .warning,
                    question: "What will you change next time?",
                    placeholder: "E.g., start smaller, adjust timing...",
                    text: $nextTimeChanges
                )
            }
        }
        .padding(20)
        .background(Color.bgSecondary)
        .cornerRadius(16)
    }
}

struct QuestionField: View {
    let icon: String
    let iconColor: Color
    let question: String
    let placeholder: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.footnote)
                    .foregroundColor(iconColor)

                Text(question)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.textPrimary)
            }

            TextField(placeholder, text: $text, axis: .vertical)
                .textFieldStyle(.plain)
                .font(.body)
                .foregroundColor(.textPrimary)
                .lineLimit(3...5)
                .padding(12)
                .background(Color.bgTertiary)
                .cornerRadius(10)
                .accessibilityLabel(question)
                .accessibilityHint(placeholder)
        }
    }
}

#Preview {
    let journey = Journey()
    journey.completedDays = ["2024-02-01", "2024-02-02", "2024-02-03"]
    return FailureAnalysisView(journey: journey, onComplete: {})
}
