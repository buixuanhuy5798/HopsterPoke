//
//  NotificationService.swift
//  HopsterPoke
//
//  Created by Huy Bùi Xuân on 13/5/24.
//

import UserNotifications

class NotificationService {
    static let shared = NotificationService()
    
    func registerLocal() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                self.scheduleLocal()
            } else {
                print("REQUEST NOTI FAIL: \(error?.localizedDescription)")
            }
        }
    }
    
    func scheduleLocal() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        let content = UNMutableNotificationContent()
        content.title = "Visit Hopster Poke"
        content.body = "Check in to get free carrots"
        content.categoryIdentifier = "daily"
        var dateComponent = DateComponents()
        dateComponent.hour = 11
        dateComponent.minute = 00
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: true)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
    func turnOfNoti() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
    }
}
