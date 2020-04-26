//
//  Menus.swift
//  txtodo
//
//  Created by FIGBERT on 3/19/20.
//  Copyright © 2020 FIGBERT Industries. All rights reserved.
//

import SwiftUI

struct Menu: View {
    @EnvironmentObject var globalVars: GlobalVars
    @State private var active: Bool = false
    @State private var showSettings: Bool = false
    @State private var showAbout: Bool = false
    var body: some View {
        VStack {
            Spacer()
            VStack(alignment: .trailing) {
                if showSettings {
                    MenuItem(img: "gear", txt: "settings")
                }
                if showAbout {
                    MenuItem(img: "book", txt: "about")
                }
                Image(systemName: active ? "control" : "line.horizontal.3")
                    .font(.system(size: 30, weight: .light))
                    .foregroundColor(Color.init(UIColor.label))
                    .onTapGesture {
                        self.active.toggle()
                        self.showSettings.toggle()
                        self.showAbout.toggle()
                    }
            }
                .background(Color.init(UIColor.systemGray6))
        }
    }
}

struct MenuItem: View {
    @EnvironmentObject var globalVars: GlobalVars
    @State private var viewing: Bool = false
    let img: String
    let txt: String
    var body: some View {
        HStack {
            Image(systemName: img)
            Text(txt)
        }
            .foregroundColor(Color.init(UIColor.label))
            .onTapGesture {
                self.viewing = true
            }
            .sheet(isPresented: $viewing, content: {
                if self.txt == "settings" {
                    Settings()
                        .environmentObject(self.globalVars)
                } else if self.txt == "about" {
                    About()
                } else {
                    Text("error")
                }
            })
    }
}

struct Settings: View {
    @EnvironmentObject var globalVars: GlobalVars
    @State private var changingTime: Bool = false
    var body: some View {
        VStack {
            Header(text: "settings", underline: true)
                .padding(.top, 25)
            Form {
                Section {
                    Toggle(isOn: $globalVars.notifications) {
                        HStack {
                            Image(systemName: "app.badge")
                            Text(globalVars.notifications ? "notifications enabled" : "notifications disabled")
                        }
                    }
                    HStack {
                        Image(systemName: "clock")
                        Text("time scheduled")
                        Spacer()
                        Button(action: {
                            self.changingTime = true
                        }) {
                            Text("\(globalVars.notificationHour):\(globalVars.notificationMinute)")
                        }
                            .disabled(!self.globalVars.notifications)
                            .sheet(isPresented: $changingTime, content: {
                                VStack {
                                    Text("time scheduled")
                                        .font(.system(size: 25, weight: .medium, design: .rounded))
                                        .underline()
                                    HStack {
                                        Picker(
                                            selection: self.$globalVars.notificationHour,
                                            label: Text("hour"),
                                            content: {
                                                Text("05").tag(5)
                                                Text("06").tag(6)
                                                Text("07").tag(7)
                                                Text("08").tag(8)
                                                Text("09").tag(9)
                                            }
                                        )
                                            .frame(width: 50, height: 125)
                                            .labelsHidden()
                                        Text(":")
                                            .padding(.horizontal, 50)
                                        Picker(
                                            selection: self.$globalVars.notificationMinute,
                                            label: Text("minutes"),
                                            content: {
                                                Text("00").tag(0)
                                                Text("10").tag(10)
                                                Text("15").tag(15)
                                                Text("30").tag(30)
                                                Text("45").tag(45)
                                                Text("50").tag(50)
                                            }
                                        )
                                            .frame(width: 50, height: 125)
                                            .labelsHidden()
                                    }
                                }
                            })
                    }
                }
                Section {
                    Button(action: {
                        self.globalVars.showOnboarding = true
                    }) {
                        HStack {
                            Image(systemName: "doc.richtext")
                            Text("show onboarding screen")
                        }
                    }
                }
            }
                .navigationBarTitle("settings", displayMode: .inline)
                .listStyle(GroupedListStyle())
        }
    }
}

struct About: View {
    let content: [String] = [
        "Pronounced \"text to do,\" txtodo is a minimalist open-source todo list app made by FIGBERT and inspired by Jeff Huang. it lists your immediate, short-term tasks to help you get things done without overthinking it.",
        "After reading a post by Jeff Huang, I started thinking about how I managed my own daily tasks. I wanted to make a solution that could train me into being highly productive.",
        "That solution is txtodo. It manages immediate, short-term tasks to help you get things done. welcome to productivity. welcome to txtodo."
    ]
    var body: some View {
        VStack {
            Header(text: "about", underline: true)
                .padding(.bottom, 25)
            BodyText(text: content[0], color: .label, alignment: .center, strikethrough: false)
                .padding(.bottom, 10)
            BodyText(text: content[1], color: .label, alignment: .center, strikethrough: false)
                .padding(.bottom, 10)
            BodyText(text: content[2], color: .label, alignment: .center, strikethrough: false)
                .padding(.bottom, 50)
            Button(action: {
                UIApplication.shared.open(URL(string: "https://txtodo.app/")!)
            }) {
                BodyText(text: "visit txtodo.app", color: .link, alignment: .center, strikethrough: false)
            }
                .padding(.bottom, 10)
            Button(action: {
                UIApplication.shared.open(URL(string: "https://jeffhuang.com/productivity_text_file/")!)
            }) {
                BodyText(text: "view the inspiration", color: .link, alignment: .center, strikethrough: false)
            }
                .padding(.bottom, 10)
            Spacer()
        }
            .padding()
    }
}

struct Menu_Previews: PreviewProvider {
    static var previews: some View {
        Menu()
    }
}
