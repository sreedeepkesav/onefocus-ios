import SwiftUI

struct ScienceCard: View {
    let icon: String
    let title: String
    let description: String
    let stat: String?
    let gradient: [Color]

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            ZStack {
                LinearGradient(
                    colors: gradient,
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .frame(width: 44, height: 44)
                .cornerRadius(12)

                Text(icon)
                    .font(.system(size: 22))
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)

                Text(description)
                    .font(.footnote)
                    .foregroundColor(.textSecondary)
                    .lineLimit(2)

                if let stat = stat {
                    Text(stat)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.accent)
                        .padding(.top, 4)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(Color.bgSecondary)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.05), lineWidth: 1)
        )
    }
}
