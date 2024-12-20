//
//  Constnat.swift
//  nine am
//
//  Created by Desmond Ho on 16/12/2024.
//

import Foundation
import SwiftUI

enum Constants {
    enum Font {
        static let taskSize: CGFloat = 24
        static let dateSize: CGFloat = 28
        static let taskInputSize: CGFloat = 14
        static let mainDateSize: CGFloat = 32
        static let mainTaskPromptSize: CGFloat = 28
        static let buttonTextSize: CGFloat = 16
    }
    
    enum Color {
        static let background = SwiftUI.Color(red: 250/255, green: 251/255, blue: 244/255)
        static let placeholder = SwiftUI.Color(hex: "#AAAAAA")
    }
}
