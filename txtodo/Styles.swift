//
//  Styles.swift
//  txtodo
//
//  Created by FIGBERT on 3/22/20.
//  Copyright © 2020 FIGBERT Industries. All rights reserved.
//

import SwiftUI

struct Header: ViewModifier {
    func body(content: Content) -> some View {
        return content
            .font(.system(size: 25, weight: .light, design: .rounded))
            .foregroundColor(Color.init(.label))
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
    let color: UIColor
    let alignment: TextAlignment
    func body(content: Content) -> some View {
        return content
            .font(.system(size: 20, weight: .light, design: .rounded))
            .foregroundColor(Color.init(color))
            .multilineTextAlignment(alignment)
    }
}

struct EditingField: ViewModifier {
    let alignment: TextAlignment
    func body(content: Content) -> some View {
        return content
            .font(.system(size: 20, weight: .light, design: .rounded))
            .foregroundColor(Color.init(.systemGray))
            .multilineTextAlignment(alignment)
            .autocapitalization(.none)
    }
}

struct MainImage: View {
    let name: String
    let color: UIColor
    var body: some View {
        Image(systemName: name)
            .font(.system(size: 25, weight: .light, design: .rounded))
            .foregroundColor(Color.init(color))
    }
}

extension View {
    func header() -> some View {
        return self.modifier(Header())
    }
    func sectionLabel() -> some View {
        return self.modifier(SectionLabel())
    }
    func bodyText(color: UIColor = .label, alignment: TextAlignment = .center) -> some View {
        return self.modifier(BodyText(color: color, alignment: alignment))
    }
    func editingField(alignment: TextAlignment = .center) -> some View {
        return self.modifier(EditingField(alignment: alignment))
    }
}
