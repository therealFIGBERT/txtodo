//
//  HomeHeaderView.swift
//  txtodo (iOS)
//
//  Created by FIGBERT on 8/9/20.
//

import SwiftUI

struct HomeHeaderView: View {
    var body: some View {
        HStack {
            Spacer()
            Text("title")
                .underline()
            Spacer()
        }
    }
}

struct HomeHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HomeHeaderView()
    }
}
