//
//  ContentView.swift
//  nine am
//
//  Created by Desmond Ho on 16/12/2024.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        ZStack {
            Color(red: 250/255, green: 251/255, blue: 244/255)
              .ignoresSafeArea()
            VStack {
                Image("nineamlogo")
                .resizable()
                .scaledToFit()
                .frame(width: 70, height: 73)

                Text(Date().formatted(.dateTime.weekday().day().month()))
                    .font(.custom("Caveat-Bold", size: 36))
                    .padding(.top, 8)
                    .padding(.bottom, 8)  // Add bottom padding
                    .frame(height: 40)   // Set a specific height to accommodate the full text

            }
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    MainView()
}
