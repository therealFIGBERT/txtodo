//
//  Elements.swift
//  txtodo
//
//  Created by Benjamin Welner on 2/17/20.
//  Copyright © 2020 FIGBERT Industries. All rights reserved.
//

import Foundation
import SwiftUI

struct task: Codable {
    var complete: Bool = false
    var text: String
    var time: Date!
    var priority: Int!
}

struct taskView: View {
    @State var task_: task
    let calendar = Calendar.current
    var body: some View {
        HStack {
            Button(action: {
                self.task_.complete.toggle()
            }) {
                if task_.complete {
                    Image(systemName: "checkmark.square")
                } else {
                    Image(systemName: "square")
                }
            }
                .font(.system(size: 25, weight: .light))
                .foregroundColor(Color.init(UIColor.label))
            Spacer()
            Text(task_.text)
                .font(.system(size: 20, weight: .light))
            Spacer()
            VStack {
                Text("\(calendar.component(.hour, from: task_.time)):\(calendar.component(.minute, from: task_.time))")
                    .font(.system(size: 10, weight: .light))
                if task_.priority == 1 {
                    Text("!")
                        .font(.system(size: 10, weight: .light))
                } else if task_.priority == 2 {
                    Text("! !")
                        .font(.system(size: 10, weight: .light))
                } else if task_.priority == 3 {
                    Text("! ! !")
                        .font(.system(size: 10, weight: .light))
                }
            }
        }.padding(.horizontal, 25)
    }
}
