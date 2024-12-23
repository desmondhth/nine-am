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
        guard index < tasks.count else { return }
        guard !tasks[index].isEmpty else { return }
        tasks.insert("", at: index + 1)
    }
    
    func removeTask(at index: Int) {
        guard index < tasks.count else { return }
        // Don't remove if it's the last task
        guard tasks.count > 1 else { 
            // If it's the last task, just clear it
            tasks[index] = ""
            return 
        }
        tasks.remove(at: index)
    }
}
