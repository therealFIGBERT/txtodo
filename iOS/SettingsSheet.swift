//
//  SettingsSheet.swift
//  txtodo (iOS)
//
//  Created by FIGBERT on 8/6/20.
//

import SwiftUI

struct SettingsSheet: View {
    @StateObject var storeManager: StoreManager
    
    var body: some View {
        VStack {
            Text("settings")
                .underline()
                .padding()
            Form {
                NotificationSection()
                DonationSection(storeManager: storeManager)
            }
            .listStyle(GroupedListStyle())
        }
    }
}

struct SettingsSheet_Previews: PreviewProvider {
    static var previews: some View {
        SettingsSheet(storeManager: StoreManager())
    }
}
