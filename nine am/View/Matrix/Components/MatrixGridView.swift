import SwiftUI

struct MatrixGridView: View {
    let mode: MatrixViewModel.MatrixViewMode
    @Binding var tasks: [Task]
    @ObservedObject var viewModel: MatrixViewModel
    
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
