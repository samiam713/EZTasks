//
//  TaskStore.swift
//  EZTasks
//
//  Created by Samuel Donovan on 7/10/20.
//  Copyright © 2020 Samuel Donovan. All rights reserved.
//

import Foundation

var vocationalTaskGraph: TaskGraph! = TaskGraph.load("vocation")
let educationalTaskGraph = TaskGraph.load("education")
let lovingTaskGraph = TaskGraph.load("loving")

class TaskGraph: ObservableObject, Codable {
    static func url(type: String) -> URL {fileSystem.documentsURL.appendingPathComponent(type,isDirectory: false).appendingPathExtension("json")}
    static func load(_ type: String) -> TaskGraph {
        let url = Self.url(type: type)
        return FileManager.default.fileExists(atPath: url.path) ? fileSystem.load(this: TaskGraph.self, from: url) : .init(type: type, url: url)
    }
    
    var lastDate = Date()
    
    var tasks = [ActiveTask]()
    var taskLookup = [UUID:ActiveTask]()
    
    @Published var currentlySelected: (task: ActiveTask, cycleCausers: Set<ActiveTask>)?
    
    var taskDrawData = [[ActiveTask]]()
    var widthBound = 0
    var heightBound = 0
    
    let type: String
    let url: URL
    
    init(type: String, url: URL) {
        self.type = type
        self.url = url
    }
    
    func getDescription() -> String {
        switch type {
        case "vocation":
            return "Tasks that have to do with your life calling"
        case "education":
            return "Tasks that have to do with you knowing more things"
        case "loving":
            return "Tasks that our all-knowing, all-powerful, all-loving Creator would be happy you completed"
        default:
            fatalError()
        }
    }
    
    func save() {
        fileSystem.save(this: self, to: url)
    }
        
    func getDX(frameWidth: CGFloat) -> CGFloat {
        return frameWidth/CGFloat(widthBound)
    }
    
    func getDY(frameHeight: CGFloat) -> CGFloat {
        return frameHeight/CGFloat(heightBound)
    }
    
    func getTask(forID: UUID) -> ActiveTask {taskLookup[forID]!}
    
    func addTask() {
        
        defer {updatePositionsThenRefresh()}
        
        let newTask = ActiveTask(taskGraph: self)
        
        tasks.append(newTask)
        taskLookup[newTask.id] = newTask
        
    }
    
    func delete(task: ActiveTask) {
        
        defer {updatePositionsThenRefresh()}
        
        tasks.remove(at: tasks.firstIndex(of: task)!)
        taskLookup[task.id] = nil
        if isCurrentlySelected(task: task) {
            currentlySelected = nil
        }
        
        let parents = task.getParents()
        for parent in parents {
            removeDependency(parent: parent, child: task)
            parent.updateLevelsRecursivelyAfterDeletion()
        }
        
        let children = task.getChildren()
        for child in children {
            removeDependency(parent: task, child: child)
        }
    }
    
    func complete(task: ActiveTask) {
        taskHistory.addCompleted(task: task)
        delete(task: task)
    }
    
    func addDependency(parent: ActiveTask, child: ActiveTask) {
        parent.children.insert(child.id)
        child.parents.insert(parent.id)
        parent.updateLevelsRecursivelyAfterAddition(childHasHeight: child.height)
        unselect()
        updatePositionsThenRefresh()
    }
    
    func removeDependency(parent: ActiveTask, child: ActiveTask) {
        parent.children.remove(child.id)
        child.parents.remove(parent.id)
        parent.updateLevelsRecursivelyAfterDeletion()
        unselect()
        updatePositionsThenRefresh()
    }
    
    func editDependencies(task: ActiveTask) {
        currentlySelected = (task: task, cycleCausers: task.generateCycleCausers())
    }
    
    func unselect() {currentlySelected = nil}
    
    func hasSelection() -> Bool {currentlySelected != nil}
    func unsafeGetSelection() -> ActiveTask {currentlySelected!.task}
    func unsafeGetCycleCausers() -> Set<ActiveTask> {currentlySelected!.cycleCausers}
    
    func isCurrentlySelected(task: ActiveTask) -> Bool {
        guard let current = currentlySelected else {return false}
        return current.task == task
    }
    
    func updatePositionsThenRefresh() {
        defer {refreshView()}
        if tasks.count == 0 {
            taskDrawData = []
            widthBound = 0
            heightBound = 0
            return
        }
        var maxHeight = 0
        for task in tasks {
            if task.height > maxHeight {
                maxHeight = task.height
            }
        }
        
        heightBound = maxHeight + 1
        taskDrawData = [[ActiveTask]].init(repeating: [], count: heightBound)
        for task in tasks {
            taskDrawData[task.height].append(task)
        }
        
        widthBound = 0
        for array in taskDrawData {
            if array.count > widthBound {
                widthBound = array.count
            }
        }
    }
    
    func refreshView() {
        lastDate = Date()
        
        objectWillChange.send()
    }
    
    enum Key: String, CodingKey {
        case taskLookup
        case type
        case url
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        
        taskLookup = try container.decode([UUID:ActiveTask].self, forKey: .taskLookup)
        type = try container.decode(String.self, forKey: .type)
        url = try container.decode(URL.self, forKey: .url)
        
        for task in taskLookup.values {
            task.taskGraph = self
        }
        
        tasks = taskLookup.values.map() {$0}
        
        currentlySelected = nil
        lastDate = Date()
        updatePositionsThenRefresh()
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        try container.encode(taskLookup, forKey: .taskLookup)
        try container.encode(type, forKey: .type)
        try container.encode(url, forKey: .url)
    }
}

// I want (to be in a state where I can create)∧(to actually have created) sequences of symbols that can be decoded into objects like proofs/statements
// I want to keep myself in states I enjoy as much as possible (while still staying grounded in my origins)
