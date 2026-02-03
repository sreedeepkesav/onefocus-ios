import SwiftUI

struct InsightStatCard: View {
    let icon: String
    let title: String
    let value: String
    let subtitle: String?
    let color: Color
    
    init(
        icon: String,
        title: String,
        value: String,
        subtitle: String? = nil,
        color: Color = .accent
    ) {
        self.icon = icon
        self.title = title
        self.value = value
        self.subtitle = subtitle
        self.color = color
    }
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 56, height: 56)
                
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(color)
            }
            
            VStack(spacing: 4) {
                Text(value)
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundStyle(.textPrimary)
                
                Text(title)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(.textSecondary)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.system(size: 11))
                        .foregroundStyle(.textTertiary)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(Color.bgSecondary)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct InsightStatsRow: View {
    let stats: [(icon: String, title: String, value: String, color: Color)]
    
    var body: some View {
        HStack(spacing: 12) {
            ForEach(0..<stats.count, id: \.self) { index in
                InsightStatCard(
                    icon: stats[index].icon,
                    title: stats[index].title,
                    value: stats[index].value,
                    color: stats[index].color
                )
            }
        }
    }
}
