//
//  TaskView.swift
//  txtodo
//
//  Created by FIGBERT on 2/28/20.
//  Copyright © 2020 FIGBERT Industries. All rights reserved.
//

import Foundation
import SwiftUI

struct floatingTaskView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @ObservedObject var task: FloatingTask
    @State var completed: Bool
    @State var name: String
    @State var priority: Int
    @State var deleted: Bool = false
    @State private var editingText: Bool = false
    @State private var editingPriority: Bool = false
    @State private var viewingNotes: Bool = false
    @State private var confirmingDelete: Bool = false
    var body: some View {
        let priorityIntermediary = Binding<Int>(
            get: { self.priority },
            set: { value in
                self.priority = value
                self.managedObjectContext.performAndWait {
                    self.task.priority = Int16(value)
                    try? self.managedObjectContext.save()
                }
                self.editingPriority = false
            }
        )
        return HStack {
            if !deleted {
                if task.completed {
                    MainImage(name: "checkmark.square", color: .systemGray)
                        .onTapGesture {
                            let generator = UIImpactFeedbackGenerator(style: .medium)
                            generator.prepare()
                            self.completed.toggle()
                            self.managedObjectContext.performAndWait {
                                self.task.completed = self.completed
                                if self.completed {
                                    self.task.completionDate = Date.init()
                                }
                                try? self.managedObjectContext.save()
                            }
                            generator.impactOccurred()
                        }
                } else {
                    MainImage(name: "square", color: .label)
                        .onTapGesture {
                            let generator = UIImpactFeedbackGenerator(style: .medium)
                            generator.prepare()
                            self.completed.toggle()
                            self.managedObjectContext.performAndWait {
                                self.task.completed = self.completed
                                if self.completed {
                                    self.task.completionDate = Date.init()
                                }
                                try? self.managedObjectContext.save()
                            }
                            generator.impactOccurred()
                        }
                }
            } else {
                MainImage(name: "square", color: .label)
            }
            Spacer()
            if deleted {
                Text("delete")
                    .bodyText()
            } else if !editingText {
                Text(task.name)
                    .strikethrough(completed)
                    .bodyText(color: completed ? .systemGray : .label, alignment: .center)
                    .onTapGesture(count: 2) {
                        if !self.completed {
                            self.editingText = true
                        }
                    }
                    .onLongPressGesture {
                        self.confirmingDelete = true
                    }
                    .onTapGesture(count: 1) {
                        self.viewingNotes = true
                    }
                    .sheet(isPresented: $viewingNotes, content: {
                        floatingTaskNotes(task: self.task)
                            .environment(\.managedObjectContext, self.managedObjectContext)
                    })
            } else {
                TextField("edit task", text: $name) {
                    self.editingText = false
                    self.managedObjectContext.performAndWait {
                        self.task.name = self.name
                        try? self.managedObjectContext.save()
                    }
                }
                    .editingField()
            }
            Spacer()
            if deleted {
                Text("     ")
                    .font(.system(size: 10, weight: .light))
            } else if !editingPriority {
                if Int(task.priority) == 1 {
                    Text("  !  ")
                        .font(.system(size: 10, weight: .light))
                        .foregroundColor(Color.init(completed ? UIColor.systemGray : UIColor.label))
                        .onTapGesture(count: 2) {
                            if !self.completed {
                                self.editingPriority = true
                            }
                        }
                } else if Int(task.priority) == 2 {
                    Text(" ! ! ")
                        .font(.system(size: 10, weight: .light))
                        .foregroundColor(Color.init(completed ? UIColor.systemGray : UIColor.label))
                        .onTapGesture(count: 2) {
                            if !self.completed {
                                self.editingPriority = true
                            }
                        }
                } else {
                    Text("! ! !")
                        .font(.system(size: 10, weight: .light))
                        .foregroundColor(Color.init(completed ? UIColor.systemGray : UIColor.label))
                        .onTapGesture(count: 2) {
                            if !self.completed {
                                self.editingPriority = true
                            }
                        }
                }
            } else {
                Picker(
                    selection: priorityIntermediary,
                    label: Text("task priority"),
                    content: {
                        Text("!").tag(1)
                        Text("!!").tag(2)
                        Text("!!!").tag(3)
                })
                    .pickerStyle(SegmentedPickerStyle())
            }
        }
            .alert(isPresented: $confirmingDelete) {
                Alert(
                    title: Text("confirm delete"),
                    message: Text(String(format: NSLocalizedString("\"%@\" deleteWarning", comment: ""), name)),
                    primaryButton: .destructive(Text("delete")) {
                        self.managedObjectContext.performAndWait {
                            self.managedObjectContext.delete(self.task)
                            try? self.managedObjectContext.save()
                        }
                    },
                    secondaryButton: .cancel(Text("cancel"))
                )
            }
    }
}

struct dailyTaskView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @ObservedObject var task: DailyTask
    @State var completed: Bool
    @State var name: String
    @State var priority: Int
    @State var deleted: Bool = false
    @State private var editingText: Bool = false
    @State private var editingPriority: Bool = false
    @State private var viewingNotes: Bool = false
    @State private var confirmingDelete: Bool = false
    var body: some View {
        let priorityIntermediary = Binding<Int>(
            get: { self.priority },
            set: { value in
                self.priority = value
                self.managedObjectContext.performAndWait {
                    self.task.priority = Int16(value)
                    try? self.managedObjectContext.save()
                }
                self.editingPriority = false
            }
        )
        return HStack {
            if !deleted {
                if task.completed {
                    MainImage(name: "checkmark.square", color: .systemGray)
                        .onTapGesture {
                            let generator = UIImpactFeedbackGenerator(style: .medium)
                            generator.prepare()
                            self.completed.toggle()
                            self.managedObjectContext.performAndWait {
                                self.task.completed = self.completed
                                try? self.managedObjectContext.save()
                            }
                            generator.impactOccurred()
                        }
                } else {
                    MainImage(name: "square", color: .label)
                        .onTapGesture {
                            let generator = UIImpactFeedbackGenerator(style: .medium)
                            generator.prepare()
                            self.completed.toggle()
                            self.managedObjectContext.performAndWait {
                                self.task.completed = self.completed
                                try? self.managedObjectContext.save()
                            }
                            generator.impactOccurred()
                        }
                }
            } else {
                MainImage(name: "square", color: .label)
            }
            Spacer()
            if deleted {
                Text("delete")
                    .bodyText()
            } else if !editingText {
                Text(task.name)
                    .strikethrough(completed)
                    .bodyText(color: completed ? .systemGray : .label, alignment: .center)
                    .onTapGesture(count: 2) {
                        if !self.completed {
                            self.editingText = true
                        }
                    }
                    .onLongPressGesture {
                        self.confirmingDelete = true
                    }
                    .onTapGesture(count: 1) {
                        self.viewingNotes = true
                    }
                    .sheet(isPresented: $viewingNotes, content: {
                        dailyTaskNotes(task: self.task).environment(\.managedObjectContext, self.managedObjectContext)
                    })
            } else {
                TextField("edit task", text: $name) {
                    self.editingText = false
                    self.managedObjectContext.performAndWait {
                        self.task.name = self.name
                        try? self.managedObjectContext.save()
                    }
                }
                    .editingField()
            }
            Spacer()
            if deleted {
                Text("     ")
                    .font(.system(size: 10, weight: .light))
            } else if !editingPriority {
                if Int(task.priority) == 1 {
                    Text("  !  ")
                        .font(.system(size: 10, weight: .light))
                        .foregroundColor(Color.init(completed ? UIColor.systemGray : UIColor.label))
                        .onTapGesture(count: 2) {
                            if !self.completed {
                                self.editingPriority = true
                            }
                        }
                } else if Int(task.priority) == 2 {
                    Text(" ! ! ")
                        .font(.system(size: 10, weight: .light))
                        .foregroundColor(Color.init(completed ? UIColor.systemGray : UIColor.label))
                        .onTapGesture(count: 2) {
                            if !self.completed {
                                self.editingPriority = true
                            }
                        }
                } else {
                    Text("! ! !")
                        .font(.system(size: 10, weight: .light))
                        .foregroundColor(Color.init(completed ? UIColor.systemGray : UIColor.label))
                        .onTapGesture(count: 2) {
                            if !self.completed {
                                self.editingPriority = true
                            }
                        }
                }
            } else {
                Picker(
                    selection: priorityIntermediary,
                    label: Text("task priority"),
                    content: {
                        Text("!").tag(1)
                        Text("!!").tag(2)
                        Text("!!!").tag(3)
                })
                    .pickerStyle(SegmentedPickerStyle())
            }
        }
            .alert(isPresented: $confirmingDelete) {
                Alert(
                    title: Text("confirm delete"),
                    message: Text(String(format: NSLocalizedString("\"%@\" deleteWarning", comment: ""), name)),
                    primaryButton: .destructive(Text("delete")) {
                        self.managedObjectContext.performAndWait {
                            self.managedObjectContext.delete(self.task)
                            try? self.managedObjectContext.save()
                        }
                    },
                    secondaryButton: .cancel(Text("cancel"))
                )
            }
    }
}
