//
//  AddNoteView.swift
//  txtodo
//
//  Created by FIGBERT on 8/6/20.
//

import SwiftUI

struct AddNoteView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @ObservedObject var task: Task
    @State private var config = AddNoteViewConfig()
    
    var body: some View {
        Group {
            if !config.addingNote {
                HStack {
                    Image(systemName: "plus.square")
                    Spacer()
                    Text("create a note")
                    Spacer()
                    Image(systemName: "plus.square")
                }
                    .onTapGesture {
                        #if os(iOS)
                            let generator = UIImpactFeedbackGenerator(style: .medium)
                            generator.prepare()
                            self.config.addingNote = true
                            generator.impactOccurred()
                        #else
                            self.config.addingNote = true
                        #endif
                    }
            } else {
                HStack {
                    Image(systemName: "multiply.square")
                        .onTapGesture {
                            #if os(iOS)
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                let generator = UIImpactFeedbackGenerator(style: .medium)
                                generator.prepare()
                                config.clear()
                                generator.impactOccurred()
                            #else
                                config.clear()
                            #endif
                        }
                    Spacer()
                    TextField("tap", text: $config.newNoteText, onCommit:  {
                        addTask()
                    })
                        .multilineTextAlignment(.center)
                    Spacer()
                    Image(systemName: "plus.square")
                        .onTapGesture {
                            addTask(forceKeyboardClose: true)
                        }
                }
            }
        }
            .font(.system(size: 18, weight: .light, design: .rounded))
            .foregroundColor(Color.secondary.opacity(0.5))
            .multilineTextAlignment(.center)
    }
    
    func addTask(forceKeyboardClose: Bool = false) {
        #if os(iOS)
            if forceKeyboardClose { UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil) }
        #endif
        guard self.config.newNoteText != "" else {return}
        #if os(iOS)
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.prepare()
        #endif
        self.managedObjectContext.performAndWait {
            self.task.notes.append(self.config.newNoteText)
            try? self.managedObjectContext.save()
        }
        #if os(iOS)
        generator.impactOccurred()
        #endif
        self.config.clear()
    }
}

struct AddNoteViewConfig {
    var addingNote: Bool = false
    var newNoteText: String = ""

    mutating func clear() {
        addingNote = false
        newNoteText = ""
    }
}
