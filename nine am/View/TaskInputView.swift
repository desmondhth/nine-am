//
//  TaskInputView.swift
//  nine am
//
//  Created by Desmond Ho on 16/12/2024.
//

import SwiftUI

struct TaskInputView: View {
    @StateObject private var viewModel = TaskInputViewViewModel()
    @Binding var isPresented: Bool
    @Binding var showingMatrix: Bool
    @FocusState private var focusedField: Int?
    @Binding var tasks: [String]
    
    private var taskCountText: String {
        let count = max(viewModel.nonEmptyTaskCount, 1)
        return "Start with \(count) task\(count == 1 ? "" : "s")"
    }
    
    private func taskRow(at index: Int) -> some View {
        // First ensure the index is valid
        guard index < viewModel.tasks.count else {
            return EmptyView().eraseToAnyView()
        }
        
        return HStack(alignment: .top) {
            Text("\(index + 1).")
                .font(.system(size: Constants.Font.taskSize, design: .rounded))
            
            TextField("", text: Binding(
                get: { 
                    guard index < viewModel.tasks.count else { return "" }
                    return viewModel.tasks[index]
                },
                set: { newValue in
                    guard index < viewModel.tasks.count else { return }
                    viewModel.tasks[index] = newValue
                }
            ))
            .font(.system(size: Constants.Font.taskSize, design: .rounded))
            .foregroundColor(.black)
            .focused($focusedField, equals: index)
            .onSubmit {
                guard index < viewModel.tasks.count else { return }
                guard !viewModel.tasks[index].isEmpty else { return }
                
                viewModel.addTask(at: index)
                
                // Only set focus if the new index exists
                let nextIndex = index + 1
                if nextIndex < viewModel.tasks.count {
                    focusedField = nextIndex
                }
            }
            .onChange(of: viewModel.tasks[index]) { oldValue, newValue in
                guard index < viewModel.tasks.count else { return }
                
                if newValue.isEmpty && oldValue != newValue {
                    // Dispatch to next run loop to avoid state conflicts
                    DispatchQueue.main.async {
                        withAnimation {
                            viewModel.removeTask(at: index)
                            
                            // Handle focus after removal
                            if viewModel.tasks.indices.contains(index - 1) {
                                focusedField = index - 1
                            } else if !viewModel.tasks.isEmpty {
                                focusedField = 0
                            } else {
                                focusedField = nil
                            }
                        }
                    }
                }
            }
        }
        .eraseToAnyView()
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
                            print("Debug: Back button tapped")
                            isPresented = false
                        }
                    } label: {
                        Text("\(Date().formatted(.dateTime.day())) \(Date().formatted(.dateTime.month(.abbreviated)))")
                            .font(.custom("Caveat", size: 28))
                            .foregroundColor(.black)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        // Update the tasks in MainView
                        tasks = viewModel.tasks.filter { !$0.isEmpty }
                        
                        // Update states
                        showingMatrix = true
                        isPresented = false
                        
                        withAnimation(.easeInOut(duration: 0.3)) {
                            // Animation will handle the transitions
                        }
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
            .opacity(showingMatrix ? 0 : 1)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .transition(.opacity)
        .onAppear {
            print("Debug: TaskInputView appeared")
            focusedField = 0
        }
    }
}

// Helper extension to erase view type
extension View {
    func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
}

#Preview {
    TaskInputView(isPresented: .constant(true), showingMatrix: .constant(false), tasks: .constant([]))
}
