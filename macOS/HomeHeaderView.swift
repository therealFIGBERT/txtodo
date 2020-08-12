//
//  HomeHeaderView.swift
//  txtodo
//
//  Created by FIGBERT on 8/8/20.
//

import SwiftUI

struct HomeHeaderView: View {
    var body: some View {
        Text({ () -> String in
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            return formatter.string(from: Date())
        }())
            .font(.system(size: 20, weight: .bold))
            .padding(.horizontal)
    }
}

struct HomeHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HomeHeaderView()
    }
}
