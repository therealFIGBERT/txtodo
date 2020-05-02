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
                        let generator = UIImpactFeedbackGenerator(style: .medium)
                        generator.prepare()
                        self.active.toggle()
                        generator.impactOccurred()
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
            Text(String(format: NSLocalizedString(txt, comment: "")))
        }
            .foregroundColor(Color.init(UIColor.label))
            .onTapGesture {
                let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.prepare()
                self.viewing = true
                generator.impactOccurred()
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
            Text("settings")
                .underline()
                .header()
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
                            let generator = UIImpactFeedbackGenerator(style: .medium)
                            generator.prepare()
                            self.changingTime = true
                            generator.impactOccurred()
                        }) {
                            Text("0\(globalVars.notificationHour):\(globalVars.notificationMinute != 0 ? "\(globalVars.notificationMinute)" : "00")")
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
                        let generator = UIImpactFeedbackGenerator(style: .medium)
                        generator.prepare()
                        self.globalVars.showOnboarding = true
                        generator.impactOccurred()
                    }) {
                        HStack {
                            Image(systemName: "doc.richtext")
                            Text("show tutorial")
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
        "aboutOne",
        "aboutTwo",
        "aboutThree"
    ]
    var body: some View {
        VStack {
            Text("about")
                .underline()
                .header()
                .padding(.bottom, 25)
            Text(String(format: NSLocalizedString(content[0], comment: "")))
                .bodyText()
                .padding(.bottom, 10)
            Text(String(format: NSLocalizedString(content[1], comment: "")))
                .bodyText()
                .padding(.bottom, 10)
            Text(String(format: NSLocalizedString(content[2], comment: "")))
                .bodyText()
                .padding(.bottom, 50)
            Button(action: {
                UIApplication.shared.open(URL(string: "https://txtodo.app/")!)
            }) {
                Text("view site")
                    .bodyText(color: .link, alignment: .center)
            }
                .padding(.bottom, 10)
            Button(action: {
                UIApplication.shared.open(URL(string: "https://jeffhuang.com/productivity_text_file/")!)
            }) {
                Text("view inspo")
                    .bodyText(color: .link, alignment: .center)
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
