//
//  InactiveTask.swift
//  EZTasks
//
//  Created by Samuel Donovan on 9/5/20.
//  Copyright © 2020 Samuel Donovan. All rights reserved.
//

import Foundation

struct InactiveTask: Identifiable, Codable, Equatable {
    
    static func == (lhs: Self, rhs: Self) -> Bool {return lhs.id == rhs.id}
    
    var id = UUID()
    let name: String
    let completionDate: String
    
    init(activeTask: ActiveTask) {
        name = activeTask.name
        completionDate = Date().toShortDate()
    }
}
