//
//  TaskView.swift
//  txtodo-mac
//
//  Created by FIGBERT on 6/5/20.
//  Copyright © 2020 FIGBERT Industries. All rights reserved.
//

import SwiftUI

struct floatingTaskView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var viewManager: ViewManager
    @ObservedObject var task: FloatingTask
    @State var completed: Bool
    @State var name: String
    @State var priority: Int
    @State var deleted: Bool = false
    @State private var editingText: Bool = false
    @State private var editingPriority: Bool = false
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
                    MainImage(name: "checkmark.square")
                        .onTapGesture {
                            self.completed.toggle()
                            self.managedObjectContext.performAndWait {
                                self.task.completed = self.completed
                                if self.completed {
                                    self.task.completionDate = Date.init()
                                }
                                try? self.managedObjectContext.save()
                            }
                        }
                } else {
                    MainImage(name: "square")
                        .onTapGesture {
                            self.completed.toggle()
                            self.managedObjectContext.performAndWait {
                                self.task.completed = self.completed
                                if self.completed {
                                    self.task.completionDate = Date.init()
                                }
                                try? self.managedObjectContext.save()
                            }
                        }
                }
            } else {
                MainImage(name: "square")
            }
            Spacer()
            if deleted {
                Text("delete")
                    .bodyText()
            } else if !editingText {
                Text(task.name)
                    .strikethrough(completed)
                    .bodyText(color: completed ? Color(.systemGray) : Color(.textColor), alignment: .center)
                    .onTapGesture(count: 2) {
                        if !self.completed {
                            self.editingText = true
                        }
                    }
                    .onLongPressGesture {
                        self.confirmingDelete = true
                    }
                    .onTapGesture(count: 1) {
                        self.viewManager.floatingTask = self.task
                        self.viewManager.viewingFloatingTaskNotes = true
                    }
            } else {
                TextField("edit task", text: $name) {
                    self.editingText = false
                    self.managedObjectContext.performAndWait {
                        self.task.name = self.name
                        try? self.managedObjectContext.save()
                    }
                }
                    .textFieldStyle(PlainTextFieldStyle())
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
                        .foregroundColor(Color.init(completed ? .systemGray : .textColor))
                        .onTapGesture(count: 2) {
                            if !self.completed {
                                self.editingPriority = true
                            }
                        }
                } else if Int(task.priority) == 2 {
                    Text(" ! ! ")
                        .font(.system(size: 10, weight: .light))
                        .foregroundColor(Color.init(completed ? .systemGray : .textColor))
                        .onTapGesture(count: 2) {
                            if !self.completed {
                                self.editingPriority = true
                            }
                        }
                } else {
                    Text("! ! !")
                        .font(.system(size: 10, weight: .light))
                        .foregroundColor(Color.init(completed ? .systemGray : .textColor))
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
                    .labelsHidden()
            }
        }
            .popover(isPresented: $confirmingDelete, content: {
                VStack {
                    Text("confirm delete").bold().padding(.bottom, 4)
                    Text(String(format: NSLocalizedString("\"%@\" deleteWarning", comment: ""), self.name))
                    HStack {
                        Button(action: {
                            self.confirmingDelete = false
                        }, label: {
                            Text("cancel")
                        })
                        Button(action: {
                            self.managedObjectContext.performAndWait {
                                self.managedObjectContext.delete(self.task)
                                try? self.managedObjectContext.save()
                            }
                        }, label: {
                            Text("delete")
                        })
                            .buttonStyle(PlainButtonStyle())
                            .padding(.horizontal, 10)
                            .padding(.vertical, 1.5)
                            .background(Color(.red))
                            .cornerRadius(3)
                    }
                }
                    .padding()
            })
    }
}

struct dailyTaskView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var viewManager: ViewManager
    @ObservedObject var task: DailyTask
    @State var completed: Bool
    @State var name: String
    @State var priority: Int
    @State var deleted: Bool = false
    @State private var editingText: Bool = false
    @State private var editingPriority: Bool = false
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
                    MainImage(name: "checkmark.square")
                        .onTapGesture {
                            self.completed.toggle()
                            self.managedObjectContext.performAndWait {
                                self.task.completed = self.completed
                                try? self.managedObjectContext.save()
                            }
                        }
                } else {
                    MainImage(name: "square")
                        .onTapGesture {
                            self.completed.toggle()
                            self.managedObjectContext.performAndWait {
                                self.task.completed = self.completed
                                try? self.managedObjectContext.save()
                            }
                        }
                }
            } else {
                MainImage(name: "square")
            }
            Spacer()
            if deleted {
                Text("delete")
                    .bodyText()
            } else if !editingText {
                Text(task.name)
                    .strikethrough(completed)
                    .bodyText(color: completed ? Color(.systemGray) : Color(.textColor), alignment: .center)
                    .onTapGesture(count: 2) {
                        if !self.completed {
                            self.editingText = true
                        }
                    }
                    .onLongPressGesture {
                        self.confirmingDelete = true
                    }
                    .onTapGesture(count: 1) {
                        self.viewManager.dailyTask = self.task
                        self.viewManager.viewingDailyTaskNotes = true
                    }
            } else {
                TextField("edit task", text: $name) {
                    self.editingText = false
                    self.managedObjectContext.performAndWait {
                        self.task.name = self.name
                        try? self.managedObjectContext.save()
                    }
                }
                    .textFieldStyle(PlainTextFieldStyle())
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
                        .foregroundColor(Color.init(completed ? .systemGray : .textColor))
                        .onTapGesture(count: 2) {
                            if !self.completed {
                                self.editingPriority = true
                            }
                        }
                } else if Int(task.priority) == 2 {
                    Text(" ! ! ")
                        .font(.system(size: 10, weight: .light))
                        .foregroundColor(Color.init(completed ? .systemGray : .textColor))
                        .onTapGesture(count: 2) {
                            if !self.completed {
                                self.editingPriority = true
                            }
                        }
                } else {
                    Text("! ! !")
                        .font(.system(size: 10, weight: .light))
                        .foregroundColor(Color.init(completed ? .systemGray : .textColor))
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
                    .labelsHidden()
            }
        }
            .popover(isPresented: $confirmingDelete, content: {
                VStack {
                    Text("confirm delete").bold().padding(.bottom, 4)
                    Text(String(format: NSLocalizedString("\"%@\" deleteWarning", comment: ""), self.name))
                    HStack {
                        Button(action: {
                            self.confirmingDelete = false
                        }, label: {
                            Text("cancel")
                        })
                        Button(action: {
                            self.managedObjectContext.performAndWait {
                                self.managedObjectContext.delete(self.task)
                                try? self.managedObjectContext.save()
                            }
                        }, label: {
                            Text("delete")
                        })
                            .buttonStyle(PlainButtonStyle())
                            .padding(.horizontal, 10)
                            .padding(.vertical, 1.5)
                            .background(Color(.red))
                            .cornerRadius(3)
                    }
                }
                    .padding()
            })
    }
}
