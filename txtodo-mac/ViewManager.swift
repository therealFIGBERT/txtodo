//
//  ViewManager.swift
//  txtodo-mac
//
//  Created by FIGBERT on 6/5/20.
//  Copyright © 2020 FIGBERT Industries. All rights reserved.
//

import Foundation

class ViewManager: ObservableObject {
    @Published var viewingFloatingTaskNotes: Bool = false
    @Published var viewingDailyTaskNotes: Bool = false
    @Published var floatingTask: FloatingTask = FloatingTask()
    @Published var dailyTask: DailyTask = DailyTask()
}
