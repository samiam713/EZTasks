//
//  RecurringTaskPlan.swift
//  EZTasks
//
//  Created by Samuel Donovan on 9/6/20.
//  Copyright © 2020 Samuel Donovan. All rights reserved.
//

import Foundation

struct RecurringTask: Codable, Equatable, Identifiable {
    var id = UUID()
    let name: String
}
