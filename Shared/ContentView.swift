//
//  ContentView.swift
//  Shared
//
//  Created by FIGBERT on 7/27/20.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @StateObject var storeManager: StoreManager
    @FetchRequest(
        entity: Task.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Task.completed, ascending: true),
            NSSortDescriptor(keyPath: \Task.priority, ascending: false),
            NSSortDescriptor(keyPath: \Task.name, ascending: true)
        ],
        predicate: NSPredicate(format: "daily == %d", false)
    ) var floatingTasks: FetchedResults<Task>
    @FetchRequest(
        entity: Task.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Task.completed, ascending: true),
            NSSortDescriptor(keyPath: \Task.priority, ascending: false),
            NSSortDescriptor(keyPath: \Task.name, ascending: true)
        ],
        predicate: NSPredicate(
            format: "daily == %d AND date < %@",
            argumentArray: [
                true,
                Calendar.current.startOfDay(
                    for: Calendar.current.date(
                        byAdding: .day,
                        value: 1,
                        to: Date()
                    )!
                )
            ]
        )
    ) var dailyTasks: FetchedResults<Task>
    let currentDay = Calendar.current.component(.day, from: Date.init())

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            #if os(iOS)
                Color.gray.opacity(0.25)
                    .edgesIgnoringSafeArea(.all)
            #endif
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 10) {
                    HomeHeaderView().padding(.top)
                    if floatingTasks.count > 0 {
                        SectionLabel(text: "floating")
                        ForEach(self.floatingTasks, id: \.id) { task in
                            TaskView(task: task, priority: Int(task.priority))
                                .environment(\.managedObjectContext, self.managedObjectContext)
                                .onAppear(perform: {
                                    if task.completed && Calendar.current.component(.day, from: task.date) < self.currentDay {
                                        self.managedObjectContext.performAndWait {
                                            self.managedObjectContext.delete(task)
                                            try? self.managedObjectContext.save()
                                        }
                                    }
                                })
                        }
                    }
                    if dailyTasks.count > 0 {
                        SectionLabel(text: "daily")
                        ForEach(self.dailyTasks, id: \.id) { task in
                            TaskView(task: task, priority: Int(task.priority))
                                .environment(\.managedObjectContext, self.managedObjectContext)
                                .onAppear(perform: {
                                    if Calendar.current.component(.day, from: task.date) < self.currentDay {
                                        self.managedObjectContext.performAndWait {
                                            self.managedObjectContext.delete(task)
                                            try? self.managedObjectContext.save()
                                        }
                                    }
                                })
                        }
                    }
                    AddTaskController(lessThanThreeFloatingTasks: floatingTasks.count < 3)
                        .environment(\.managedObjectContext, self.managedObjectContext)
                    Spacer()
                }
                .horizontalPaddingOnIOS()
                .animation(.easeIn(duration: 0.15))
            }
            #if os(iOS)
                MenuView(storeManager: storeManager)
            #endif
        }
            .modifier(FrameModifier())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(storeManager: StoreManager())
    }
}
