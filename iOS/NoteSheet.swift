//
//  NoteSheet.swift
//  txtodo
//
//  Created by FIGBERT on 8/5/20.
//

import SwiftUI

struct NoteSheet: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @ObservedObject var task: Task
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 10) {
                Text(task.name)
                    .underline()
                ForEach(task.notes, id: \.self) { note in
                    NoteView(task: task, note: note)
                        .environment(\.managedObjectContext, self.managedObjectContext)
                }
                AddNoteView(task: task)
            }
        }
            .padding()
    }
}
