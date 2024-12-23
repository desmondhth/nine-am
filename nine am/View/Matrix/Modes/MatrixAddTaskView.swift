import SwiftUI

struct MatrixAddTaskView: View {
    @ObservedObject var viewModel: MatrixViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            MatrixGridView(
                mode: .addTask,
                tasks: $viewModel.tasks,
                viewModel: viewModel
            )
            
            // New task input
            TextField("Task name", text: $viewModel.newTask)
                .font(.system(size: 18))
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.03), radius: 4, x: 0, y: 4)
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
                .onSubmit {
                    guard !viewModel.newTask.isEmpty else { return }
                    let task = Task(
                        content: viewModel.newTask,
                        order: viewModel.tasks.count
                    )
                    viewModel.tasks.append(task)
                    viewModel.newTask = ""
                    viewModel.mode = .main
                }
        }
    }
} 