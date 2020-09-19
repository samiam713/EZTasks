//
//  RecurringTask.swift
//  EZTasks
//
//  Created by Samuel Donovan on 7/10/20.
//  Copyright © 2020 Samuel Donovan. All rights reserved.
//

import Foundation

class RecurringTaskPlan: ObservableObject, Codable, Identifiable, Equatable {
    static func == (lhs: RecurringTaskPlan, rhs: RecurringTaskPlan) -> Bool {lhs.id == rhs.id}
    
    let id: UUID
    
    @Published var name: String = "Default Recurring Task"
    
    class IdentifiableBool: Codable, Identifiable, ObservableObject {
        var id = UUID()
        var value = false
        
        func toggle() {
            value.toggle()
            objectWillChange.send()
        }
        
        init(value: Bool) {self.value = value}
        init(){}
    }
    
    @Published var days = [IdentifiableBool]()
    
    enum Key: CodingKey {
        case name, days, id
    }
    init() {
        self.id = UUID()
        for _ in 0..<5 {
            days.append(.init())
        }
    }
    
    func rangeIncrementable() -> Bool {days.count < 14}
    func incrementRange() {
        days.append(.init())
    }
    
    func rangeDecrementable() -> Bool {days.count > 1}
    func decrementRange() {
        _ = days.popLast()
    }
    
    func appliesToCurrentDay() -> Bool {
        return days[appManager.currentDayIndex % days.count].value
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        
        name = try container.decode(String.self, forKey: .name)
        days = try container.decode([IdentifiableBool].self, forKey: .days)
        id = try container.decode(UUID.self, forKey: .id)
    }
        
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)

        try container.encode(name, forKey: .name)
        try container.encode(days, forKey: .days)
        try container.encode(id, forKey: .id)
    }
}
