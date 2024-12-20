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
    
    init(content: String = "", order: Int) {
        self.content = content
        self.order = order
    }
}
