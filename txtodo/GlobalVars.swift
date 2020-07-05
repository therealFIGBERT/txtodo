//
//  GlobalVars.swift
//  txtodo
//
//  Created by FIGBERT on 3/18/20.
//  Copyright © 2020 FIGBERT Industries. All rights reserved.
//

import Foundation
import UserNotifications

class GlobalVars: ObservableObject {
    @Published var notifications: Bool = UserDefaults.standard.bool(forKey: "notifications") {
        willSet {
            if !newValue {
                UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            } else {
                enableNotifications()
            }
            UserDefaults.standard.set(newValue, forKey: "notifications")
        }
    }
    @Published var notificationID: String = UserDefaults.standard.string(forKey: "notificationID") ?? "not yet set" {
        willSet {
            UserDefaults.standard.set(newValue, forKey: "notificationID")
        }
    }
    @Published var notificationTime: Int = UserDefaults.standard.integer(forKey: "notificationHour") {
        willSet {
            UserDefaults.standard.set(newValue, forKey: "notificationHour")
            if notifications {
                enableNotifications()
            }
        }
    }
    func enableNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .sound]
        ) { success, error in
            if success {
                DispatchQueue.main.async {
                    let content = UNMutableNotificationContent()
                    content.title = String(format: NSLocalizedString("open txtodo", comment: ""))
                    content.body = String(format: NSLocalizedString("take some time to plan your day", comment: ""))
                    content.sound = UNNotificationSound.default
                    var time = DateComponents()
                    if self.notificationTime == 0 {
                        time.hour = 8
                    } else if self.notificationTime == 1 {
                        time.hour = 9
                    } else {
                        time.hour = 10
                    }
                    time.minute = 30
                    let trigger = UNCalendarNotificationTrigger(
                        dateMatching: time,
                        repeats: true
                    )
                    let id = UUID().uuidString
                    self.notificationID = id
                    let request = UNNotificationRequest(
                        identifier: id,
                        content: content,
                        trigger: trigger
                    )
                    UNUserNotificationCenter.current().add(request)
                }
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}
