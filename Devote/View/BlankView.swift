//
//  BlankView.swift
//  Devote
//
//  Created by Егор Шереметов on 31.01.2022.
//

import SwiftUI

struct BlankView: View {
    
    // MARK: - PROPERTIES
    var backgroundColor: Color
    var backgroundOpacity: Double
    
    // MARK: - BODY
    var body: some View {
        VStack {
            Spacer()
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
        .background(backgroundColor)
        .opacity(backgroundOpacity)
        .blendMode(.overlay)
        .edgesIgnoringSafeArea(.all)
    }
}

// MARK: - PREVIEW
struct BlankView_Previews: PreviewProvider {
    static var previews: some View {
        BlankView(backgroundColor: .black, backgroundOpacity: 0.3)
            .background(BackgroundImageView())
            .background(backgroundGradientLight.ignoresSafeArea(.all))
    }
}
