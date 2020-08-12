//
//  SectionLabel.swift
//  txtodo
//
//  Created by FIGBERT on 7/28/20.
//

import SwiftUI

struct SectionLabel: View {
    let text: String
    
    var body: some View {
        HStack {
            Text(NSLocalizedString(text, comment: ""))
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(.gray)
                .multilineTextAlignment(.leading)
            Spacer()
        }
            .horizontalPaddingOnMacOS()
    }
}

struct SectionLabel_Previews: PreviewProvider {
    static var previews: some View {
        SectionLabel(text: "example")
    }
}
