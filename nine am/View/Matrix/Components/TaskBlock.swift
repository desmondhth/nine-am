import SwiftUI

struct TaskBlock: View {
    let task: Task
    var onTap: () -> Void
    
    var body: some View {
        Text(task.content)
            .font(.system(size: 16))
            .foregroundColor(.black)
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
            )
            .onTapGesture {
                print("DEBUG: TaskBlock tapped")
                onTap()
            }
            .gesture(
                DragGesture()
                    .onChanged { value in
                        print("DEBUG: TaskBlock dragging - translation: \(value.translation)")
                    }
                    .onEnded { value in
                        print("DEBUG: TaskBlock drag ended - final translation: \(value.translation)")
                    }
            )
    }
} 