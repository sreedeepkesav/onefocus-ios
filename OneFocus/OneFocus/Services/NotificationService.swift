import Foundation
import UserNotifications
import SwiftUI

@MainActor
final class NotificationService {
    static let shared = NotificationService()
    
    private let center = UNUserNotificationCenter.current()
    
    private init() {}
    
    // MARK: - Permission
    
    func requestPermission(completion: @escaping (Bool) -> Void) {
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error)")
            }
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }
    
    func checkPermission(completion: @escaping (Bool) -> Void) {
        center.getNotificationSettings { settings in
            DispatchQueue.main.async {
                completion(settings.authorizationStatus == .authorized)
            }
        }
    }
    
    // MARK: - Daily Reminders
    
    func scheduleDailyReminder(at time: Date) {
        // Cancel existing daily reminder
        center.removePendingNotificationRequests(withIdentifiers: ["daily_reminder"])
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: time)
        
        let content = UNMutableNotificationContent()
        content.title = "Time for Your Habit"
        content.body = "Your daily habit is waiting for you. Take a moment to complete it."
        content.sound = UserDefaults.standard.bool(forKey: "notificationSound") ? .default : nil
        content.badge = UserDefaults.standard.bool(forKey: "badgeEnabled") ? 1 : nil
        content.categoryIdentifier = "DAILY_REMINDER"
        content.userInfo = ["type": "daily_reminder"]
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: "daily_reminder", content: content, trigger: trigger)
        
        center.add(request) { error in
            if let error = error {
                print("Error scheduling daily reminder: \(error)")
            }
        }
    }
    
    // MARK: - Milestone Notifications
    
    func scheduleMilestoneNotifications(startDate: Date) {
        // Cancel existing milestone notifications
        let milestoneIds = [7, 14, 21, 30, 42, 66].map { "milestone_\($0)" }
        center.removePendingNotificationRequests(withIdentifiers: milestoneIds)
        
        let calendar = Calendar.current
        let milestones: [(day: Int, title: String, body: String)] = [
            (7, "Week 1 Complete! 🎉", "You've completed your first week. You're building momentum!"),
            (14, "2 Weeks Strong! 💪", "You're doing great! Keep the streak going."),
            (21, "21 Days - Foundation Built! 🏗️", "You've completed the foundation phase. The habit is forming!"),
            (30, "30 Days - One Month! 🌟", "Amazing progress! You're halfway through strengthening phase."),
            (42, "6 Weeks Complete! 🚀", "You're in the cementing phase now. Almost automatic!"),
            (66, "Journey Complete! 🎊", "You did it! Your habit is now ingrained. Incredible achievement!")
        ]
        
        for milestone in milestones {
            guard let notificationDate = calendar.date(byAdding: .day, value: milestone.day - 1, to: startDate) else {
                continue
            }
            
            // Schedule for 8 PM on milestone day
            var components = calendar.dateComponents([.year, .month, .day], from: notificationDate)
            components.hour = 20
            components.minute = 0
            
            let content = UNMutableNotificationContent()
            content.title = milestone.title
            content.body = milestone.body
            content.sound = .default
            content.badge = 1
            content.categoryIdentifier = "MILESTONE"
            content.userInfo = ["type": "milestone", "day": milestone.day]
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            let request = UNNotificationRequest(
                identifier: "milestone_\(milestone.day)",
                content: content,
                trigger: trigger
            )
            
            center.add(request) { error in
                if let error = error {
                    print("Error scheduling milestone \(milestone.day): \(error)")
                }
            }
        }
    }
    
    // MARK: - Smart Scheduling (based on trigger type)
    
    func scheduleSmartReminders(for habit: Habit) {
        // Cancel existing smart reminders
        center.removePendingNotificationRequests(withIdentifiers: ["smart_reminder"])
        
        guard UserDefaults.standard.bool(forKey: "notificationsEnabled") else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "Ready for \(habit.name)?"
        content.sound = UserDefaults.standard.bool(forKey: "notificationSound") ? .default : nil
        content.badge = UserDefaults.standard.bool(forKey: "badgeEnabled") ? 1 : nil
        content.categoryIdentifier = "SMART_REMINDER"
        content.userInfo = ["type": "smart_reminder"]
        
        switch habit.triggerType {
        case .anchor:
            // Remind at typical trigger time if set in notification preferences
            if let savedTime = UserDefaults.standard.object(forKey: "notificationTime") as? Date {
                let calendar = Calendar.current
                let components = calendar.dateComponents([.hour, .minute], from: savedTime)
                
                content.body = "Time to \(habit.trigger)? Don't forget your habit!"
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
                let request = UNNotificationRequest(identifier: "smart_reminder", content: content, trigger: trigger)
                
                center.add(request)
            }
            
        case .context:
            // Context-based reminders could use location-based triggers in future
            // For now, use same as anchor
            if let savedTime = UserDefaults.standard.object(forKey: "notificationTime") as? Date {
                let calendar = Calendar.current
                let components = calendar.dateComponents([.hour, .minute], from: savedTime)
                
                content.body = "When you're \(habit.trigger), remember your habit!"
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
                let request = UNNotificationRequest(identifier: "smart_reminder", content: content, trigger: trigger)
                
                center.add(request)
            }
            
        case .throughout:
            // Multiple reminders throughout the day
            content.body = "Time for your habit! Keep the momentum going."
            
            let times = [9, 12, 15, 18] // 9 AM, noon, 3 PM, 6 PM
            for hour in times {
                var components = DateComponents()
                components.hour = hour
                components.minute = 0
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
                let request = UNNotificationRequest(
                    identifier: "smart_reminder_\(hour)",
                    content: content,
                    trigger: trigger
                )
                
                center.add(request)
            }
        }
    }
    
    // MARK: - Cancel Notifications
    
    func cancelAllNotifications() {
        center.removeAllPendingNotificationRequests()
        center.removeAllDeliveredNotifications()
        UNUserNotificationCenter.current().setBadgeCount(0)
    }
    
    func cancelDailyReminder() {
        center.removePendingNotificationRequests(withIdentifiers: ["daily_reminder"])
    }
    
    // MARK: - Badge Management
    
    func updateBadge(count: Int) {
        if UserDefaults.standard.bool(forKey: "badgeEnabled") {
            UNUserNotificationCenter.current().setBadgeCount(count)
        }
    }
    
    func clearBadge() {
        UNUserNotificationCenter.current().setBadgeCount(0)
    }
}
