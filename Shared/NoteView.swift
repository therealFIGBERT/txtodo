//
//  NoteView.swift
//  txtodo
//
//  Created by FIGBERT on 8/11/20.
//

import SwiftUI

struct NoteView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @ObservedObject var task: Task
    @State var note: String
    @State var config: NoteViewConfig
    
    var body: some View {
        return HStack {
            Image(systemName: "minus")
                .padding(.trailing)
            if !config.editing {
                Text(note)
                    .onTapGesture(count: 2) {
                        self.config.editing = true
                    }
            } else {
                TextField("edit note", text: $config.editingCache, onCommit:  {
                    if let index = self.task.notes.firstIndex(of: self.note) {
                        self.managedObjectContext.performAndWait {
                            self.task.notes[index] = self.config.editingCache
                            try? self.managedObjectContext.save()
                        }
                    }
                    self.config.editing = false
                })
            }
            Spacer()
            if config.showingDelete {
                Image(systemName: "trash.circle.fill")
                    .font(.system(size: 25))
                    .foregroundColor(.red)
                    .onTapGesture {
                        if let index = self.task.notes.firstIndex(of: self.note) {
                            self.managedObjectContext.performAndWait {
                                self.task.notes.remove(at: index)
                                try? self.managedObjectContext.save()
                            }
                        }
                    }
            }
        }
            .offset(x: config.offset)
            .gesture(
                DragGesture()
                    .onChanged({ value in
                        config.offset = value.translation.width
                    })
                    .onEnded({ value in
                        if -config.offset > 15 {
                            config.showingDelete.toggle()
                        }
                        config.offset = 0
                    })
            )
    }
}

struct NoteViewConfig {
    var editing: Bool = false
    var showingDelete: Bool = false
    var offset: CGFloat = 0
    var editingCache: String
}
