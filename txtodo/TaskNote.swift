//
//  TaskNote.swift
//  txtodo
//
//  Created by FIGBERT on 2/28/20.
//  Copyright © 2020 FIGBERT Industries. All rights reserved.
//

import Foundation
import SwiftUI

struct dailyTaskNote: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @ObservedObject var task: NoteTask
    @State var notes: [String]
    @State var note: String
    @State var index: Int
    @State var editing: Bool = false
    @State var confirmingDelete: Bool = false
    @State var removed: Bool = false
    var body: some View {
        HStack {
            Image(systemName: "minus")
                .font(.system(size: 20, weight: .light))
                .foregroundColor(Color.init(UIColor.label))
                .padding(.trailing, 20)
            if removed {
                Text("error")
                    .font(.system(size: 20, weight: .light))
            } else if !editing {
                Text(note)
                    .font(.system(size: 20, weight: .light))
                    .onTapGesture(count: 2) {
                        self.editing = true
                    }
                    .onLongPressGesture {
                        self.confirmingDelete = true
                    }
            } else {
                TextField("editing note", text: $note) {
                    self.editing = false
                    self.managedObjectContext.performAndWait {
                        self.task.notes[self.index] = self.note
                        try? self.managedObjectContext.save()
                    }
                }
                    .font(.system(size: 20, weight: .light))
                    .foregroundColor(Color.init(UIColor.systemGray))
                    .autocapitalization(.none)
            }
            Spacer()
        }
            .padding(.horizontal, 25)
            .alert(isPresented: $confirmingDelete) {
                Alert(
                    title: Text("confirm delete"),
                    message: Text("the note will be gone forever, with no option to restore"),
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

struct subTaskNote: View {
    @EnvironmentObject var globalVars: GlobalVars
    @State var editing: Bool = false
    @State var confirmingDelete: Bool = false
    @State var removed: Bool = false
    let superIndex: Int
    let subIndex: Int
    let noteIndex: Int
    var body: some View {
        HStack {
            Image(systemName: "minus")
                .font(.system(size: 20, weight: .light))
                .foregroundColor(Color.init(UIColor.label))
                .padding(.trailing, 20)
            if removed {
                Text("error")
                    .font(.system(size: 20, weight: .light))
            } else if !editing {
                Text(self.globalVars.floatingTasks[superIndex].subTasks[subIndex].notes[noteIndex])
                    .font(.system(size: 20, weight: .light))
                    .onTapGesture(count: 2) {
                        self.editing = true
                    }
                    .onLongPressGesture {
                        self.confirmingDelete = true
                    }
            } else {
                TextField("editing note", text: $globalVars.floatingTasks[superIndex].subTasks[subIndex].notes[noteIndex]) {
                    self.editing = false
                }
                    .font(.system(size: 20, weight: .light))
                    .foregroundColor(Color.init(UIColor.systemGray))
                    .autocapitalization(.none)
            }
            Spacer()
        }
            .padding(.horizontal, 25)
            .alert(isPresented: $confirmingDelete) {
                Alert(
                    title: Text("confirm delete"),
                    message: Text("the note will be gone forever, with no option to restore"),
                    primaryButton: .destructive(Text("delete")) {
                        self.globalVars.floatingTasks[self.superIndex].subTasks[self.subIndex].notes.remove(at: self.noteIndex)
                        self.removed = true
                    },
                    secondaryButton: .cancel(Text("cancel"))
                )
            }
    }
}

struct taskNotes: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @ObservedObject var task: NoteTask
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                Text(task.name)
                    .font(.system(size: 25, weight: .medium, design: .rounded))
                    .underline()
                ForEach(Array(task.notes.enumerated()), id: \.element) { index, note in
                    dailyTaskNote(
                        task: self.task,
                        notes: self.task.notes,
                        note: note,
                        index: index
                    )
                }
                addNote(
                    task: task
                )
            }
                .padding(.top, 25)
        }
        .background(Color.init(UIColor.systemGray6).edgesIgnoringSafeArea(.all))
    }
}

struct subTaskNotes: View {
    @EnvironmentObject var globalVars: GlobalVars
    let superIndex: Int
    let subIndex: Int
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                Text("\(globalVars.floatingTasks[superIndex].main.text): \(globalVars.floatingTasks[superIndex].subTasks[subIndex].main.text)")
                    .font(.system(size: 25, weight: .medium, design: .rounded))
                    .underline()
                ForEach(globalVars.floatingTasks[superIndex].subTasks[subIndex].notes.indices, id: \.self) { index in
                    subTaskNote(superIndex: self.superIndex, subIndex: self.subIndex, noteIndex: index)
                }
                addSubNote(superIndex: superIndex, subIndex: subIndex)
            }
                .padding(.top, 25)
        }
        .background(Color.init(UIColor.systemGray6).edgesIgnoringSafeArea(.all))
    }
}
