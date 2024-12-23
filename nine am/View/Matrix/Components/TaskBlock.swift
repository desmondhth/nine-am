import SwiftUI

struct TaskBlock: View {
    let task: Task
    var onTap: () -> Void
    
    var body: some View {
        Text(task.content)
            .font(.system(size: 18))
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(task.isSelected ? Color.blue.opacity(0.1) : Color.white)
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.03), radius: 4, x: 0, y: 4)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(task.isSelected ? Color.blue : Color.clear, lineWidth: 2)
            )
            .onTapGesture {
                onTap()
            }
    }
} 