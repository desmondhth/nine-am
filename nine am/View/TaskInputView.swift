//
//  TaskInputView.swift
//  nine am
//
//  Created by Desmond Ho on 16/12/2024.
//

import SwiftUI

struct TaskInputView: View {
    @Binding var isPresented: Bool
    @StateObject private var viewModel = TaskInputViewViewModel()
    @FocusState private var focusedField: Int?
    
    private var taskCountText: String {
        let count = max(viewModel.nonEmptyTaskCount, 1)
        return "Start with \(count) task\(count == 1 ? "" : "s")"
    }
    
    private func taskRow(at index: Int) -> some View {
        HStack(alignment: .top) {
            Text("\(index + 1).")
                .font(.system(size: Constants.Font.taskSize, design: .rounded))
            
            TextField("", text: $viewModel.tasks[index])
                .font(.system(size: Constants.Font.taskSize, design: .rounded))
                .foregroundColor(.black)
                .focused($focusedField, equals: index)
                .onSubmit {
                    guard !viewModel.tasks[index].isEmpty else { return }
                    let nextIndex = index + 1
                    viewModel.addTask(at: index)
                    focusedField = nextIndex
                }
                .onChange(of: viewModel.tasks[index]) { _, _ in
                    withAnimation {
                        viewModel.removeTask(at: index)
                    }
                }
        }
    }
    
    private func placeholderRow(count: Int) -> some View {
        HStack(alignment: .top) {
            Text("\(count + 1).")
                .font(.system(size: Constants.Font.taskSize, design: .rounded))
                .foregroundColor(Constants.Color.placeholder)
                .frame(alignment: .leading)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var body: some View {
        ZStack {
            // Background color at the root level
            Constants.Color.background
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 16) {
                // Top bar with date
                HStack {
                    Button {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            isPresented = false
                        }
                    } label: {
                        Text("\(Date().formatted(.dateTime.day())) \(Date().formatted(.dateTime.month(.abbreviated)))")
                            .font(.custom("Caveat", size: 28))
                            .foregroundColor(.black)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        // Handle continue action
                    }) {
                        HStack(spacing: 4) {
                            Text(taskCountText)
                            Image(systemName: "arrow.right")
                        }
                        .foregroundColor(.black)
                        .font(.system(size: 14, weight: .medium))
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
                    .opacity(viewModel.nonEmptyTaskCount > 0 ? 1 : 0)
                    .animation(.easeIn(duration: 0.2), value: viewModel.nonEmptyTaskCount > 0)
                    .allowsHitTesting(viewModel.nonEmptyTaskCount > 0)
                }
                .padding(.horizontal, 24)
                
                // Tasks list
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(viewModel.tasks.indices, id: \.self) { index in
                        taskRow(at: index)
                        
                        if index == viewModel.tasks.count - 1 && !viewModel.tasks[index].isEmpty {
                            placeholderRow(count: viewModel.tasks.count)
                                .transition(.opacity)
                        }
                    }
                }
                .padding(24)
                .animation(.easeIn(duration: 0.2), value: viewModel.tasks.count)
                
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .transition(.opacity)
        .onAppear {
            focusedField = 0
        }
    }
}

#Preview {
    TaskInputView(isPresented: .constant(true))
}
