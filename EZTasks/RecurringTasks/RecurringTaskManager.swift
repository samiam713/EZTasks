//
//  RecurringTasks.swift
//  EZTasks
//
//  Created by Samuel Donovan on 7/10/20.
//  Copyright © 2020 Samuel Donovan. All rights reserved.
//

import Foundation

let recurringTaskManager = RecurringTaskManager.load()
class RecurringTaskManager: ObservableObject, Codable {
    static let url = fileSystem.documentsURL.appendingPathComponent("recurringTaskManager",isDirectory: false).appendingPathExtension("json")
    static func load() -> RecurringTaskManager {
        let rtm = FileManager.default.fileExists(atPath: url.path) ? fileSystem.load(this: RecurringTaskManager.self, from: url) : .init()
        rtm.dealWithNewDay()
        return rtm
    }
    
    var todaysTasks = [RecurringTask]()
    var recurringTaskPlans = [RecurringTaskPlan]()
    var lastDayUpdated = appManager.currentDayIndex
    
    func refresh() {objectWillChange.send()}
    
    init() {}
    
    func save() {
        fileSystem.save(this: self, to: Self.url)
    }
    
    func addRecurringTaskPlan() {
        recurringTaskPlans.append(.init())
        refresh()
    }
    
    func removeRecurringTaskPlan(plan: RecurringTaskPlan) {
        recurringTaskPlans.remove(at: recurringTaskPlans.firstIndex(of: plan)!)
        refresh()
    }
    
    func completeRecurringTask(recurringTask: RecurringTask) {
        todaysTasks.remove(at: todaysTasks.firstIndex(of: recurringTask)!)
        refresh()
    }
    
    func dealWithNewDay() {
        if appManager.currentDayIndex > lastDayUpdated {
            resetTodaysTasks()
            lastDayUpdated = appManager.currentDayIndex
            refresh()
        }
    }
    
    func resetTodaysTasks() {
        todaysTasks.removeAll(keepingCapacity: true)
        for task in recurringTaskPlans {
            if task.appliesToCurrentDay() {
                todaysTasks.append(.init(name: task.name))
            }
        }
    }
    
    enum Key: CodingKey {
        case todaysTasks, recurringTaskPlans, lastDayUpdated
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        todaysTasks = try container.decode([RecurringTask].self, forKey: .todaysTasks)
        recurringTaskPlans = try container.decode([RecurringTaskPlan].self, forKey: .recurringTaskPlans)
        lastDayUpdated = try container.decode(Int.self, forKey: .lastDayUpdated)
    }
        
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        try container.encode(todaysTasks, forKey: .todaysTasks)
        try container.encode(recurringTaskPlans, forKey: .recurringTaskPlans)
        try container.encode(lastDayUpdated, forKey: .lastDayUpdated)
    }
}

