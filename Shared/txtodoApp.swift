//
//  txtodoApp.swift
//  Shared
//
//  Created by FIGBERT on 7/27/20.
//

import SwiftUI
import CoreData
import StoreKit
import UserNotifications

@main
struct txtodoApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject var storeManager = StoreManager()
    
    let productIDs = [
        "com.figbertind.txtodo.five_usd_tip",
        "com.figbertind.txtodo.ten_usd_tip",
        "com.figbertind.txtodo.fifteen_usd_tip"
    ]
    
    @SceneBuilder var body: some Scene {
        #if os(iOS)
        WindowGroup {
            ContentView(storeManager: storeManager)
                .environment(\.managedObjectContext, self.persistentContainer.viewContext)
                .onAppear(perform: {
                    SKPaymentQueue.default().add(storeManager)
                    storeManager.getProducts(productIDs: productIDs)
                })
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
        #elseif os(macOS)
        WindowGroup {
            ContentView(storeManager: storeManager)
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
        Settings {
            SettingsView(storeManager: storeManager)
                .onAppear(perform: {
                    SKPaymentQueue.default().add(storeManager)
                    storeManager.getProducts(productIDs: productIDs)
                })
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
