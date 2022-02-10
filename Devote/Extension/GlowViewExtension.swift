//
//  GlowViewExtension.swift
//  Devote
//
//  Created by Егор Шереметов on 07.02.2022.
//

import SwiftUI


extension View {
    func glow(color: Color, radius: CGFloat = 20, opacity: Double = 1.0) -> some View {
        self
            .shadow(color: color.opacity(opacity), radius: radius / 3)
            .shadow(color: color.opacity(opacity), radius: radius / 3)
            .shadow(color: color.opacity(opacity), radius: radius / 3)
    }
}
