//
//  txtodoApp.swift
//  Shared
//
//  Created by FIGBERT on 7/27/20.
//

import SwiftUI
import CoreData
import UserNotifications

@main
struct txtodoApp: App {
    @Environment(\.scenePhase) private var scenePhase
    
    @SceneBuilder var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, self.persistentContainer.viewContext)
        }
            .onChange(of: scenePhase) { phase in
                switch phase {
                case .active:
                    UNUserNotificationCenter.current().removeAllDeliveredNotifications()
                case .inactive:
                    saveContext()
                case .background:
                    saveContext()
                @unknown default:
                    saveContext()
                }
            }
        #if os(macOS)
        Settings {
            SettingsView()
        }
        #endif
    }
    
    var persistentContainer: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "txtodo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
