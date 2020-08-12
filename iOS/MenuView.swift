//
//  MenuView.swift
//  txtodo (iOS)
//
//  Created by FIGBERT on 8/6/20.
//

import SwiftUI

struct MenuView: View {
    @State private var config = MenuViewConfig()
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 18) {
                if config.active {
                    Label("settings", systemImage: "gear")
                        .onTapGesture {
                            config.showSettings = true
                        }
                        .sheet(isPresented: $config.showSettings) {
                            SettingsSheet()
                        }
                    Label("about", systemImage: "book")
                        .onTapGesture {
                            config.showAbout = true
                        }
                        .sheet(isPresented: $config.showAbout) {
                            AboutSheet()
                        }
                }
                Image(systemName: config.active ? "chevron.up" : "line.horizontal.3")
                    .font(.system(size: 30, weight: .ultraLight))
                    .onTapGesture {
                        config.active.toggle()
                    }
            }
            Spacer()
        }
            .font(.system(size: 18, weight: .light))
            .padding()
    }
}

struct MenuViewConfig {
    var active: Bool = false
    var showSettings: Bool = false
    var showAbout: Bool = false
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
