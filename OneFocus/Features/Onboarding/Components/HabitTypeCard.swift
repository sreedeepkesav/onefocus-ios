import SwiftUI

struct HabitTypeCard: View {
    let type: HabitType
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 10) {
                Image(systemName: type.icon)
                    .font(.system(size: 32))
                    .foregroundColor(.accent)

                Text(type.label)
                    .font(.subheadline)
                    .fontWeight(.semibold)

                Text(type.description)
                    .font(.caption2)
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .padding(.horizontal, 14)
            .background(
                ZStack {
                    Color.bgSecondary

                    if isSelected {
                        LinearGradient(
                            colors: [Color.accentDim, Color.clear],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    }
                }
            )
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(isSelected ? Color.accent : Color.clear, lineWidth: 2)
            )
            .scaleEffect(isSelected ? 1.02 : 1.0)
            .animation(.spring(response: 0.3), value: isSelected)
        }
        .buttonStyle(.plain)
    }
}

struct HabitTypeCardFullWidth: View {
    let type: HabitType
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: type.icon)
                    .font(.system(size: 28))
                    .foregroundColor(.accent)

                VStack(alignment: .leading, spacing: 2) {
                    Text(type.label)
                        .font(.subheadline)
                        .fontWeight(.semibold)

                    Text(type.description)
                        .font(.caption2)
                        .foregroundColor(.textSecondary)
                }

                Spacer()
            }
            .padding(16)
            .frame(maxWidth: .infinity)
            .background(
                ZStack {
                    Color.bgSecondary

                    if isSelected {
                        LinearGradient(
                            colors: [Color.accentDim, Color.clear],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    }
                }
            )
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(isSelected ? Color.accent : Color.clear, lineWidth: 2)
            )
            .scaleEffect(isSelected ? 1.02 : 1.0)
            .animation(.spring(response: 0.3), value: isSelected)
        }
        .buttonStyle(.plain)
    }
}
