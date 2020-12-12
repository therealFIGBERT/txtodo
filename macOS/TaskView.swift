//
//  TaskView.swift
//  txtodo
//
//  Created by FIGBERT on 7/27/20.
//

import SwiftUI

struct TaskView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.layoutDirection) var direction
    @ObservedObject var task: Task
    @State var priority: Int
    @State private var config = TaskViewConfig()
    
    var body: some View {
        let priorityIntermediary = Binding<Int>(
            get: { self.priority },
            set: { value in
                self.priority = value
                self.managedObjectContext.performAndWait {
                    self.task.priority = Int16(value)
                    try? self.managedObjectContext.save()
                }
                self.config.editingPriority = false
            }
        )
        return VStack {
            HStack {
                if task.daily && !task.hasBeenDelayed && !task.completed && config.showingDelay {
                    Image(systemName: "calendar.circle.fill")
                        .font(.system(size: 25))
                        .foregroundColor(.blue)
                        .onTapGesture {
                            self.managedObjectContext.performAndWait {
                                self.task.date = Calendar.current.date(byAdding: .day, value: 1, to: task.date) ?? Date()
                                self.task.hasBeenDelayed = true
                                try? self.managedObjectContext.save()
                            }
                            config.showingDelay = false
                        }
                }
                Image(systemName: task.completed ? "checkmark.square" : "square")
                    .onTapGesture {
                        self.managedObjectContext.performAndWait {
                            self.task.completed.toggle()
                            if !self.task.daily {
                                self.task.date = Date.init()
                            }
                            try? self.managedObjectContext.save()
                        }
                        self.config.showingNotes = false
                    }
                Spacer()
                if !config.editingText {
                    Text(task.name)
                        .strikethrough(task.completed)
                        .onTapGesture(count: 2) {
                            if !self.task.completed {
                                self.config.editingText = true
                            }
                        }
                        .onTapGesture {
                            self.config.showingNotes.toggle()
                        }
                } else {
                    TextField("edit task", text: $task.name, onCommit:  {
                        self.config.editingText = false
                        self.managedObjectContext.performAndWait {
                            try? self.managedObjectContext.save()
                        }
                    })
                }
                Spacer()
                if !config.editingPriority {
                    HStack(alignment: .center, spacing: 2) {
                        ForEach(1 ..< Int(task.priority + 1), id: \.self) {_ in
                            Text("!")
                        }
                    }
                        .font(.system(size: 10, weight: .light))
                        .onTapGesture(count: 2) {
                            if !self.task.completed {
                                self.config.editingPriority = true
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
                if config.showingDelete {
                    Image(systemName: "trash.circle.fill")
                        .font(.system(size: 25))
                        .foregroundColor(.red)
                        .onTapGesture {
                            self.managedObjectContext.performAndWait {
                                self.managedObjectContext.delete(self.task)
                                try? self.managedObjectContext.save()
                            }
                        }
                }
            }
            .padding(.bottom, 5)
            .foregroundColor(task.completed ? .secondary : .primary)
            .multilineTextAlignment(.center)
            .offset(x: config.offset)
            .gesture(
                DragGesture()
                    .onChanged({ value in
                        config.offset = direction == .leftToRight ? value.translation.width : -value.translation.width
                    })
                    .onEnded({ value in
                        if task.daily && config.offset > 15 {
                            config.showingDelay.toggle()
                        } else if -config.offset > 15 {
                            config.showingDelete.toggle()
                        }
                        config.offset = 0
                    })
            )
            if config.showingNotes {
                VStack(spacing: 10) {
                    ForEach(task.notes, id: \.self) { note in
                        NoteView(task: task, note: note, config: NoteViewConfig(editingCache: note))
                            .environment(\.managedObjectContext, self.managedObjectContext)
                    }
                    AddNoteView(task: task)
                }
                .padding(.leading)
                .padding(.bottom, 5)
            }
        }
        .padding(.vertical, config.showingNotes ? 12 : 0)
        .padding(.horizontal, 14)
        .background(config.showingNotes ? Color.gray.opacity(0.2) : .clear)
        .cornerRadius(15)
        .font(.system(size: 18, weight: .light))
    }
}

struct TaskViewConfig {
    var editingText: Bool = false
    var editingPriority: Bool = false
    var showingNotes: Bool = false
    var showingDelete: Bool = false
    var showingDelay: Bool = false
    var offset: CGFloat = 0
}
