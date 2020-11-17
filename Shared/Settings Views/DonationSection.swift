//
//  DonationSection.swift
//  txtodo
//
//  Created by FIGBERT on 11/16/20.
//

import SwiftUI

struct DonationSection: View {
    var body: some View {
        VStack {
            Text("considerDonating")
                .multilineTextAlignment(.center)
                .padding()
            Link(destination: URL(string: "https://liberapay.com/FIGBERT/")!) { Text("donateLiberapay") }
        }
    }
}

struct DonationSection_Previews: PreviewProvider {
    static var previews: some View {
        DonationSection()
    }
}
