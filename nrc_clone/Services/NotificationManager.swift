//
//  NotificationManager.swift
//  nrc_clone
//
//  Created by Kenneth Sieu on 4/14/26.
//

import Foundation
import UserNotifications

@Observable
class NotificationManager: NSObject {
    var isAuthorized = false
    var pendingRoute: String? = nil
    
    override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
    
    func requestPermission() async {
        let center = UNUserNotificationCenter.current()
        do {
            let granted = try await center.requestAuthorization(options: [.alert, .sound, .badge])
            await MainActor.run { isAuthorized = granted }
        } catch {
            print("Notification permission error: \(error)")
        }
    }
    
    func checkPermission() async {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        await MainActor.run {
            isAuthorized = settings.authorizationStatus == .authorized
        }
    }
    
    func schedulePostRunNotification(distance: Double, duration: Double) {
        guard isAuthorized else { return }

        let content = UNMutableNotificationContent()
        content.title = "Run Complete 🎉"
        content.body = "You ran \(RunFormatter.distance(distance)) miles in \(RunFormatter.duration(duration)). Great work!"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func scheduleWeeklyNotifications(){
        guard isAuthorized else { return }

        let content = UNMutableNotificationContent()
        content.title = "Weekly Summary 📊"
        content.body = "Check out how your week went!"
        content.sound = .default
        content.userInfo = ["route" : "activity"]
        
        var dateComponents = DateComponents()
        dateComponents.weekday = 1
        dateComponents.hour = 9
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "weeklyNotification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        let userInfo = response.notification.request.content.userInfo
        if let route = userInfo["route"] as? String {
            await MainActor.run { pendingRoute = route }
        }
    }
    
}

extension NotificationManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        return [.banner, .sound]
    }
}
