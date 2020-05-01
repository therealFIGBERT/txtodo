//
//  AddItem.swift
//  txtodo
//
//  Created by FIGBERT on 2/28/20.
//  Copyright © 2020 FIGBERT Industries. All rights reserved.
//

import Foundation
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
                Button(action: {
                    self.addingTask = true
                    self.activityBinding = false
                }) {
                    HStack {
                        MainImage(name: "plus.square", color: .systemGray3)
                        Spacer()
                        Text(type == "note" ? "daily" : "floating")
                            .bodyText(color: .systemGray3, alignment: .center)
                        Spacer()
                        MainImage(name: "plus.square", color: .systemGray3)
                    }
                }
            } else {
                HStack {
                    Button(action: {
                        self.newTaskText = ""
                        self.newTaskPriority = 1
                        self.addingTask = false
                        self.activityBinding = true
                    }) {
                        MainImage(name: "multiply.square", color: .systemGray3)
                    }
                    Spacer()
                    TextField("tap", text: $newTaskText)
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
                    Spacer()
                    Button(action: {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
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
                            newFloatingTask.markedForDeletion = false
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
                    }) {
                        MainImage(name: "plus.square", color: .systemGray3)
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
                Button(action: {
                    self.addingNote = true
                }) {
                    HStack {
                        MainImage(name: "plus.square", color: .systemGray3)
                        Spacer()
                        Text("create a note")
                            .bodyText(color: .systemGray3, alignment: .center)
                        Spacer()
                        MainImage(name: "plus.square", color: .systemGray3)
                    }
                        .padding(.horizontal, 25)
                }
            } else {
                HStack {
                    Button(action: {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        self.newNoteText = ""
                        self.addingNote = false
                    }) {
                        MainImage(name: "multiply.square", color: .systemGray3)
                    }
                    Spacer()
                    TextField("tap", text: $newNoteText)
                        .editingField()
                    Spacer()
                    Button(action: {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        guard self.newNoteText != "" else {return}
                        self.managedObjectContext.performAndWait {
                            self.task.notes.append(self.newNoteText)
                            try? self.managedObjectContext.save()
                        }
                        self.newNoteText = ""
                        self.addingNote = false
                    }) {
                        MainImage(name: "plus.square", color: .systemGray3)
                    }
                }.padding(.horizontal, 25)
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
                Button(action: {
                    self.addingNote = true
                }) {
                    HStack {
                        MainImage(name: "plus.square", color: .systemGray3)
                        Spacer()
                        Text("create a note")
                            .bodyText(color: .systemGray3, alignment: .center)
                        Spacer()
                        MainImage(name: "plus.square", color: .systemGray3)
                    }
                        .padding(.horizontal, 25)
                }
            } else {
                HStack {
                    Button(action: {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        self.newNoteText = ""
                        self.addingNote = false
                    }) {
                        MainImage(name: "multiply.square", color: .systemGray3)
                    }
                    Spacer()
                    TextField("tap", text: $newNoteText)
                        .editingField()
                    Spacer()
                    Button(action: {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        guard self.newNoteText != "" else {return}
                        self.managedObjectContext.performAndWait {
                            self.task.notes.append(self.newNoteText)
                            try? self.managedObjectContext.save()
                        }
                        self.newNoteText = ""
                        self.addingNote = false
                    }) {
                        MainImage(name: "plus.square", color: .systemGray3)
                    }
                }.padding(.horizontal, 25)
            }
        }
    }
}
