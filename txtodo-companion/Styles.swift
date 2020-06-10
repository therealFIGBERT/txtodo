//
//  Styles.swift
//  txtodo-companion
//
//  Created by FIGBERT on 6/5/20.
//  Copyright © 2020 FIGBERT Industries. All rights reserved.
//

import SwiftUI

struct Header: ViewModifier {
    func body(content: Content) -> some View {
        return content
            .font(.system(size: 20, weight: .light, design: .rounded))
            .foregroundColor(Color.init(.textColor))
            .multilineTextAlignment(.center)
    }
}

struct SectionLabel: ViewModifier {
    func body(content: Content) -> some View {
        return content
            .font(.system(size: 10, weight: .bold))
            .foregroundColor(Color.init(.systemGray))
            .multilineTextAlignment(.leading)
    }
}

struct BodyText: ViewModifier {
    let color: Color
    let alignment: TextAlignment
    func body(content: Content) -> some View {
        return content
            .font(.system(size: 15, weight: .light, design: .rounded))
            .foregroundColor(color)
            .multilineTextAlignment(alignment)
    }
}

struct EditingField: ViewModifier {
    let alignment: TextAlignment
    func body(content: Content) -> some View {
        return content
            .font(.system(size: 15, weight: .light, design: .rounded))
            .foregroundColor(Color.init(.systemGray))
            .multilineTextAlignment(alignment)
    }
}

struct MainImage: View {
    let name: String
    var body: some View {
        Image(name)
            .resizable()
            .scaledToFit()
            .frame(width: 15, height: 15)
    }
}

extension View {
    func header() -> some View {
        return self.modifier(Header())
    }
    func sectionLabel() -> some View {
        return self.modifier(SectionLabel())
    }
    func bodyText(color: Color = Color(.textColor), alignment: TextAlignment = .center) -> some View {
        return self.modifier(BodyText(color: color, alignment: alignment))
    }
    func editingField(alignment: TextAlignment = .center) -> some View {
        return self.modifier(EditingField(alignment: alignment))
    }
}
