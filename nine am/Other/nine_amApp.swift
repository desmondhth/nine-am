//
//  nine_amApp.swift
//  nine am
//
//  Created by Desmond Ho on 16/12/2024.
//

import SwiftUI

@main
struct nine_amApp: App {
        init() {
        // Add this to register the font
        if let fontURL = Bundle.main.url(forResource: "Caveat-VariableFont_wght", withExtension: "ttf") {
            CTFontManagerRegisterFontsForURL(fontURL as CFURL, .process, nil)
        }
    }
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
