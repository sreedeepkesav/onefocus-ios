import SwiftUI

struct HabitTypeView: View {
    @Binding var selectedType: HabitType?
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
                Text("STEP 1 OF 3")
                    .font(.caption1)
                    .foregroundColor(.accent)
                    .kerning(1.5)

                Text("Choose your habit type")
                    .font(.title1)
                    .fontWeight(.semibold)

                Text("Select how you want to track progress")
                    .font(.subheadline)
                    .foregroundColor(.textSecondary)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 24)

            ScrollView {
                VStack(spacing: 12) {
                    // First 4 types in 2x2 grid
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        ForEach([HabitType.binary, .timed, .increment, .reduction], id: \.self) { type in
                            HabitTypeCard(
                                type: type,
                                isSelected: selectedType == type,
                                action: {
                                    HapticManager.shared.trigger(.selection)
                                    selectedType = type
                                }
                            )
                        }
                    }

                    // Repeating type full-width
                    HabitTypeCardFullWidth(
                        type: .repeating,
                        isSelected: selectedType == .repeating,
                        action: {
                            HapticManager.shared.trigger(.selection)
                            selectedType = .repeating
                        }
                    )
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
                    .background(selectedType != nil ? Color.accent : Color.bgTertiary)
                    .cornerRadius(14)
            }
            .disabled(selectedType == nil)
            .padding(.horizontal, 20)
            .padding(.bottom, 40)
        }
        .background(Color.bgPrimary)
    }
}

#Preview {
    HabitTypeView(
        selectedType: .constant(.binary),
        onContinue: {},
        onBack: {}
    )
}
