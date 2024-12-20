//
//  TaskInputViewViewModel.swift
//  nine am
//
//  Created by Desmond Ho on 16/12/2024.
//

import Foundation

@MainActor
class TaskInputViewViewModel: ObservableObject {
    @Published var tasks: [String] = [""]
    
    var nonEmptyTaskCount: Int {
        tasks.filter { !$0.isEmpty }.count
    }
    
    func addTask(at index: Int) {
        if !tasks[index].isEmpty {
            tasks.append("")
        }
    }
    
    func removeTask(at index: Int) {
        if tasks[index].isEmpty && tasks.count > 1 {
            tasks.remove(at: index)
        }
    }
}