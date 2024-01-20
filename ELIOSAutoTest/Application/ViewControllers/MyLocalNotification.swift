//
//  MyLocalNotification.swift
//  ELIOSAutoTest
//
//  Created by jack on 20.01.2024.
//

import Foundation
import UserNotifications
class MyLocalNotification {
    
    func createNotification() -> UNNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = "Weekly Staff Meeting"
        content.body = "Every Tuesday at 2pm"
        content.sound = UNNotificationSound.default
        return content
    }
    
    func stopNotifications() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["identifier"])
    }
    
     func readNotifications() async {
        var notif = await UNUserNotificationCenter.current().pendingNotificationRequests()
        print(notif)
    }
    func conditions() -> UNNotificationTrigger {
        // Configure the recurring date.
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current

//        dateComponents
//        dateComponents.weekday = 7
//        dateComponents.hour = 1    // 14:00 hours
        dateComponents.minute = 30
        // Create the trigger as a repeating event.
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        return trigger
    }
    
    func send() {
        var content = createNotification()
        var trigger = conditions()
        
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString,
                    content: content, trigger: trigger)


        // Schedule the request with the system.
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request) { (error) in
           if error != nil {
               print(error)
              // Handle any errors.
           }
        }
    }
}
