//
//  CustomShadowModifier.swift
//  Presentation
//
//  Created by QuyenLG on 10/5/25.
//

import SwiftUI

public struct ShadowEffectModifier: ViewModifier {
    let shadowColor: Color
    let shadowOpacity: CGFloat
    let shadowRadius: CGFloat
    let xOffset: CGFloat
    let yOffset: CGFloat
    
    public init(
        shadowColor: Color = .black,
        shadowOpacity: CGFloat = 0.3,
        shadowRadius: CGFloat = 2,
        xOffset: CGFloat = 0,
        yOffset: CGFloat = 4
    ) {
        self.shadowColor = shadowColor
        self.shadowOpacity = shadowOpacity
        self.shadowRadius = shadowRadius
        self.xOffset = xOffset
        self.yOffset = yOffset
    }
    
    public func body(content: Content) -> some View {
        content
            .shadow(
                color: shadowColor.opacity(shadowOpacity),
                radius: shadowRadius,
                x: xOffset,
                y: yOffset
            )
    }
}
