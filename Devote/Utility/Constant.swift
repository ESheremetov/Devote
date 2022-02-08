//
//  Constant.swift
//  Devote
//
//  Created by Егор Шереметов on 29.01.2022.
//

import SwiftUI

// MARK: - FORMATTER

let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

// MARK: - UI

var backgroundGradientLight: LinearGradient {
    return LinearGradient(gradient: Gradient(colors: [.pink, .black]), startPoint: .topLeading, endPoint: .bottomTrailing)
}

var backgroundGradientDark: LinearGradient {
    return LinearGradient(gradient: Gradient(colors: [.black, .black, .pink]), startPoint: .topLeading, endPoint: .bottomTrailing)
}
// MARK: - UX
