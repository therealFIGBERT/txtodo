//
//  DevicePaddingModifiers.swift
//  txtodo
//
//  Created by FIGBERT on 8/11/20.
//

import SwiftUI

struct HorizontalPadding: ViewModifier {
    func body(content: Content) -> some View {
        return content.padding(.horizontal)
    }
}

extension View {
    func horizontalPaddingOnIOS() -> some View {
        #if os(iOS)
            return self.modifier(HorizontalPadding())
        #else
            return self
        #endif
    }
    func horizontalPaddingOnMacOS() -> some View {
        #if os(macOS)
            return self.modifier(HorizontalPadding())
        #else
            return self
        #endif
    }
}
