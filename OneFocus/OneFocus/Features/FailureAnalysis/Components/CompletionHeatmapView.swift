import SwiftUI

struct CompletionHeatmapView: View {
    let journey: Journey
    let columns = Array(repeating: GridItem(.flexible(), spacing: 4), count: 7)

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Your 66-Day Journey")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.textPrimary)

            LazyVGrid(columns: columns, spacing: 4) {
                ForEach(1...66, id: \.self) { day in
                    DayCell(day: day, journey: journey)
                }
            }

            // Legend
            HStack(spacing: 16) {
                LegendItem(color: .success, label: "Completed")
                LegendItem(color: .textTertiary, label: "Missed")
                LegendItem(color: .bgTertiary, label: "Not reached")
            }
            .font(.caption)
        }
        .padding(20)
        .background(Color.bgSecondary)
        .cornerRadius(16)
    }
}

struct DayCell: View {
    let day: Int
    let journey: Journey

    var cellColor: Color {
        let calendar = Calendar.current
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate]

        guard let dayDate = calendar.date(byAdding: .day, value: day - 1, to: journey.startDate) else {
            return .bgTertiary
        }

        // Check if this day has passed
        if dayDate > Date() {
            return .bgTertiary
        }

        let dateString = formatter.string(from: dayDate).prefix(10)
        if journey.completedDays.contains(String(dateString)) {
            return .success
        } else {
            return .textTertiary.opacity(0.3)
        }
    }

    var body: some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(cellColor)
            .aspectRatio(1, contentMode: .fit)
            .accessibilityLabel("Day \(day), \(isCompleted ? "completed" : "missed")")
    }

    private var isCompleted: Bool {
        let calendar = Calendar.current
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate]

        guard let dayDate = calendar.date(byAdding: .day, value: day - 1, to: journey.startDate) else {
            return false
        }

        if dayDate > Date() { return false }

        let dateString = formatter.string(from: dayDate).prefix(10)
        return journey.completedDays.contains(String(dateString))
    }
}

struct LegendItem: View {
    let color: Color
    let label: String

    var body: some View {
        HStack(spacing: 6) {
            RoundedRectangle(cornerRadius: 3)
                .fill(color)
                .frame(width: 12, height: 12)

            Text(label)
                .foregroundColor(.textSecondary)
        }
    }
}

#Preview {
    let journey = Journey()
    journey.completedDays = ["2024-02-01", "2024-02-02", "2024-02-03"]
    return CompletionHeatmapView(journey: journey)
        .background(Color.bgPrimary)
}
