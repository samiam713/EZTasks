//
//  Task.swift
//  EZTasks
//
//  Created by Samuel Donovan on 7/10/20.
//  Copyright © 2020 Samuel Donovan. All rights reserved.
//

import Foundation
import SwiftUI

class ActiveTask: Identifiable, Codable, Hashable, ObservableObject  {
    
    static func == (lhs: ActiveTask, rhs: ActiveTask) -> Bool {lhs.id == rhs.id}
    
    var id = UUID()
    
    @Published var name: String = "Default Task"
    @Published var dueDate = Date()
    @Published var usesDate = false
    
    var parents = Set<UUID>()
    var children = Set<UUID>()
    var height = 0
    
    unowned var taskGraph: TaskGraph! = nil
    
    init(taskGraph: TaskGraph){
        self.taskGraph = taskGraph
    }
    
    func getCenter(proxy: GeometryProxy) -> CGPoint {
        let dx = taskGraph.getDX(frameWidth: proxy.size.width)
        let dy = taskGraph.getDY(frameHeight: proxy.size.height)
        let x = dx/2 + CGFloat(getWidth())*dx
        let y = dy/2 + CGFloat(height)*dy
        return .init(x: x, y: proxy.size.height - y)
    }
        
    func hash(into hasher: inout Hasher) {hasher.combine(id)}
    
    func getParents() -> [ActiveTask] {parents.map({taskGraph.getTask(forID: $0)})}
    func getChildren() -> [ActiveTask] {children.map({taskGraph.getTask(forID: $0)})}
    
    func getWidth() -> Int {
        let levelDrawData = taskGraph.taskDrawData[height]
        return levelDrawData.firstIndex(of: self)!
    }
    
    func getHoursUntilCompletion() -> Int {
        let secondsLeft: Double = appManager.now.distance(to: dueDate)
        return Int(secondsLeft/secondsPerHour)
    }
    func getDaysUntilCompletion() -> Int {
        let secondsLeft: Double = appManager.now.distance(to: dueDate)
        return Int(secondsLeft/secondsPerDay)
    }
    
    func updateLevelsRecursivelyAfterAddition(childHasHeight: Int) {
        if height <= childHasHeight {
            height = childHasHeight + 1
            for parent in getParents() {
                parent.updateLevelsRecursivelyAfterAddition(childHasHeight: height)
            }
        }
    }
    
    func completable() -> Bool {children.count == 0}
    
    private func generateCycleCausersUtility(currentCycleCausers: inout Set<ActiveTask>) {
        for parent in getParents() {
            let (inserted,_) = currentCycleCausers.insert(parent)
            if inserted {
                parent.generateCycleCausersUtility(currentCycleCausers: &currentCycleCausers)
            }
        }
    }
    
    func generateCycleCausers() -> Set<ActiveTask> {
        var cycleCausers = Set<ActiveTask>()
        
        for parent in getParents() {
            cycleCausers.insert(parent)
            parent.generateCycleCausersUtility(currentCycleCausers: &cycleCausers)
        }
        
        return cycleCausers
    }
    
    func updateLevelsRecursivelyAfterDeletion() {
        if children.count == 0 {
            height = 0
            getParents().forEach({$0.updateLevelsRecursivelyAfterDeletion()})
            return
        }
        
        let children = getChildren()
        var maxHeight = 0
        for child in children {
            if child.height > maxHeight {
                maxHeight = child.height
            }
        }
        
        let calculatedHeight = maxHeight + 1
        
        if calculatedHeight != height {
            height = calculatedHeight
            getParents().forEach({$0.updateLevelsRecursivelyAfterDeletion()})
        }
    }
    
    enum Key: CodingKey {
        case id, name, dueDate, usesDate, parents, children, height
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .id)
        dueDate = try container.decode(Date.self, forKey: .dueDate)
        usesDate = try container.decode(Bool.self, forKey: .usesDate)
        parents = try container.decode(Set<UUID>.self, forKey: .parents)
        children = try container.decode(Set<UUID>.self, forKey: .children)
        height = try container.decode(Int.self, forKey: .height)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(dueDate, forKey: .dueDate)
        try container.encode(usesDate, forKey: .usesDate)
        try container.encode(parents, forKey: .parents)
        try container.encode(children, forKey: .children)
        try container.encode(height, forKey: .height)
    }
}
