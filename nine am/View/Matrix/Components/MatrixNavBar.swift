import SwiftUI

struct MatrixNavBar: View {
    let date: Date
    let mode: MatrixViewModel.MatrixViewMode
    let tasksRemaining: Int
    let onBackTapped: () -> Void
    @ObservedObject var viewModel: MatrixViewModel
    
    var body: some View {
        HStack {
            Text("\(date.formatted(.dateTime.day())) \(date.formatted(.dateTime.month(.abbreviated)))")
                .font(.custom("Caveat", size: 28))
                .foregroundColor(.black)
            
            Spacer()
            
            // Tasks remaining text
            Text("\(tasksRemaining) tasks left")
                .foregroundColor(.gray)
                .font(.system(size: 14, weight: .medium))
                .padding(.trailing, 8)
            
            // Add task button
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    viewModel.mode = .addTask
                }
            }) {
                Image(systemName: "plus")
                    .foregroundColor(.black)
                    .padding(12)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.03), radius: 4, x: 0, y: 4)
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
    }
} 