import SwiftUI

struct MoodAfterView: View {
    let habitName: String
    let onComplete: (Int, String?) -> Void

    @State private var viewModel = MoodViewModel()
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 32) {
                Spacer()

                VStack(spacing: 8) {
                    Text("How do you feel now?")
                        .font(.title1)
                        .fontWeight(.semibold)
                        .foregroundColor(.textPrimary)

                    Text("After \(habitName)")
                        .font(.subheadline)
                        .foregroundColor(.textSecondary)
                }

                // Mood options
                HStack(spacing: 12) {
                    ForEach(viewModel.moods, id: \.value) { mood in
                        MoodButton(
                            emoji: mood.emoji,
                            value: mood.value,
                            isSelected: viewModel.selectedMood == mood.value,
                            color: viewModel.getMoodColor(mood.value),
                            action: {
                                viewModel.selectMood(mood.value)
                            }
                        )
                    }
                }
                .padding(.horizontal, 20)

                // Labels
                HStack {
                    Text(viewModel.moods[0].label)
                        .font(.caption1)
                        .foregroundColor(.textTertiary)

                    Spacer()

                    Text(viewModel.moods[4].label)
                        .font(.caption1)
                        .foregroundColor(.textTertiary)
                }
                .padding(.horizontal, 30)

                // Optional notes
                VStack(alignment: .leading, spacing: 8) {
                    Text("Notes (Optional)")
                        .font(.footnote)
                        .foregroundColor(.textSecondary)
                        .textCase(.uppercase)
                        .tracking(0.5)
                        .padding(.horizontal, 4)

                    TextField("How do you feel now?", text: $viewModel.notes, axis: .vertical)
                        .font(.body)
                        .foregroundColor(.textPrimary)
                        .padding(16)
                        .background(Color.bgSecondary)
                        .cornerRadius(12)
                        .lineLimit(3...6)
                }
                .padding(.horizontal, 20)

                Spacer()

                // Continue button
                Button(action: {
                    if let mood = viewModel.selectedMood {
                        onComplete(mood, viewModel.notes.isEmpty ? nil : viewModel.notes)
                        dismiss()
                    }
                }) {
                    Text("Complete")
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(minHeight: 44)
                        .padding(.vertical, 17)
                        .background(
                            viewModel.canContinue ?
                            LinearGradient(
                                colors: [.success, .accentSecondary],
                                startPoint: .leading,
                                endPoint: .trailing
                            ) :
                            LinearGradient(
                                colors: [.bgTertiary, .bgTertiary],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(14)
                }
                .disabled(!viewModel.canContinue)
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
                .accessibilityLabel("Complete habit")
            }
            .background(Color.bgPrimary)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        // Can't dismiss after - must select mood
                    }) {
                        Image(systemName: "xmark")
                            .font(.body)
                            .fontWeight(.semibold)
                            .foregroundColor(.textSecondary)
                    }
                    .disabled(true)
                    .opacity(0)
                }
            }
        }
        .interactiveDismissDisabled()
    }
}

#Preview {
    MoodAfterView(
        habitName: "Morning Meditation",
        onComplete: { _, _ in }
    )
}
