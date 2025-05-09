//
//  NotificationHelper.swift
//  Firebase-Testflight-CPSC357-Demo
//
//  Created by Luc Rieffel on 5/9/25.
//

import Foundation
import SwiftUI
import UserNotifications


//class NotificationHelper: NSObject, UNUserNotificationCenterDelegate {
//    // Shared instance for global access
//    static let shared = NotificationHelper()
//    
//    override init() {
//        super.init()
//        // Set this class as the delegate to handle notifications
//        UNUserNotificationCenter.current().delegate = self
//    }
//    
//    // Request notification permissions and register for remote notifications
//    func registerForPushNotifications() {
//        UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .alert, .sound]) { granted, error in
//            if let error = error {
//                print("❌ Notification permission error: \(error.localizedDescription)")
//                return
//            }
//            DispatchQueue.main.async {
//                self.setSnoozeActions() // Configure custom snooze actions
//                UIApplication.shared.registerForRemoteNotifications()
//            }
//        }
//    }
//    
//    // Clear all scheduled and delivered notifications
//    func clearData() {
//        let center = UNUserNotificationCenter.current()
//        center.removeAllPendingNotificationRequests()
//        center.removeAllDeliveredNotifications()
//        print("🧼 All notifications cleared")
//        
//        // Remove any custom repeat schedules (like mood check-ins)
//        AppRepeatNotificationTypes.allCases.forEach { $0.removeSchedule() }
//    }
//    
//    // Check current notification authorization status
//    func checkNotificationAuthorizationStatus(completion: @escaping (UNAuthorizationStatus) -> Void) {
//        UNUserNotificationCenter.current().getNotificationSettings { settings in
//            DispatchQueue.main.async {
//                let status = settings.authorizationStatus
//                print("🔔 Notification status: \(status)")
//                completion(status)
//            }
//        }
//    }
//    
//    // Schedule all default repeat notifications (e.g., mood check-ins)
//    func scheduleNotifications() {
//        checkNotificationAuthorizationStatus { status in
//            guard status == .authorized else {
//                print("❌ Notification permissions not granted")
//                return
//            }
//            
//            // Clear existing notifications for testing
//            self.clearData()
//            
//            // Schedule all notification types
//            AppRepeatNotificationTypes.allCases.forEach { type in
//                type.scheduleNotification()
//                print("🔔 Scheduling notification: \(type.rawValue)")
//            }
//            
//            // For testing specific types only, uncomment these lines:
//            // AppRepeatNotificationTypes.moodNoon12.scheduleNotification()
//            // AppRepeatNotificationTypes.moodNoon16.scheduleNotification()
//            
//            // List all pending notifications after scheduling
//            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                self.listPendingNotifications()
//            }
//        }
//    }
//    
//    // Schedule a single notification
//    func scheduleNotification(title: String, body: String,
//                              at dateComponents: DateComponents, repeats: Bool = true,
//                              identifier: String, categoryIdentifier: String,
//                              completion: @escaping (Bool) -> Void) {
//        
//        // 📝 Create notification content
//        let content = UNMutableNotificationContent()
//        content.title = title
//        content.body = body
//        content.sound = .default
//        content.userInfo = [:]
//        content.categoryIdentifier = categoryIdentifier
//        
//        // ⏰ Set up the trigger based on calendar date
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: repeats)
//        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
//        
//        // Add the request to the notification center
//        UNUserNotificationCenter.current().add(request) { error in
//            if let error = error {
//                print("❌ Failed to schedule: \(error.localizedDescription)")
//                completion(false)
//            } else {
//                print("✅ Notification scheduled")
//                completion(true)
//            }
//        }
//    }
//    
//    // Debug function to list all pending notifications
//    func listPendingNotifications() {
//        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
//            guard !requests.isEmpty else {
//                print("📋 No pending notifications found")
//                return
//            }
//            
//            print("📋 Pending Notifications (\(requests.count)):")
//            for request in requests {
//                if let trigger = request.trigger as? UNCalendarNotificationTrigger {
//                    let nextTriggerDate = trigger.nextTriggerDate()?.formatted(date: .complete, time: .complete) ?? "Unknown"
//                    print("   - ID: \(request.identifier)")
//                    print("     Title: \(request.content.title)")
//                    print("     Next trigger: \(nextTriggerDate)")
//                    print("     Repeats: \(trigger.repeats)")
//                } else if let trigger = request.trigger as? UNTimeIntervalNotificationTrigger {
//                    let nextTriggerDate = trigger.nextTriggerDate()?.formatted(date: .complete, time: .complete) ?? "Unknown"
//                    print("   - ID: \(request.identifier)")
//                    print("     Title: \(request.content.title)")
//                    print("     Next trigger: \(nextTriggerDate)")
//                    print("     Repeats: \(trigger.repeats)")
//                }
//            }
//        }
//    }
//}
//
//
//// MARK: - Custom Notification Categories and Snooze Actions
//extension NotificationHelper {
//    func setSnoozeActions() {
//        // Create snooze actions
//        let snooze_10_Minutes = NotificationSnooze.snooze_10_minutes.snoozeAction
//        let snooze_30_Minutes = NotificationSnooze.snooze_30_minutes.snoozeAction
//        let snooze_60_Minutes = NotificationSnooze.snooze_60_minutes.snoozeAction
//        let snooze_24_hours = NotificationSnooze.snooze_24_hours.snoozeAction
//        
//        // Create actions for HealthKit notifications
//        let notifyAllyAction = UNNotificationAction(
//            identifier: "notify_ally_action",
//            title: "🆘 Notify Ally",
//            options: .foreground
//        )
//        
//        let copingActivityAction = UNNotificationAction(
//            identifier: "coping_activity_action",
//            title: "🧘‍♂️ Do Coping Activity",
//            options: .foreground
//        )
//        
//        // Define categories with associated actions
//        let dailyCategory = UNNotificationCategory(identifier: SnoozeCategoryTypes.general.rawValue,
//                                                   actions: [snooze_10_Minutes, snooze_30_Minutes, snooze_60_Minutes],
//                                                   intentIdentifiers: [], options: [])
//        
//        let weeklyCategory = UNNotificationCategory(identifier: SnoozeCategoryTypes.weekly.rawValue,
//                                                    actions: [snooze_10_Minutes, snooze_24_hours],
//                                                    intentIdentifiers: [], options: [])
//        
//        // Add category for health notifications with our custom actions
//        let healthCategory = UNNotificationCategory(
//            identifier: "health_alert_category",
//            actions: [notifyAllyAction, copingActivityAction, snooze_10_Minutes],
//            intentIdentifiers: [],
//            options: []
//        )
//        
//        // Register categories
//        UNUserNotificationCenter.current().setNotificationCategories([dailyCategory, weeklyCategory, healthCategory])
//    }
//}

extension Notification.Name {
    // Used for routing from notifications
    static let navigateToScreen = Notification.Name("navigateToScreen")
    // Used to dismiss all active sheets before navigation
    static let dismissAllSheets = Notification.Name("dismissAllSheets")
}
