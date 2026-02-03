import Foundation
import SwiftUI

@Observable
final class InsightsViewModel {
    var journey: Journey?
    var primaryHabit: Habit?
    var secondaryHabit: Habit?
    
    private let dataService = DataService.shared
    
    var completionRate: Double {
        guard let journey = journey else { return 0 }
        let daysPassed = journey.currentDay
        let daysCompleted = journey.completedDays.count
        return daysPassed > 0 ? Double(daysCompleted) / Double(daysPassed) : 0
    }
    
    var bestStreak: Int {
        guard let journey = journey else { return 0 }
        
        let sortedDates = journey.completedDays
            .compactMap { dateString -> Date? in
                let formatter = ISO8601DateFormatter()
                formatter.formatOptions = [.withFullDate]
                return formatter.date(from: dateString)
            }
            .sorted()
        
        guard !sortedDates.isEmpty else { return 0 }
        
        var maxStreak = 1
        var currentStreak = 1
        
        for i in 1..<sortedDates.count {
            let prevDate = sortedDates[i - 1]
            let currentDate = sortedDates[i]
            
            let calendar = Calendar.current
            if let daysBetween = calendar.dateComponents([.day], from: prevDate, to: currentDate).day,
               daysBetween == 1 {
                currentStreak += 1
                maxStreak = max(maxStreak, currentStreak)
            } else {
                currentStreak = 1
            }
        }
        
        return maxStreak
    }
    
    var currentStreak: Int {
        journey?.currentStreak ?? 0
    }
    
    var totalFocusTime: String {
        guard let journey = journey else { return "0m" }
        let minutes = journey.totalFocusTimeSeconds / 60
        
        if minutes < 60 {
            return "\(minutes)m"
        } else {
            let hours = minutes / 60
            let remainingMinutes = minutes % 60
            if remainingMinutes > 0 {
                return "\(hours)h \(remainingMinutes)m"
            }
            return "\(hours)h"
        }
    }
    
    var heatmapData: [HeatmapDay] {
        guard let journey = journey else { return [] }
        
        let calendar = Calendar.current
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate]
        
        var days: [HeatmapDay] = []
        
        // Generate all 66 days
        for dayOffset in 0..<66 {
            if let date = calendar.date(byAdding: .day, value: dayOffset, to: journey.startDate) {
                let dateString = String(formatter.string(from: date).prefix(10))
                let isCompleted = journey.completedDays.contains(dateString)
                let isFuture = date > Date()
                let isToday = calendar.isDateInToday(date)
                
                days.append(HeatmapDay(
                    date: date,
                    dayNumber: dayOffset + 1,
                    isCompleted: isCompleted,
                    isFuture: isFuture,
                    isToday: isToday
                ))
            }
        }
        
        return days
    }
    
    func loadData() {
        journey = dataService.getOrCreateJourney()
        primaryHabit = dataService.getPrimaryHabit()
        secondaryHabit = dataService.getSecondaryHabit()
    }
}

struct HeatmapDay: Identifiable {
    let id = UUID()
    let date: Date
    let dayNumber: Int
    let isCompleted: Bool
    let isFuture: Bool
    let isToday: Bool
}
