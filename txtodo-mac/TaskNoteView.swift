//
//  TaskNoteView.swift
//  txtodo-mac
//
//  Created by FIGBERT on 6/5/20.
//  Copyright © 2020 FIGBERT Industries. All rights reserved.
//

import SwiftUI

struct floatingTaskNote: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @ObservedObject var task: FloatingTask
    @State var notes: [String]
    @State var note: String
    @State var index: Int
    @State private var editing: Bool = false
    @State private var confirmingDelete: Bool = false
    @State private var removed: Bool = false
    var body: some View {
        HStack {
            MainImage(name: "minus")
                .padding(.trailing, 20)
            if removed {
                Text("delete")
                    .bodyText(color: Color(.textColor), alignment: .leading)
            } else if !editing {
                Text(note)
                    .bodyText(color: Color(.textColor), alignment: .leading)
                    .onTapGesture(count: 2) {
                        self.editing = true
                    }
                    .onLongPressGesture {
                        self.confirmingDelete = true
                    }
            } else {
                TextField("edit note", text: $note) {
                    self.editing = false
                    self.managedObjectContext.performAndWait {
                        self.task.notes[self.index] = self.note
                        try? self.managedObjectContext.save()
                    }
                }
                    .editingField(alignment: .leading)
            }
            Spacer()
        }
            .padding(.horizontal, 25)
            .popover(isPresented: $confirmingDelete, content: {
                VStack {
                    Text("confirm delete").bold().padding(.bottom, 4)
                    Text(String(format: NSLocalizedString("\"%@\" deleteWarning", comment: ""), self.note))
                    HStack {
                        Button(action: {
                            self.confirmingDelete = false
                        }, label: {
                            Text("cancel")
                        })
                        Button(action: {
                            self.managedObjectContext.performAndWait {
                                self.task.notes.remove(at: self.index)
                                try? self.managedObjectContext.save()
                            }
                            self.removed = true
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

struct dailyTaskNote: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @ObservedObject var task: DailyTask
    @State var notes: [String]
    @State var note: String
    @State var index: Int
    @State private var editing: Bool = false
    @State private var confirmingDelete: Bool = false
    @State private var removed: Bool = false
    var body: some View {
        HStack {
            MainImage(name: "minus")
                .padding(.trailing, 20)
            if removed {
                Text("delete")
                    .bodyText(color: Color(.textColor), alignment: .leading)
            } else if !editing {
                Text(note)
                    .bodyText(color: Color(.textColor), alignment: .leading)
                    .onTapGesture(count: 2) {
                        self.editing = true
                    }
                    .onLongPressGesture {
                        self.confirmingDelete = true
                    }
            } else {
                TextField("edit note", text: $note) {
                    self.editing = false
                    self.managedObjectContext.performAndWait {
                        self.task.notes[self.index] = self.note
                        try? self.managedObjectContext.save()
                    }
                }
                    .editingField(alignment: .leading)
            }
            Spacer()
        }
            .padding(.horizontal, 25)
            .popover(isPresented: $confirmingDelete, content: {
                VStack {
                    Text("confirm delete").bold().padding(.bottom, 4)
                    Text(String(format: NSLocalizedString("\"%@\" deleteWarning", comment: ""), self.note))
                    HStack {
                        Button(action: {
                            self.confirmingDelete = false
                        }, label: {
                            Text("cancel")
                        })
                        Button(action: {
                            self.managedObjectContext.performAndWait {
                                self.task.notes.remove(at: self.index)
                                try? self.managedObjectContext.save()
                            }
                            self.removed = true
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

struct floatingTaskNotes: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var viewManager: ViewManager
    @ObservedObject var task: FloatingTask
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text(task.name)
                    .underline()
                    .header()
                Spacer()
            }
            ForEach(Array(task.notes.enumerated()), id: \.element) { index, note in
                floatingTaskNote(
                    task: self.task,
                    notes: self.task.notes,
                    note: note,
                    index: index
                )
            }
            addFloatingNote(
                task: task
            )
            Spacer()
            HStack {
                MainImage(name: "chevron.left.square")
                Text("back home")
            }
                .onTapGesture {
                    self.viewManager.viewingFloatingTaskNotes = false
                }
        }
            .padding(.vertical, 25)
    }
}

struct dailyTaskNotes: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var viewManager: ViewManager
    @ObservedObject var task: DailyTask
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text(task.name)
                    .underline()
                    .header()
                Spacer()
            }
            ForEach(Array(task.notes.enumerated()), id: \.element) { index, note in
                dailyTaskNote(
                    task: self.task,
                    notes: self.task.notes,
                    note: note,
                    index: index
                )
            }
            addDailyNote(
                task: task
            )
            Spacer()
            HStack {
                MainImage(name: "chevron.left.square")
                Text("back home")
            }
                .onTapGesture {
                    self.viewManager.viewingDailyTaskNotes = false
                }
        }
            .padding(.vertical, 25)
    }
}
