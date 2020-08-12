//
//  AddTask.swift
//  txtodo
//
//  Created by FIGBERT on 8/3/20.
//

import SwiftUI

struct AddTaskController: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @State private var config = AddTaskControllerConfig()
    let lessThanThreeFloatingTasks: Bool
    
    var body: some View {
        HStack {
            if config.showingDaily {
                AddTaskView(showingOtherAddTaskView: $config.showingFloating, isAddingDailyTask: true)
                    .environment(\.managedObjectContext, self.managedObjectContext)
            }
            if config.showingDaily && lessThanThreeFloatingTasks && config.showingFloating {
                Spacer()
            }
            if lessThanThreeFloatingTasks && config.showingFloating {
                AddTaskView(showingOtherAddTaskView: $config.showingDaily, isAddingDailyTask: false)
                    .environment(\.managedObjectContext, self.managedObjectContext)
            }
        }
        .horizontalPaddingOnMacOS()
    }
}

struct AddTaskView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @State private var config = AddTaskViewConfig()
    @Binding var showingOtherAddTaskView: Bool
    let isAddingDailyTask: Bool
    
    var body: some View {
        Group {
            if !config.addingTask {
                HStack {
                    Image(systemName: "plus.square")
                    Spacer()
                    Text(isAddingDailyTask ? NSLocalizedString("daily", comment: "") : NSLocalizedString("floating", comment: ""))
                    Spacer()
                    Image(systemName: "plus.square")
                }
                    .onTapGesture {
                        #if os(iOS)
                            let generator = UIImpactFeedbackGenerator(style: .medium)
                            generator.prepare()
                            self.config.addingTask = true
                            self.showingOtherAddTaskView = false
                            generator.impactOccurred()
                        #else
                            self.config.addingTask = true
                            self.showingOtherAddTaskView = false
                        #endif
                    }
            } else {
                HStack {
                    Image(systemName: "multiply.square")
                        .onTapGesture {
                            #if os(iOS)
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                let generator = UIImpactFeedbackGenerator(style: .medium)
                                generator.prepare()
                                config.clear()
                                self.showingOtherAddTaskView = true
                                generator.impactOccurred()
                            #else
                                config.clear()
                                self.showingOtherAddTaskView = true
                            #endif
                        }
                    Spacer()
                    TextField("tap", text: $config.newTaskText) {
                        addTask()
                    }
                        .multilineTextAlignment(.center)
                    Picker(
                        selection: $config.newTaskPriority,
                        label: Text("task priority"),
                        content: {
                            Text("!").tag(1)
                            Text("!!").tag(2)
                            Text("!!!").tag(3)
                    })
                        .pickerStyle(SegmentedPickerStyle())
                        .labelsHidden()
                    Spacer()
                    Image(systemName: "plus.square")
                        .onTapGesture {
                            addTask(forceKeyboardClose: true)
                        }
                }
            }
        }
        .font(.system(size: 18, weight: .light, design: .rounded))
        .foregroundColor(Color.secondary.opacity(0.5))
        .multilineTextAlignment(.center)
    }
    
    func addTask(forceKeyboardClose: Bool = false) {
        #if os(iOS)
            if forceKeyboardClose { UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil) }
        #endif
        guard self.config.newTaskText != "" else {return}
        #if os(iOS)
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.prepare()
        #endif
        let newTask = Task(context: self.managedObjectContext)
        newTask.id = UUID()
        newTask.date = Date()
        newTask.notes = [String]()
        newTask.daily = self.isAddingDailyTask
        newTask.name = self.config.newTaskText
        newTask.priority = Int16(self.config.newTaskPriority)
        try? self.managedObjectContext.save()
        #if os(iOS)
            generator.impactOccurred()
        #endif
        self.config.clear()
        self.showingOtherAddTaskView = true
    }
}

struct AddTaskControllerConfig {
    var showingDaily: Bool = true
    var showingFloating: Bool = true
}

struct AddTaskViewConfig {
    var addingTask: Bool = false
    var newTaskText: String = ""
    var newTaskPriority: Int = 1

    mutating func clear() {
        addingTask = false
        newTaskText = ""
        newTaskPriority = 1
    }
}
