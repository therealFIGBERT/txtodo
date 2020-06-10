//
//  AddItem.swift
//  txtodo-companion
//
//  Created by FIGBERT on 6/5/20.
//  Copyright © 2020 FIGBERT Industries. All rights reserved.
//

import SwiftUI

struct addTask: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @State private var showingDaily: Bool = true
    @State private var showingFloating: Bool = true
    let lessThanThreeFloatingTasks: Bool
    var body: some View {
        HStack {
            if showingDaily {
                addMainTask(activityBinding: $showingFloating, type: "note")
                    .environment(\.managedObjectContext, self.managedObjectContext)
                    .padding(.trailing, lessThanThreeFloatingTasks && showingFloating ? 25 : 0)
            }
            if showingDaily && lessThanThreeFloatingTasks && showingFloating {
                Spacer()
            }
            if lessThanThreeFloatingTasks && showingFloating {
                addMainTask(activityBinding: $showingDaily, type: "floating")
                    .environment(\.managedObjectContext, self.managedObjectContext)
                    .padding(.leading, showingDaily ? 25 : 0)
            }
        }
    }
}

struct addMainTask: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @State private var addingTask: Bool = false
    @State private var newTaskText: String = ""
    @State private var newTaskPriority: Int = 1
    @Binding var activityBinding: Bool
    let type: String
    var body: some View {
        Group {
            if !addingTask {
                HStack {
                    MainImage(name: "plus.square")
                    Spacer()
                    Text(type == "note" ? "daily" : "floating")
                        .bodyText(color: Color("systemGray2"), alignment: .center)
                    Spacer()
                    MainImage(name: "plus.square")
                }
                    .onTapGesture {
                        self.addingTask = true
                        self.activityBinding = false
                    }
            } else {
                HStack {
                    MainImage(name: "multiply.square")
                        .onTapGesture {
                            self.newTaskText = ""
                            self.newTaskPriority = 1
                            self.addingTask = false
                            self.activityBinding = true
                        }
                    Spacer()
                    TextField("tap", text: $newTaskText) {
                        guard self.newTaskText != "" else {return}
                        if self.type == "note" {
                            let newDailyTask = DailyTask(context: self.managedObjectContext)
                            newDailyTask.completed = false
                            newDailyTask.name = self.newTaskText
                            newDailyTask.priority = Int16(self.newTaskPriority)
                            newDailyTask.notes = [String]()
                            newDailyTask.id = UUID()
                            newDailyTask.creationDate = Date.init()
                        } else {
                            let newFloatingTask = FloatingTask(context: self.managedObjectContext)
                            newFloatingTask.completed = false
                            newFloatingTask.name = self.newTaskText
                            newFloatingTask.priority = Int16(self.newTaskPriority)
                            newFloatingTask.notes = [String]()
                            newFloatingTask.id = UUID()
                            newFloatingTask.completionDate = Date.init()
                        }
                        do {
                            try self.managedObjectContext.save()
                        } catch {
                            print(error.localizedDescription)
                        }
                        self.newTaskText = ""
                        self.newTaskPriority = 1
                        self.addingTask = false
                        self.activityBinding = true
                    }
                        .textFieldStyle(PlainTextFieldStyle())
                        .editingField()
                    Picker(
                        selection: $newTaskPriority,
                        label: Text("task priority"),
                        content: {
                            Text("!").tag(1)
                            Text("!!").tag(2)
                            Text("!!!").tag(3)
                    })
                        .pickerStyle(SegmentedPickerStyle())
                        .labelsHidden()
                    Spacer()
                    MainImage(name: "plus.square")
                        .onTapGesture {
                            guard self.newTaskText != "" else {return}
                            if self.type == "note" {
                                let newDailyTask = DailyTask(context: self.managedObjectContext)
                                newDailyTask.completed = false
                                newDailyTask.name = self.newTaskText
                                newDailyTask.priority = Int16(self.newTaskPriority)
                                newDailyTask.notes = [String]()
                                newDailyTask.id = UUID()
                                newDailyTask.creationDate = Date.init()
                            } else {
                                let newFloatingTask = FloatingTask(context: self.managedObjectContext)
                                newFloatingTask.completed = false
                                newFloatingTask.name = self.newTaskText
                                newFloatingTask.priority = Int16(self.newTaskPriority)
                                newFloatingTask.notes = [String]()
                                newFloatingTask.id = UUID()
                                newFloatingTask.completionDate = Date.init()
                            }
                            do {
                                try self.managedObjectContext.save()
                            } catch {
                                print(error.localizedDescription)
                            }
                            self.newTaskText = ""
                            self.newTaskPriority = 1
                            self.addingTask = false
                            self.activityBinding = true
                        }
                }
            }
        }
    }
}

struct addFloatingNote: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @ObservedObject var task: FloatingTask
    @State private var addingNote: Bool = false
    @State private var newNoteText: String = ""
    var body: some View {
        Group {
            if !addingNote {
                HStack {
                    MainImage(name: "plus.square")
                    Spacer()
                    Text("create a note")
                        .bodyText(color: Color("systemGray2"), alignment: .center)
                    Spacer()
                    MainImage(name: "plus.square")
                }
                    .padding(.horizontal, 25)
                    .onTapGesture {
                        self.addingNote = true
                    }
            } else {
                HStack {
                    MainImage(name: "multiply.square")
                        .onTapGesture {
                            self.newNoteText = ""
                            self.addingNote = false
                        }
                    Spacer()
                    TextField("tap", text: $newNoteText)
                        .textFieldStyle(PlainTextFieldStyle())
                        .editingField()
                    Spacer()
                    MainImage(name: "plus.square")
                        .onTapGesture {
                            guard self.newNoteText != "" else {return}
                            self.managedObjectContext.performAndWait {
                                self.task.notes.append(self.newNoteText)
                                try? self.managedObjectContext.save()
                            }
                            self.newNoteText = ""
                            self.addingNote = false
                        }
                }
                    .padding(.horizontal, 25)
            }
        }
    }
}

struct addDailyNote: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @ObservedObject var task: DailyTask
    @State private var addingNote: Bool = false
    @State private var newNoteText: String = ""
    var body: some View {
        Group {
            if !addingNote {
                HStack {
                    MainImage(name: "plus.square")
                    Spacer()
                    Text("create a note")
                        .bodyText(color: Color("systemGray2"), alignment: .center)
                    Spacer()
                    MainImage(name: "plus.square")
                }
                    .padding(.horizontal, 25)
                    .onTapGesture {
                        self.addingNote = true
                    }
            } else {
                HStack {
                    MainImage(name: "multiply.square")
                        .onTapGesture {
                            self.newNoteText = ""
                            self.addingNote = false
                        }
                    Spacer()
                    TextField("tap", text: $newNoteText)
                        .textFieldStyle(PlainTextFieldStyle())
                        .editingField()
                    Spacer()
                    MainImage(name: "plus.square")
                        .onTapGesture {
                            guard self.newNoteText != "" else {return}
                            self.managedObjectContext.performAndWait {
                                self.task.notes.append(self.newNoteText)
                                try? self.managedObjectContext.save()
                            }
                            self.newNoteText = ""
                            self.addingNote = false
                        }
                }.padding(.horizontal, 25)
            }
        }
    }
}
