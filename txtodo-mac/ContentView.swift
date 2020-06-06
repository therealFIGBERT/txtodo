//
//  ContentView.swift
//  txtodo-mac
//
//  Created by FIGBERT on 6/4/20.
//  Copyright © 2020 FIGBERT Industries. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var viewManager: ViewManager
    var body: some View {
        Group {
            if viewManager.viewingDailyTaskNotes {
                dailyTaskNotes(task: viewManager.dailyTask)
            } else if viewManager.viewingFloatingTaskNotes {
                floatingTaskNotes(task: viewManager.floatingTask)
            } else {
                HomeScreen()
            }
        }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(ViewManager())
    }
}
