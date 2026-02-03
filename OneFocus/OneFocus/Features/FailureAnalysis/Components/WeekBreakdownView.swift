import SwiftUI

struct WeekBreakdownView: View {
    let weeklyData: [WeekCompletionData]

    var bestWeek: WeekCompletionData? {
        weeklyData.max(by: { $0.completionRate < $1.completionRate })
    }

    var worstWeek: WeekCompletionData? {
        weeklyData.min(by: { $0.completionRate < $1.completionRate })
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Week-by-Week Breakdown")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.textPrimary)

            VStack(spacing: 12) {
                ForEach(weeklyData.prefix(9)) { week in
                    WeekRow(
                        week: week,
                        isBest: week.weekNumber == bestWeek?.weekNumber,
                        isWorst: week.weekNumber == worstWeek?.weekNumber
                    )
                }
            }

            if let best = bestWeek, let worst = worstWeek {
                VStack(alignment: .leading, spacing: 8) {
                    InsightText(
                        icon: "star.fill",
                        text: "Your best week was Week \(best.weekNumber) (\(Int(best.completionRate * 100))% completion)",
                        color: .success
                    )

                    InsightText(
                        icon: "exclamationmark.triangle.fill",
                        text: "Week \(worst.weekNumber) was most challenging (\(Int(worst.completionRate * 100))% completion)",
                        color: .warning
                    )
                }
                .padding(.top, 8)
            }
        }
        .padding(20)
        .background(Color.bgSecondary)
        .cornerRadius(16)
    }
}

struct WeekRow: View {
    let week: WeekCompletionData
    let isBest: Bool
    let isWorst: Bool

    var body: some View {
        HStack(spacing: 12) {
            Text("Week \(week.weekNumber)")
                .font(.footnote)
                .fontWeight(.medium)
                .foregroundColor(.textPrimary)
                .frame(width: 60, alignment: .leading)

            // Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.bgTertiary)

                    RoundedRectangle(cornerRadius: 4)
                        .fill(barColor)
                        .frame(width: geometry.size.width * week.completionRate)
                }
            }
            .frame(height: 8)

            Text("\(week.completedDays)/\(week.totalDays)")
                .font(.footnote)
                .foregroundColor(.textSecondary)
                .frame(width: 40, alignment: .trailing)

            if isBest || isWorst {
                Image(systemName: isBest ? "star.fill" : "exclamationmark.triangle.fill")
                    .font(.caption)
                    .foregroundColor(isBest ? .success : .warning)
            }
        }
        .accessibilityLabel("\(week.displayText), \(isBest ? "best week" : isWorst ? "most challenging week" : "")")
    }

    private var barColor: Color {
        if week.completionRate >= 0.85 {
            return .success
        } else if week.completionRate >= 0.6 {
            return .warning
        } else {
            return .error.opacity(0.6)
        }
    }
}

struct InsightText: View {
    let icon: String
    let text: String
    let color: Color

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundColor(color)

            Text(text)
                .font(.footnote)
                .foregroundColor(.textSecondary)
        }
    }
}

#Preview {
    let sampleData = [
        WeekCompletionData(weekNumber: 1, completedDays: 6, totalDays: 7, completionRate: 0.86),
        WeekCompletionData(weekNumber: 2, completedDays: 5, totalDays: 7, completionRate: 0.71),
        WeekCompletionData(weekNumber: 3, completedDays: 3, totalDays: 7, completionRate: 0.43),
        WeekCompletionData(weekNumber: 4, completedDays: 7, totalDays: 7, completionRate: 1.0),
    ]

    return WeekBreakdownView(weeklyData: sampleData)
        .background(Color.bgPrimary)
}
