//
//  AboutSheet.swift
//  txtodo (iOS)
//
//  Created by FIGBERT on 8/6/20.
//

import SwiftUI

struct AboutSheet: View {
    var body: some View {
        VStack() {
            Text("about")
                .underline()
                .padding(.vertical)
            Text("aboutOne")
                .multilineTextAlignment(.center)
            Text("aboutTwo")
                .multilineTextAlignment(.center)
                .padding(.vertical)
            Text("aboutThree")
                .multilineTextAlignment(.center)
            Link(destination: URL(string: "https://txtodo.app/")!) { Text("view site") }
                .padding(.vertical)
            Link(destination: URL(string: "https://jeffhuang.com/productivity_text_file/")!) { Text("view inspo") }
            Spacer()
        }
            .padding()
    }
}

struct AboutSheet_Previews: PreviewProvider {
    static var previews: some View {
        AboutSheet()
    }
}
