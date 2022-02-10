//
//  BackgroundImageView.swift
//  Devote
//
//  Created by Егор Шереметов on 30.01.2022.
//

import SwiftUI

struct BackgroundImageView: View {
    var body: some View {
        Image("rocket")
            .resizable()
            .antialiased(true)
            .scaledToFill()
            .ignoresSafeArea(.all)
        
    }
}

struct BackgroundImageView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundImageView()
    }
}
