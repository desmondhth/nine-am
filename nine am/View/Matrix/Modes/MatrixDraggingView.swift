import SwiftUI

struct MatrixDraggingView: View {
    @ObservedObject var viewModel: MatrixViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            // Matrix Grid
            MatrixGridView(
                mode: .dragging,
                tasks: $viewModel.tasks,
                viewModel: viewModel
            )
            
            // Staging Zone
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(viewModel.stagingTasks) { task in
                        TaskBlock(task: task, onTap: {})
                            .draggable(task.id.uuidString)
                    }
                }
                .padding(.horizontal, 24)
            }
            .frame(height: 100)
            .background(Color.white.opacity(0.5))
        }
    }
} 