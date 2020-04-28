//
//  Onboarding.swift
//  txtodo
//
//  Created by FIGBERT on 3/16/20.
//  Copyright © 2020 FIGBERT Industries. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI
import UserNotifications

struct Onboarding: View {
    @EnvironmentObject var globalVars: GlobalVars
    @State private var currentPage = 0
    let subviews = [
        UIHostingController(rootView: Introduction()),
        UIHostingController(rootView: AddTaskDemo()),
        UIHostingController(rootView: TaskDemo()),
        UIHostingController(rootView: TaskTypes()),
        UIHostingController(rootView: AddNoteDemo()),
        UIHostingController(rootView: NoteDemo()),
        UIHostingController(rootView: RequestNotifications()),
        UIHostingController(rootView: ThankYou())
    ]
    let titles = ["welcome to txtodo", "create a task", "edit a task", "types of tasks", "create a note", "edit a note", "customize notifications", "thanks for downloading"]
    let captions = [
        "txtodo is a minimalist, open-source productivity app made by FIGBERT. It lists daily tasks that expire at midnight to help you get things done without overthinking them.",
        "tap on the button above to create a new task, and edit the text and priority. try out the live demo above.",
        "double tap a task to edit the task, press return to confirm your changes, and long press to delete. try out the live demo above.",
        "there are two types of tasks in txtodo: daily and floating. unlike daily tasks, which disappear at midnight, floating tasks never expire – however, you can only have three at a time!",
        "tap on the button above to create a new note. notes provide extra details about tasks, and they're accessed by tapping once on a task. try out the live demo above.",
        "double tap a note to edit the text, press return to confirm your changes, and long press to delete. try out the live demo above.",
        "txtodo uses notifications to remind users to set the day's tasks in the morning, but they are not required. notifications are scheduled at 8:30am by default. notifications can be modified from the settings menu.",
        "more projects are available at figbert.com"
    ]
    var body: some View {
        ZStack {
            Color.init(UIColor.systemGray6)
                .edgesIgnoringSafeArea(.all)
            VStack(alignment: .leading) {
                Spacer()
                PageViewController(currentPage: $currentPage, viewControllers: subviews)
                    .frame(height: 200)
                Spacer()
                Group {
                    Header(text: titles[currentPage], underline: false)
                    BodyText(text: captions[currentPage], color: .systemGray, alignment: .leading, strikethrough: false)
                }
                HStack {
                    PageControl(numberOfPages: subviews.count, currentPageIndex: $currentPage)
                    Spacer()
                    Button(action: {
                        if self.currentPage + 1 == self.subviews.count {
                            self.currentPage = 0
                        } else {
                            self.currentPage += 1
                        }
                    }) {
                        Image(systemName: currentPage != subviews.count - 1 ? "arrow.right.circle" : "arrow.counterclockwise.circle")
                            .font(.system(size: 30, weight: .light))
                            .foregroundColor(Color.init(UIColor.label))
                    }
                    if currentPage == subviews.count - 1 {
                        Button(action: {
                            self.globalVars.showOnboarding = false
                        }) {
                            Image(systemName: "xmark.circle")
                                .font(.system(size: 30, weight: .light))
                                .foregroundColor(Color.init(UIColor.label))
                        }
                    }
                }
            }
                .padding()
        }
    }
}

struct PageViewController: UIViewControllerRepresentable {
    @Binding var currentPage: Int
    var viewControllers: [UIViewController]
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    func makeUIViewController(context: Context) -> UIPageViewController {
        let pageViewController = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal
        )
        pageViewController.dataSource = context.coordinator
        pageViewController.delegate = context.coordinator
        return pageViewController
    }
    func updateUIViewController(_ pageViewController: UIPageViewController, context: Context) {
        pageViewController.setViewControllers(
            [viewControllers[currentPage]], direction: .forward, animated: true
        )
    }
    class Coordinator: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
        var parent: PageViewController
        init(_ pageViewController: PageViewController) {
            self.parent = pageViewController
        }
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
            guard let index = parent.viewControllers.firstIndex(of: viewController) else {
                 return nil
            }
            if index == 0 {
                return parent.viewControllers.last
            }
            return parent.viewControllers[index - 1]
            
        }
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
            guard let index = parent.viewControllers.firstIndex(of: viewController) else {
                return nil
            }
            if index + 1 == parent.viewControllers.count {
                return parent.viewControllers.first
            }
            return parent.viewControllers[index + 1]
        }
        func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
            if completed,
                let visibleViewController = pageViewController.viewControllers?.first,
                let index = parent.viewControllers.firstIndex(of: visibleViewController)
            {
                parent.currentPage = index
            }
        }
    }
}

struct PageControl: UIViewRepresentable {
    let numberOfPages: Int
    @Binding var currentPageIndex: Int
    func makeUIView(context: Context) -> UIPageControl {
       let control = UIPageControl()
       control.numberOfPages = numberOfPages
       control.currentPageIndicatorTintColor = UIColor.label
       control.pageIndicatorTintColor = UIColor.systemGray
       return control
    }
    func updateUIView(_ uiView: UIPageControl, context: Context) {
        uiView.currentPage = currentPageIndex
    }
}

struct Introduction: View {
    var body: some View {
        ZStack {
            Color.init(UIColor.systemGray6)
                .edgesIgnoringSafeArea(.all)
            Text("txtodo")
                .font(.system(size: 125, weight: .ultraLight, design: .rounded))
                .foregroundColor(Color.init(UIColor.label))
        }
    }
}

struct AddTaskDemo: View {
    @State private var addingTask: Bool = false
    @State private var text: String = ""
    @State private var priority: Int = 1
    @State private var task: [taskStruct] = []
    var body: some View {
        ZStack {
            Color.init(UIColor.systemGray6)
                .edgesIgnoringSafeArea(.all)
            VStack {
                ForEach(self.task, id: \.id) {
                    taskView(text: $0.text, priority: $0.priority)
                }
                if !addingTask {
                    HStack {
                        MainImage(name: "plus.square", color: .systemGray)
                        Spacer()
                        BodyText(text: "create a task", color: .systemGray, alignment: .center, strikethrough: false)
                        Spacer()
                        MainImage(name: "plus.square", color: .systemGray)
                    }
                        .padding(.horizontal, 25)
                        .onTapGesture {
                            self.addingTask = true
                        }
                } else {
                    HStack {
                        MainImage(name: "multiply.square", color: .systemGray)
                            .onTapGesture {
                                self.text = ""
                                self.priority = 0
                                self.addingTask = false
                            }
                        Spacer()
                        EditingField(placeholder: "tap here", text: $text, alignment: .center, onEnd: { })
                        Picker(
                            selection: $priority,
                            label: Text("task priority"),
                            content: {
                                Text("!").tag(1)
                                Text("!!").tag(2)
                                Text("!!!").tag(3)
                        })
                            .pickerStyle(SegmentedPickerStyle())
                        Spacer()
                        MainImage(name: "plus.square", color: .systemGray)
                            .onTapGesture {
                                if self.task.isEmpty == true {
                                    self.task.append(taskStruct(text: self.text, priority: self.priority))
                                } else {
                                    self.task[0] = taskStruct(text: self.text, priority: self.priority)
                                }
                                self.text = ""
                                self.priority = 0
                                self.addingTask = false
                            }
                    }
                        .padding(.horizontal, 25)
                }
            }
        }
    }
    struct taskStruct {
        let id: UUID = UUID()
        var text: String
        var priority: Int
    }
    struct taskView: View {
        @State var text: String
        @State var priority: Int
        @State private var complete: Bool = false
        @State private var editing: Bool = false
        var body: some View {
            HStack {
                MainImage(name: complete ? "checkmark.square" : "square", color: .label)
                    .onTapGesture {
                        self.complete.toggle()
                    }
                Spacer()
                if !editing {
                    BodyText(text: text, color: .label, alignment: .center, strikethrough: false)
                        .onTapGesture(count: 2) {
                            self.editing = true
                        }
                } else {
                    EditingField(placeholder: "editing", text: $text, alignment: .center, onEnd: { self.editing = false })
                }
                Spacer()
                if !editing {
                    if priority == 1 {
                        Text("  !  ")
                            .font(.system(size: 10, weight: .light))
                    } else if priority == 2 {
                        Text(" ! ! ")
                            .font(.system(size: 10, weight: .light))
                    } else if priority == 3 {
                        Text("! ! !")
                            .font(.system(size: 10, weight: .light))
                    } else {
                        Text("     ")
                            .font(.system(size: 10, weight: .light))
                    }
                } else {
                    Picker(
                        selection: $priority,
                        label: Text("task priority"),
                        content: {
                            Text("!").tag(1)
                            Text("!!").tag(2)
                            Text("!!!").tag(3)
                    })
                        .pickerStyle(SegmentedPickerStyle())
                }
            }
                .padding(.horizontal, 25)
        }
    }
}

struct TaskDemo: View {
    @State private var complete: Bool = false
    @State private var text: String = "lorem ipsum"
    @State private var priority: Int = 3
    @State private var editing: Bool = false
    var body: some View {
        ZStack {
            Color.init(UIColor.systemGray6)
                .edgesIgnoringSafeArea(.all)
            HStack {
                MainImage(name: complete ? "checkmark.square" : "square", color: .label)
                    .onTapGesture {
                        self.complete.toggle()
                    }
                Spacer()
                if !editing {
                    BodyText(text: text, color: .label, alignment: .center, strikethrough: false)
                        .onTapGesture(count: 2) {
                            self.editing = true
                        }
                } else {
                    EditingField(placeholder: "editing", text: $text, alignment: .center, onEnd: { self.editing = false })
                }
                Spacer()
                if !editing {
                    if priority == 1 {
                        Text("  !  ")
                            .font(.system(size: 10, weight: .light))
                    } else if priority == 2 {
                        Text(" ! ! ")
                            .font(.system(size: 10, weight: .light))
                    } else if priority == 3 {
                        Text("! ! !")
                            .font(.system(size: 10, weight: .light))
                    } else {
                        Text("     ")
                            .font(.system(size: 10, weight: .light))
                    }
                } else {
                    Picker(
                        selection: $priority,
                        label: Text("task priority"),
                        content: {
                            Text("!").tag(1)
                            Text("!!").tag(2)
                            Text("!!!").tag(3)
                    })
                        .pickerStyle(SegmentedPickerStyle())
                }
            }
                .padding(.horizontal, 25)
        }
    }
}

struct TaskTypes: View {
    var body: some View {
        ZStack {
            Color.init(UIColor.systemGray6)
                .edgesIgnoringSafeArea(.all)
            HStack {
                VStack {
                    Image(systemName: "clock")
                        .font(.system(size: 25, weight: .light, design: .rounded))
                        .foregroundColor(Color.init(UIColor.label))
                    BodyText(text: "daily", color: .label, alignment: .center, strikethrough: false)
                }
                    .padding(.horizontal, 50)
                VStack {
                    Image(systemName: "cloud")
                        .font(.system(size: 25, weight: .light, design: .rounded))
                        .foregroundColor(Color.init(UIColor.label))
                    BodyText(text: "floating", color: .label, alignment: .center, strikethrough: false)
                }
                    .padding(.horizontal, 50)
            }
        }
    }
}

struct AddNoteDemo: View {
    @State private var addingNote: Bool = false
    @State private var newNoteText: String = ""
    @State private var note: [String] = []
    var body: some View {
        ZStack {
            Color.init(UIColor.systemGray6)
                .edgesIgnoringSafeArea(.all)
            VStack {
                ForEach(self.note, id: \.self) {
                    noteView(note: $0)
                }
                if !addingNote {
                    Button(action: {
                        self.addingNote = true
                    }) {
                        HStack {
                            MainImage(name: "plus.square", color: .systemGray)
                            Spacer()
                            BodyText(text: "create a note", color: .systemGray, alignment: .center, strikethrough: false)
                            Spacer()
                            MainImage(name: "plus.square", color: .systemGray)
                        }.padding(.horizontal, 25)
                    }
                } else {
                    HStack {
                        Button(action: {
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            self.newNoteText = ""
                            self.addingNote = false
                        }) {
                            MainImage(name: "multiply.square", color: .systemGray)
                        }
                        Spacer()
                        EditingField(placeholder: "tap here", text: $newNoteText, alignment: .center, onEnd: { })
                        Spacer()
                        Button(action: {
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            if self.note.isEmpty == true {
                                self.note.append(self.newNoteText)
                            } else {
                                self.note[0] = self.newNoteText
                            }
                            self.newNoteText = ""
                            self.addingNote = false
                        }) {
                            MainImage(name: "plus.square", color: .systemGray)
                        }
                    }
                        .padding(.horizontal, 25)
                }
            }
        }
    }
    struct noteView: View {
        @State private var editing: Bool = false
        @State var note: String = "lorem ipsum dolor sit amet"
        var body: some View {
            HStack {
                MainImage(name: "minus", color: .label)
                    .padding(.trailing, 20)
                if !editing {
                    BodyText(text: note, color: .label, alignment: .leading, strikethrough: false)
                        .onTapGesture(count: 2) {
                            self.editing = true
                        }
                } else {
                    TextField("editing note", text: $note) {
                        self.editing = false
                    }
                        .font(.system(size: 20, weight: .light))
                        .foregroundColor(Color.init(UIColor.systemGray))
                        .autocapitalization(.none)
                }
                Spacer()
            }
                .padding(.horizontal, 25)
        }
    }
}

struct NoteDemo: View {
    @State private var editing: Bool = false
    @State private var note: String = "lorem ipsum dolor sit amet"
    var body: some View {
        ZStack {
            Color.init(UIColor.systemGray6)
                .edgesIgnoringSafeArea(.all)
            HStack {
                MainImage(name: "minus", color: .label)
                    .padding(.trailing, 20)
                if !editing {
                    BodyText(text: note, color: .label, alignment: .leading, strikethrough: false)
                        .onTapGesture(count: 2) {
                            self.editing = true
                        }
                } else {
                    TextField("editing note", text: $note) {
                        self.editing = false
                    }
                        .font(.system(size: 20, weight: .light))
                        .foregroundColor(Color.init(UIColor.systemGray))
                        .autocapitalization(.none)
                }
                Spacer()
            }
                .padding(.horizontal, 25)
        }
    }
}

struct RequestNotifications: View {
    @EnvironmentObject var globalVars: GlobalVars
    var body: some View {
        ZStack {
            Color.init(UIColor.systemGray6)
                .edgesIgnoringSafeArea(.all)
            VStack {
                Button(action: {
                    self.globalVars.notificationHour = 8
                    self.globalVars.notificationMinute = 30
                    self.globalVars.notifications = true
                }) {
                    Text(self.globalVars.notifications ? "notifications set for \(self.globalVars.notificationHour):\(self.globalVars.notificationMinute)am" : "set notifications to 8:30am")
                        .font(.system(size: 20, weight: .light, design: .rounded))
                        .foregroundColor(self.globalVars.notifications ? Color.green : Color.blue)
                        .multilineTextAlignment(.center)
                        .padding(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(self.globalVars.notifications ? Color.green : Color.blue, lineWidth: 1)
                        )
                }
                    .disabled(self.globalVars.notifications)
            }
        }
    }
}

struct ThankYou: View {
    var body: some View {
        ZStack {
            Color.init(UIColor.systemGray6)
                .edgesIgnoringSafeArea(.all)
            VStack {
                Text("txtodo")
                    .font(.system(size: 125, weight: .ultraLight, design: .rounded))
                    .foregroundColor(Color.init(UIColor.label))
                BodyText(text: "a minimalist open-source todo app", color: .label, alignment: .center, strikethrough: false)
                BodyText(text: "made by FIGBERT", color: .systemGray, alignment: .center, strikethrough: false)
            }
        }
    }
}

struct Onboarding_Previews: PreviewProvider {
    static var previews: some View {
        Onboarding()
    }
}
