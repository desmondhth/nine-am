//
//  Task.swift
//  nine am
//
//  Created by Desmond Ho on 16/12/2024.
//

import Foundation

struct Task: Identifiable {
    let id: UUID = UUID()
    var content: String
    var order: Int
    var quadrant: MatrixQuadrant?
    var position: CGPoint
    var isSelected: Bool = false
    var isDragging: Bool = false
    
    init(content: String = "", order: Int, quadrant: MatrixQuadrant? = nil, position: CGPoint = .zero, isSelected: Bool = false) {
        self.content = content
        self.order = order
        self.quadrant = quadrant
        self.position = position
        self.isSelected = isSelected
    }
}
enum MatrixQuadrant: CaseIterable {
    case urgentImportant
    case notUrgentImportant
    case urgentNotImportant
    case notUrgentNotImportant
}

