//
//  HomeScreen.swift
//  txtodo
//
//  Created by FIGBERT on 3/17/20.
//  Copyright © 2020 FIGBERT Industries. All rights reserved.
//

import SwiftUI

struct HomeScreen: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var globalVars: GlobalVars
    @FetchRequest(
        entity: FloatingTask.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \FloatingTask.completed, ascending: true),
            NSSortDescriptor(keyPath: \FloatingTask.priority, ascending: false),
            NSSortDescriptor(keyPath: \FloatingTask.name, ascending: true)
        ]
    ) var floatingTasks: FetchedResults<FloatingTask>
    @FetchRequest(
        entity: DailyTask.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \DailyTask.completed, ascending: true),
            NSSortDescriptor(keyPath: \DailyTask.priority, ascending: false),
            NSSortDescriptor(keyPath: \DailyTask.name, ascending: true)
        ]
    ) var dailyTasks: FetchedResults<DailyTask>
    let currentDay = Calendar.current.component(.day, from: Date.init())
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Color.init(UIColor.systemGray6)
                .edgesIgnoringSafeArea(.all)
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    Header(text: "txtodo", underline: true)
                    if self.floatingTasks.count > 0 {
                        SectionLabel(text: "floating")
                    }
                    ForEach(self.floatingTasks, id: \.id) { task in
                        floatingTaskView(
                            task: task,
                            completed: task.completed,
                            name: task.name,
                            priority: Int(task.priority)
                        )
                            .environment(\.managedObjectContext, self.managedObjectContext)
                            .onAppear(perform: {
                                if task.markedForDeletion && !(Calendar.current.component(.day, from: task.completionDate) == self.currentDay) {
                                    self.managedObjectContext.performAndWait {
                                        self.managedObjectContext.delete(task)
                                        try? self.managedObjectContext.save()
                                    }
                                }
                            })
                    }
                    if self.dailyTasks.count > 0 {
                        SectionLabel(text: "daily")
                    }
                    ForEach(self.dailyTasks, id: \.id) { task in
                        dailyTaskView(
                            task: task,
                            completed: task.completed,
                            name: task.name,
                            priority: Int(task.priority),
                            deleted: Calendar.current.component(.day, from: task.creationDate) == self.currentDay ? false : true
                        )
                            .environment(\.managedObjectContext, self.managedObjectContext)
                            .onAppear(perform: {
                                if !(Calendar.current.component(.day, from: task.creationDate) == self.currentDay) {
                                    self.managedObjectContext.performAndWait {
                                        self.managedObjectContext.delete(task)
                                        try? self.managedObjectContext.save()
                                    }
                                }
                            })
                    }
                    addTask(lessThanThreeFloatingTasks: floatingTasks.count < 3)
                        .environment(\.managedObjectContext, self.managedObjectContext)
                }
                    .padding(.top, 45)
                    .padding(.bottom, 90)
                    .padding(.horizontal, 25)
                Spacer()
            }
                .modifier(AdaptsToSoftwareKeyboard())
            Menu()
                .padding(25)
        }
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
