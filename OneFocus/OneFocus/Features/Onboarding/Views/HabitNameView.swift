import SwiftUI

struct HabitNameView: View {
    let habitType: HabitType
    @Binding var habitName: String
    let placeholder: String
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
                Text("STEP 2 OF 3")
                    .font(.caption1)
                    .foregroundColor(.accent)
                    .kerning(1.5)

                Text("Name your habit")
                    .font(.title1)
                    .fontWeight(.semibold)

                Text("What do you want to do?")
                    .font(.subheadline)
                    .foregroundColor(.textSecondary)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 32)

            // Text field
            VStack(alignment: .leading, spacing: 8) {
                Text("HABIT NAME")
                    .font(.caption1)
                    .foregroundColor(.textSecondary)
                    .kerning(0.5)

                TextField("", text: $habitName, prompt: Text(placeholder).foregroundColor(.textTertiary))
                    .font(.body)
                    .foregroundColor(.textPrimary)
                    .padding(16)
                    .background(Color.bgSecondary)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
            }
            .padding(.horizontal, 20)

            // Type info
            HStack(spacing: 12) {
                Image(systemName: habitType.icon)
                    .foregroundColor(.accent)
                    .font(.title3)

                VStack(alignment: .leading, spacing: 2) {
                    Text(habitType.label)
                        .font(.footnote)
                        .fontWeight(.semibold)

                    Text(habitType.example)
                        .font(.caption2)
                        .foregroundColor(.textSecondary)
                }

                Spacer()
            }
            .padding(16)
            .background(Color.bgSecondary)
            .cornerRadius(16)
            .padding(.horizontal, 20)
            .padding(.top, 20)

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
                    .background(!habitName.isEmpty ? Color.accent : Color.bgTertiary)
                    .cornerRadius(14)
            }
            .disabled(habitName.isEmpty)
            .padding(.horizontal, 20)
            .padding(.bottom, 40)
        }
        .background(Color.bgPrimary)
    }
}

#Preview {
    HabitNameView(
        habitType: .binary,
        habitName: .constant(""),
        placeholder: "e.g., Meditate",
        onContinue: {},
        onBack: {}
    )
}
