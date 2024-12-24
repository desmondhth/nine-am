import SwiftUI

struct MatrixGridView: View {
    let mode: MatrixViewModel.MatrixViewMode
    @Binding var tasks: [Task]
    @ObservedObject var viewModel: MatrixViewModel
    @State private var hoveredQuadrant: MatrixQuadrant?
    
    private let gridPadding: CGFloat = 24
    private let diamondSize: CGFloat = 8
    
    private func gridHeight(in geometry: GeometryProxy) -> CGFloat {
        geometry.size.height * 0.85
    }
    
    private func drawDiamond(at point: CGPoint) -> Path {
        Path { path in
            path.move(to: CGPoint(x: point.x, y: point.y - diamondSize))
            path.addLine(to: CGPoint(x: point.x + diamondSize, y: point.y))
            path.addLine(to: CGPoint(x: point.x, y: point.y + diamondSize))
            path.addLine(to: CGPoint(x: point.x - diamondSize, y: point.y))
            path.closeSubpath()
        }
    }
    
    private func quadrantContent(_ quadrant: MatrixQuadrant, geometry: GeometryProxy) -> some View {
        let quadrantTasks = tasks.filter { $0.quadrant == quadrant }
        let maxVisibleTasks = 4 // Adjust based on your UI
        
        return VStack(alignment: .leading, spacing: 8) {
            ForEach(Array(quadrantTasks.prefix(maxVisibleTasks))) { task in
                TaskBlock(task: task) {
                    viewModel.selectTask(task.id.uuidString)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 35) // Fixed height for quadrant tasks
                .transition(.scale.combined(with: .opacity))
            }
            
            if quadrantTasks.count > maxVisibleTasks {
                Button(action: {
                    // Show task list view
                }) {
                    Text("\(quadrantTasks.count - maxVisibleTasks) more tasks")
                        .foregroundColor(.gray)
                        .font(.system(size: 14))
                }
            }
        }
        .frame(width: geometry.size.width/2 - gridPadding*3)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Matrix Grid Lines with Diamonds
                let width = geometry.size.width - (gridPadding * 2)
                let height = gridHeight(in: geometry)
                let centerX = width / 2 + gridPadding
                let centerY = height / 2
                
                // 1. Draw lines FIRST (will be underneath)
                // Vertical line
                Path { path in
                    path.move(to: CGPoint(x: centerX, y: gridPadding))
                    path.addLine(to: CGPoint(x: centerX, y: height - gridPadding))
                }
                .stroke(Color.gray.opacity(0.3), lineWidth: 2)
                
                // Horizontal line
                Path { path in
                    path.move(to: CGPoint(x: gridPadding, y: centerY))
                    path.addLine(to: CGPoint(x: width + gridPadding, y: centerY))
                }
                .stroke(Color.gray.opacity(0.3), lineWidth: 2)
                
                // 2. Draw diamonds SECOND (will be on top)
                Group {
                    // Top
                    drawDiamond(at: CGPoint(x: centerX, y: gridPadding))
                        .fill(Color.gray.opacity(0.3))
                    // Bottom
                    drawDiamond(at: CGPoint(x: centerX, y: height - gridPadding))
                        .fill(Color.gray.opacity(0.3))
                    // Left
                    drawDiamond(at: CGPoint(x: gridPadding, y: centerY))
                        .fill(Color.gray.opacity(0.3))
                    // Right
                    drawDiamond(at: CGPoint(x: width + gridPadding, y: centerY))
                        .fill(Color.gray.opacity(0.3))
                }
                
                // Vertical Axis Labels
                HStack {
                    // Left label
                    Text("Not important")
                        .font(.system(size: 14, weight: .semibold, design: .default))
                        .foregroundColor(.black)
                        .position(x: gridPadding + 55, y: centerY - 15)
                    
                    Spacer()
                    
                    // Right label
                    Text("Important")
                        .font(.system(size: 14, weight: .semibold, design: .default))
                        .foregroundColor(.black)
                        .position(x: gridPadding + 110 , y: centerY - 15)
                }
                .frame(width: width + (gridPadding * 2))
                
                // Horizontal Axis Labels
                VStack {
                    // Top label
                    Text("Urgent")
                        .font(.system(size: 14, weight: .semibold, design: .default))
                        .foregroundColor(.black)
                        .position(x: centerX + 35, y: gridPadding + 5)
                    
                    Spacer()
                    
                    // Bottom label
                    Text("Not urgent")
                        .font(.system(size: 14, weight: .semibold, design: .default))
                        .foregroundColor(.black)
                        .position(x: centerX + 50, y: gridPadding + 200)
                }
                .frame(height: height)
                
                // Add drop zones for each quadrant
                ForEach(MatrixQuadrant.allCases, id: \.self) { quadrant in
                    let position = positionForQuadrant(quadrant, in: geometry)
                    ZStack {
                        Rectangle()
                            .fill(hoveredQuadrant == quadrant ? Color.blue.opacity(0.1) : Color.clear)
                            .frame(width: geometry.size.width/2 - gridPadding*2,
                                   height: gridHeight(in: geometry)/2 - gridPadding*2)
                        
                        quadrantContent(quadrant, geometry: geometry)
                    }
                    .position(position)
                    .dropDestination(for: String.self) { items, location in
                        guard let taskId = items.first else { return false }
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            viewModel.moveTask(taskId, to: quadrant)
                        }
                        return true
                    } isTargeted: { isTargeted in
                        withAnimation(.easeInOut(duration: 0.2)) {
                            hoveredQuadrant = isTargeted ? quadrant : nil
                        }
                    }
                }
                
                // Tasks
                ForEach(tasks) { task in
                    if let quadrant = task.quadrant {
                        TaskBlock(task: task) {
                            viewModel.selectTask(task.id.uuidString)
                        }
                        .position(positionForQuadrant(quadrant, in: geometry))
                    }
                }
            }
            .frame(height: gridHeight(in: geometry))
        }
    }
    
    private func positionForQuadrant(_ quadrant: MatrixQuadrant, in geometry: GeometryProxy) -> CGPoint {
        let width = geometry.size.width - (gridPadding * 2)
        let height = gridHeight(in: geometry)
        let centerX = width / 2 + gridPadding
        let centerY = height / 2
        
        switch quadrant {
        case .urgentImportant:
            return CGPoint(x: centerX + width/4, y: centerY - height/4)
        case .notUrgentImportant:
            return CGPoint(x: centerX + width/4, y: centerY + height/4)
        case .urgentNotImportant:
            return CGPoint(x: centerX - width/4, y: centerY - height/4)
        case .notUrgentNotImportant:
            return CGPoint(x: centerX - width/4, y: centerY + height/4)
        }
    }
} 
