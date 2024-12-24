//
//  MatrixView.swift
//  nine am
//
//  Created by Desmond Ho on 16/12/2024.
//

import SwiftUI

struct MatrixView: View {
    @StateObject private var viewModel = MatrixViewModel()
    @Environment(\.dismiss) private var dismiss
    
    let tasks: [String]
    
    var body: some View {
        ZStack {
            Constants.Color.background
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                MatrixNavBar(
                    date: Date(),
                    mode: viewModel.mode,
                    tasksRemaining: viewModel.stagingTasks.count,
                    onBackTapped: { 
                        withAnimation(.easeInOut(duration: 0.3)) {
                            dismiss()
                        }
                    },
                    viewModel: viewModel
                )
                
                switch viewModel.mode {
                case .dragging:
                    MatrixDraggingView(viewModel: viewModel)
                case .main:
                    MatrixMainView(viewModel: viewModel)
                case .addTask:
                    MatrixAddTaskView(viewModel: viewModel)
                }
            }
        }
        .onAppear {
            viewModel.initialize(with: tasks)
        }
    }
}

#Preview {
    MatrixView(tasks: [])
}
