//
//  TaskNoteViews.swift
//  txtodo
//
//  Created by FIGBERT on 2/28/20.
//  Copyright © 2020 FIGBERT Industries. All rights reserved.
//

import Foundation
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
            MainImage(name: "minus", color: .label)
                .padding(.trailing, 20)
            if removed {
                Text("delete")
                    .bodyText(color: .label, alignment: .leading)
            } else if !editing {
                Text(note)
                    .bodyText(color: .label, alignment: .leading)
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
            .alert(isPresented: $confirmingDelete) {
                Alert(
                    title: Text("confirm delete"),
                    message: Text(String(format: NSLocalizedString("\"%@\" deleteWarning", comment: ""), note)),
                    primaryButton: .destructive(Text("delete")) {
                        self.managedObjectContext.performAndWait {
                            self.task.notes.remove(at: self.index)
                            try? self.managedObjectContext.save()
                        }
                        self.removed = true
                    },
                    secondaryButton: .cancel(Text("cancel"))
                )
            }
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
            MainImage(name: "minus", color: .label)
                .padding(.trailing, 20)
            if removed {
                Text("delete")
                    .bodyText(color: .label, alignment: .leading)
            } else if !editing {
                Text(note)
                    .bodyText(color: .label, alignment: .leading)
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
            .alert(isPresented: $confirmingDelete) {
                Alert(
                    title: Text("confirm delete"),
                    message: Text(String(format: NSLocalizedString("\"%@\" deleteWarning", comment: ""), note)),
                    primaryButton: .destructive(Text("delete")) {
                        self.managedObjectContext.performAndWait {
                            self.task.notes.remove(at: self.index)
                            try? self.managedObjectContext.save()
                        }
                        self.removed = true
                    },
                    secondaryButton: .cancel(Text("cancel"))
                )
            }
    }
}

struct floatingTaskNotes: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @ObservedObject var task: FloatingTask
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                Text(task.name)
                    .underline()
                    .header()
                    .padding(.horizontal)
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
            }
                .padding(.top, 25)
        }
        .background(Color.init(UIColor.systemGray6).edgesIgnoringSafeArea(.all))
    }
}

struct dailyTaskNotes: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @ObservedObject var task: DailyTask
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                Text(task.name)
                    .underline()
                    .header()
                    .padding(.horizontal)
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
            }
                .padding(.top, 25)
        }
        .background(Color.init(UIColor.systemGray6).edgesIgnoringSafeArea(.all))
    }
}
