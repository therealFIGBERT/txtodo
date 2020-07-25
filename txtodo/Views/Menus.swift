//
//  Menus.swift
//  txtodo
//
//  Created by FIGBERT on 3/19/20.
//  Copyright © 2020 FIGBERT Industries. All rights reserved.
//

import SwiftUI
import UIKit
import StoreKit

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
                    .font(.system(size: 35, weight: .light))
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
    @Environment(\.colorScheme) var colorScheme
    @State private var IAPs: [SKProduct] = []
    @State private var IAPLoading: Bool = true
    @State private var IAPError: String = ""
    @State private var IAPAlertViewing: Bool = false
    @State private var IAPAlertHeader: String = ""
    @State private var IAPAlertBody: String = ""
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
                        Picker(
                            selection: $globalVars.notificationTime,
                            label: Text("notification time"),
                            content: {
                                Text("8:30").tag(0)
                                Text("9:30").tag(1)
                                Text("10:30").tag(2)
                        })
                            .disabled(!globalVars.notifications)
                            .pickerStyle(SegmentedPickerStyle())
                    }
                }
                Section(header: Text(String(NSLocalizedString("tip jar", comment: "")))) {
                    HStack {
                        Spacer()
                        if IAPLoading {
                            ProgressView()
                            Spacer()
                        } else {
                            if IAPError == "" {
                                ForEach(IAPs, id: \.self) { product in
                                    Group {
                                        Text(IAPManager.shared.getPriceFormatted(for: product) ?? "error")
                                            .foregroundColor(Color.white)
                                            .padding(.horizontal)
                                            .padding(.vertical, 3)
                                            .background(Color.blue.opacity(self.colorScheme == .dark ? 0.3 : 0.75).cornerRadius(10))
                                            .onTapGesture {
                                                self.purchase(product: product)
                                            }
                                        Spacer()
                                    }
                                }
                            } else {
                                Text(String(format: NSLocalizedString(IAPError, comment:  "")))
                                    .bodyText()
                                Spacer()
                            }
                        }
                    }
                        .onAppear(perform: {
                            IAPManager.shared.getProducts { (result) in
                                switch result {
                                    case .success(let products): self.IAPs = products; self.IAPError = ""; self.IAPLoading = false;
                                    case .failure(let error): print(error); self.IAPError = "failed to load tips"; self.IAPLoading = false;
                                }
                            }
                        })
                        .alert(isPresented: $IAPAlertViewing) {
                            Alert(
                                title: Text(String(format: NSLocalizedString(IAPAlertHeader, comment: ""))),
                                message: Text(String(format: NSLocalizedString(IAPAlertBody, comment: ""))),
                                dismissButton: .default(Text("thanks"))
                            )
                        }
                }
            }
                .navigationBarTitle("settings", displayMode: .inline)
                .listStyle(GroupedListStyle())
        }
    }
    
    func purchase(product: SKProduct) -> Void {
        if !IAPManager.shared.canMakePayments() {
            self.IAPAlertHeader = "tip failed"
            self.IAPAlertBody = "payment not available"
        } else {
            IAPManager.shared.buy(product: product) { result in
                switch result {
                    case .success(_): self.IAPAlertHeader = "success"; self.IAPAlertBody = "thanks for the tip"; self.IAPAlertViewing = true;
                    case .failure(let error): self.IAPAlertHeader = "error"; self.IAPAlertBody = "tip unsuccessful"; print(error); self.IAPAlertViewing = true;
                }
            }
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
            Link(destination: URL(string: "https://txtodo.app/")!) {
                Text("view site")
                    .bodyText(color: .link, alignment: .center)
                    .padding(.bottom, 10)
            }
            Link(destination: URL(string: "https://jeffhuang.com/productivity_text_file/")!) {
                Text("view inspo")
                    .bodyText(color: .link, alignment: .center)
                    .padding(.bottom, 10)
            }
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
