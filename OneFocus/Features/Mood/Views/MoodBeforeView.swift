import SwiftUI

struct MoodBeforeView: View {
    let habitName: String
    let onComplete: (Int, String?) -> Void
    let onDismiss: () -> Void

    @State private var viewModel = MoodViewModel()
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 32) {
                Spacer()

                VStack(spacing: 8) {
                    Text("How are you feeling?")
                        .font(.title1)
                        .fontWeight(.semibold)
                        .foregroundColor(.textPrimary)

                    Text("Before \(habitName)")
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

                    TextField("How are you feeling right now?", text: $viewModel.notes, axis: .vertical)
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
                    Text("Continue")
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(minHeight: 44)
                        .padding(.vertical, 17)
                        .background(
                            viewModel.canContinue ?
                            LinearGradient(
                                colors: [.accent, .accentSecondary],
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
                .accessibilityLabel("Continue to focus mode")
            }
            .background(Color.bgPrimary)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        onDismiss()
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.body)
                            .fontWeight(.semibold)
                            .foregroundColor(.textSecondary)
                    }
                    .accessibilityLabel("Close")
                }
            }
        }
    }
}

struct MoodButton: View {
    let emoji: String
    let value: Int
    let isSelected: Bool
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(emoji)
                .font(.system(size: 28))
                .frame(width: 60, height: 60)
                .background(isSelected ? color.opacity(0.15) : Color.bgSecondary)
                .overlay(
                    Circle()
                        .stroke(isSelected ? color : .clear, lineWidth: 2)
                )
                .clipShape(Circle())
                .scaleEffect(isSelected ? 1.15 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
        }
        .accessibilityLabel("Mood rating \(value)")
        .accessibilityAddTraits(isSelected ? [.isSelected] : [])
    }
}

#Preview {
    MoodBeforeView(
        habitName: "Morning Meditation",
        onComplete: { _, _ in },
        onDismiss: {}
    )
}
