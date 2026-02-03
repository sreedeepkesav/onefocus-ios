import Foundation
import SwiftUI
import SwiftData

@Observable
final class SettingsViewModel {
    var notificationsEnabled: Bool {
        didSet {
            UserDefaults.standard.set(notificationsEnabled, forKey: "notificationsEnabled")
            if notificationsEnabled {
                NotificationService.shared.requestPermission { granted in
                    if !granted {
                        Task { @MainActor in
                            self.notificationsEnabled = false
                        }
                    }
                }
            } else {
                NotificationService.shared.cancelAllNotifications()
            }
        }
    }
    
    var notificationTime: Date {
        didSet {
            UserDefaults.standard.set(notificationTime, forKey: "notificationTime")
            if notificationsEnabled {
                NotificationService.shared.scheduleDailyReminder(at: notificationTime)
            }
        }
    }
    
    var notificationSound: Bool {
        didSet {
            UserDefaults.standard.set(notificationSound, forKey: "notificationSound")
        }
    }
    
    var badgeEnabled: Bool {
        didSet {
            UserDefaults.standard.set(badgeEnabled, forKey: "badgeEnabled")
        }
    }
    
    var showResetAlert = false
    var showExportSheet = false
    var showDeleteAlert = false
    
    private let dataService = DataService.shared
    
    init() {
        self.notificationsEnabled = UserDefaults.standard.bool(forKey: "notificationsEnabled")
        
        if let savedTime = UserDefaults.standard.object(forKey: "notificationTime") as? Date {
            self.notificationTime = savedTime
        } else {
            // Default to 9:00 AM
            var components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
            components.hour = 9
            components.minute = 0
            self.notificationTime = Calendar.current.date(from: components) ?? Date()
        }
        
        self.notificationSound = UserDefaults.standard.bool(forKey: "notificationSound")
        self.badgeEnabled = UserDefaults.standard.bool(forKey: "badgeEnabled")
    }
    
    func resetJourney() {
        let journey = dataService.getOrCreateJourney()
        journey.startDate = Date()
        journey.completedDays = []
        journey.flexDaysUsed = 0
        journey.totalFocusTimeSeconds = 0
        try? dataService.context.save()
        
        HapticManager.shared.trigger(.success)
    }
    
    func exportData() -> String {
        let journey = dataService.getOrCreateJourney()
        let primaryHabit = dataService.getPrimaryHabit()
        let secondaryHabit = dataService.getSecondaryHabit()
        
        var data = """
        OneFocus Journey Export
        Date: \(Date().formatted())
        
        === JOURNEY ===
        Start Date: \(journey.startDate.formatted())
        Current Day: \(journey.currentDay)
        Completed Days: \(journey.completedDays.count)
        Flex Days Used: \(journey.flexDaysUsed)
        Total Focus Time: \(journey.totalFocusTimeSeconds / 60) minutes
        Current Streak: \(journey.currentStreak)
        
        """
        
        if let habit = primaryHabit {
            data += """
            === PRIMARY HABIT ===
            Name: \(habit.name)
            Type: \(habit.typeLabel)
            Trigger: \(habit.triggerDisplayText)
            
            """
        }
        
        if let habit = secondaryHabit {
            data += """
            === SECONDARY HABIT ===
            Name: \(habit.name)
            Type: \(habit.typeLabel)
            Trigger: \(habit.triggerDisplayText)
            
            """
        }
        
        return data
    }
    
    func deleteAllData() {
        // Delete all habits
        let habitDescriptor = FetchDescriptor<Habit>()
        if let habits = try? dataService.context.fetch(habitDescriptor) {
            habits.forEach { dataService.context.delete($0) }
        }
        
        // Delete all journeys
        let journeyDescriptor = FetchDescriptor<Journey>()
        if let journeys = try? dataService.context.fetch(journeyDescriptor) {
            journeys.forEach { dataService.context.delete($0) }
        }
        
        // Delete all mood entries
        let moodDescriptor = FetchDescriptor<MoodEntry>()
        if let moods = try? dataService.context.fetch(moodDescriptor) {
            moods.forEach { dataService.context.delete($0) }
        }
        
        // Delete all repeating logs
        let logDescriptor = FetchDescriptor<RepeatingLog>()
        if let logs = try? dataService.context.fetch(logDescriptor) {
            logs.forEach { dataService.context.delete($0) }
        }
        
        try? dataService.context.save()
        
        // Reset onboarding
        UserDefaults.standard.set(false, forKey: "hasCompletedOnboarding")
        
        HapticManager.shared.trigger(.success)
    }
}
