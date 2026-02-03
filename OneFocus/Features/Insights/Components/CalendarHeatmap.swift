import SwiftUI

struct CalendarHeatmap: View {
    let days: [HeatmapDay]
    
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 4), count: 7)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("66-Day Journey")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(.textPrimary)
                
                Spacer()
                
                HStack(spacing: 12) {
                    HeatmapLegendItem(color: .success, label: "Complete")
                    HeatmapLegendItem(color: .textTertiary, label: "Incomplete")
                }
            }
            
            LazyVGrid(columns: columns, spacing: 4) {
                ForEach(days) { day in
                    HeatmapCell(day: day)
                }
            }
        }
        .padding(20)
        .background(Color.bgSecondary)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct HeatmapCell: View {
    let day: HeatmapDay
    
    var backgroundColor: Color {
        if day.isFuture {
            return Color.bgTertiary.opacity(0.3)
        } else if day.isCompleted {
            return Color.success
        } else {
            return Color.bgTertiary
        }
    }
    
    var borderColor: Color {
        if day.isToday {
            return Color.accent
        }
        return Color.clear
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4)
                .fill(backgroundColor)
            
            RoundedRectangle(cornerRadius: 4)
                .strokeBorder(borderColor, lineWidth: 2)
            
            if day.isCompleted {
                Image(systemName: "checkmark")
                    .font(.system(size: 8, weight: .bold))
                    .foregroundStyle(.white)
            }
        }
        .frame(height: 36)
        .accessibilityLabel("Day \(day.dayNumber)")
        .accessibilityValue(day.isCompleted ? "Completed" : "Not completed")
    }
}

struct HeatmapLegendItem: View {
    let color: Color
    let label: String
    
    var body: some View {
        HStack(spacing: 4) {
            RoundedRectangle(cornerRadius: 3)
                .fill(color)
                .frame(width: 12, height: 12)
            
            Text(label)
                .font(.system(size: 11))
                .foregroundStyle(.textSecondary)
        }
    }
}
