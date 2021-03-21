//
//  NotificationSection.swift
//  txtodo
//
//  Created by FIGBERT on 8/6/20.
//

import SwiftUI
import UserNotifications

struct NotificationSection: View {
    @AppStorage("notifications") var notificationsEnabled: Bool = false { willSet {
        if !newValue {
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        } else {
            enableNotifications()
        }
    } }
    @AppStorage("notificationID") var notificationID: String = "unset"
    @AppStorage("notificationTime") var notificationTime: Int = 0 { willSet { enableNotifications() } }
    
    var body: some View {
        Section {
            Toggle(isOn: $notificationsEnabled) {
                #if os(iOS)
                    Label(notificationsEnabled ? "notifications enabled" : "notifications disabled", systemImage: "app.badge")
                #else
                    Text("txtodo notifications \(notificationsEnabled ? "enabled" : "disabled")")
                #endif
            }
            if self.notificationsEnabled {
                HStack {
                    Label("time scheduled", systemImage: "clock")
                    Spacer()
                    Picker(
                        selection: $notificationTime,
                        label: Text("notification time"),
                        content: {
                            Text("8:30").tag(0)
                            Text("9:30").tag(1)
                            Text("10:30").tag(2)
                    })
                        .labelsHidden()
                        .pickerStyle(SegmentedPickerStyle())
                }
            }
        }
    }
    
    func enableNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { success, error in
            if success {
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
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}

struct NotificationSection_Previews: PreviewProvider {
    static var previews: some View {
        NotificationSection()
    }
}
