//
//  ContentView.swift
//  nine am
//
//  Created by Desmond Ho on 16/12/2024.
//

import SwiftUI

struct MainView: View {
    @State private var showingTaskInput = false
    
    var body: some View {
        ZStack {
            // Background color at the root level
            Constants.Color.background
                .ignoresSafeArea()
            
            // Main content
            VStack(spacing: 38) {
                //logo
                Image("nineamlogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 70, height: 73)
                    .opacity(showingTaskInput ? 0 : 1)

                //today's date
                Text("\(Date().formatted(.dateTime.weekday(.wide))), \(Date().formatted(.dateTime.day())) \(Date().formatted(.dateTime.month(.abbreviated)))")
                    .font(.custom("Caveat-Bold", size: 32))
                    .opacity(showingTaskInput ? 0 : 1)
                
                //type task button
                Button {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        showingTaskInput = true
                    }
                } label: {
                    Text("Type your tasks...")
                        .font(.system(size: 28, weight: .regular, design: .default))
                        .foregroundColor(.black)
                        .opacity(0.15)
                }
                
                // Buttons
                VStack(spacing: 22) {
                    // AI Button
                    Button(action: {
                        // AI speech-to-text feature
                    }) {
                        HStack {
                            Image(systemName: "waveform")
                            Text("Tell the AI")
                        }
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .background(Color(hex: "#485AF6"))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(hex: "#CBC2FF"), lineWidth: 1.5)
                        )
                        .shadow(color: Color.black.opacity(0.03), radius: 4, x: 0, y: 4)
                        .font(.system(size: 16, weight: .semibold, design: .default))
                    }
                    .opacity(showingTaskInput ? 0 : 1)
                    
                    // Back to last session button
                    Button(action: {
                        // Add back to last session action here
                    }) {
                        Text("Back to last session")
                            .foregroundColor(.gray)
                            .font(.system(size: 16, weight: .medium, design: .default))
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            .background(Color.white)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                            .shadow(color: Color.black.opacity(0.03), radius: 4, x: 0, y: 4)
                    }
                    .opacity(showingTaskInput ? 0 : 1)
                }
            }
            .padding(.bottom, 15)
            
            // Task Input View
            if showingTaskInput {
                TaskInputView(isPresented: $showingTaskInput)
                    .transition(.opacity)
            }
        }
    }
}

#Preview {
    MainView()
}
