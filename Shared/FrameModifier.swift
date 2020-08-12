//
//  FrameModifier.swift
//  txtodo
//
//  Created by FIGBERT on 8/6/20.
//

import SwiftUI

struct FrameModifier: ViewModifier {
    func body(content: Content) -> some View {
        #if os(macOS)
            return content.frame(width: 325, height: 400)
        #else
            return content
        #endif
    }
}
