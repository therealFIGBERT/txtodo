//
//  SettingsView.swift
//  txtodo (macOS)
//
//  Created by FIGBERT on 8/6/20.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        TabView {
            VStack {
                Text("txtodo by figbert - v\(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String)")
                Link(destination: URL(string: "https://txtodo.app/")!) { Text("view site") }
                    .padding()
                Link(destination: URL(string: "https://jeffhuang.com/productivity_text_file/")!) { Text("view inspo") }
            }
                .tabItem {
                    Text("about")
                    Image(systemName: "book")
                }
            Form { NotificationSection() }
                .padding()
                .tabItem {
                    Text("notifications")
                    Image(systemName: "app.badge")
                }
        }
            .frame(width: 300, height: 150)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
