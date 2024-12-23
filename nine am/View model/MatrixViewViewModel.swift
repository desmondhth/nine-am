//
//  MatrixViewViewModel.swift
//  nine am
//
//  Created by Desmond Ho on 16/12/2024.
//

import Foundation
import SwiftUI

@MainActor
class MatrixViewModel: ObservableObject {
    enum MatrixViewMode {
        case dragging
        case main
        case addTask
    }
    
    @Published var mode: MatrixViewMode = .dragging
    @Published var tasks: [Task] = []
    @Published var stagingTasks: [Task] = []
    @Published var newTask: String = ""
    
    func moveTask(_ taskId: String, to quadrant: MatrixQuadrant) {
        if let index = tasks.firstIndex(where: { $0.id.uuidString == taskId }) {
            tasks[index].quadrant = quadrant
        } else if let stagingIndex = stagingTasks.firstIndex(where: { $0.id.uuidString == taskId }) {
            var task = stagingTasks.remove(at: stagingIndex)
            task.quadrant = quadrant
            tasks.append(task)
        }
    }
    
    func initialize(with tasks: [String]) {
        self.stagingTasks = tasks.enumerated().map { index, content in
            Task(content: content, order: index)
        }
        self.mode = .dragging
    }
    
    func selectTask(_ taskId: String) {
        // Deselect all tasks first
        for index in tasks.indices {
            tasks[index].isSelected = false
        }
        for index in stagingTasks.indices {
            stagingTasks[index].isSelected = false
        }
        
        // Select the tapped task
        if let index = tasks.firstIndex(where: { $0.id.uuidString == taskId }) {
            tasks[index].isSelected = true
        } else if let index = stagingTasks.firstIndex(where: { $0.id.uuidString == taskId }) {
            stagingTasks[index].isSelected = true
        }
    }
}
