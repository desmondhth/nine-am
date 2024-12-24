import SwiftUI

struct MatrixDraggingView: View {
    @ObservedObject var viewModel: MatrixViewModel
    @State private var isDragging = false
    
    private var counterText: String {
        let current = viewModel.totalTasks - viewModel.stagingTasks.count + 1
        let total = viewModel.totalTasks
        return "\(current)/\(total)"
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Instruction text
            Text("Drag the task to the best zone.")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.black)
                .padding(.vertical, 24)
            
            // Matrix Grid
            MatrixGridView(
                mode: .dragging,
                tasks: $viewModel.tasks,
                viewModel: viewModel
            )
            .onDrop(of: [.text], delegate: DropDelegate(viewModel: viewModel))
            
            // Single Task Staging Zone
            if let currentTask = viewModel.stagingTasks.first {
                VStack(spacing: 12) {
                    TaskBlock(task: currentTask, onTap: {
                        print("DEBUG: Staging task tapped")
                    })
                    .draggable(currentTask.content) {
                        TaskBlock(task: currentTask, onTap: {})
                            .opacity(0.7)
                            .onAppear {
                                print("DEBUG: Starting drag operation")
                            }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 24)
                    
                    Text(counterText)
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(.black)
                }
                .frame(height: 120)
                .background(Color.white.opacity(0.5))
            }
        }
    }
}

// Add a DropDelegate to handle the drop in quadrants
struct DropDelegate: SwiftUI.DropDelegate {
    let viewModel: MatrixViewModel
    
    func performDrop(info: DropInfo) -> Bool {
        print("DEBUG: Drop performed at location: \(info.location)")
        // Handle the drop here
        return true
    }
    
    func dropEntered(info: DropInfo) {
        print("DEBUG: Drop entered at location: \(info.location)")
    }
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        print("DEBUG: Drop updated at location: \(info.location)")
        return DropProposal(operation: .move)
    }
    
    // Add required validateDrop method
    func validateDrop(info: DropInfo) -> Bool {
        return true
    }
} 
