import SwiftUI

struct MatrixMainView: View {
    @ObservedObject var viewModel: MatrixViewModel
    
    var body: some View {
        MatrixGridView(
            mode: .main,
            tasks: $viewModel.tasks,
            viewModel: viewModel
        )
    }
} 