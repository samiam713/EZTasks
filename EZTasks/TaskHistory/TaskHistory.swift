//
//  TaskHistory.swift
//  EZTasks
//
//  Created by Samuel Donovan on 9/7/20.
//  Copyright © 2020 Samuel Donovan. All rights reserved.
//

import Foundation

let taskHistory = TaskHistory.load()
class TaskHistory: Codable, ObservableObject {
    static let tasksPerPage = 20

    static let url = fileSystem.documentsURL.appendingPathComponent("TaskHistory",isDirectory: false).appendingPathExtension("json")
    static func load() -> TaskHistory {
        return FileManager.default.fileExists(atPath: url.path) ? fileSystem.load(this: TaskHistory.self, from: url) : .init()
    }
    
    @Published var history = [InactiveTask]()
    @Published var viewingPage = 0
    
    init(){}
    func save() {
        fileSystem.save(this: self, to: Self.url)
    }
    
    func numPages() -> Int {
        (history.count-1)/Self.tasksPerPage + 1
    }
    
    func pageIncrementable() -> Bool {viewingPage < numPages() - 1}
    func incrementPage() {viewingPage+=1}
    
    func pageDecrementable() -> Bool {viewingPage > 0}
    func decrementPage() {viewingPage-=1}
    
    func addCompleted(task: ActiveTask) {history.append(.init(activeTask: task))}
    
    func removeTask(inactiveTask: InactiveTask) {
        history.remove(at: history.firstIndex(of: inactiveTask)!)
        if viewingPage == numPages() {
            viewingPage-=1
        }
    }
    
    func screenIndexToInactiveTask(oneThroughTasksPerPage: Int) -> InactiveTask? {
        let index = history.count - TaskHistory.tasksPerPage*viewingPage - oneThroughTasksPerPage
        guard history.indices.contains(index) else {return nil}
        return history[history.count - TaskHistory.tasksPerPage*viewingPage - oneThroughTasksPerPage]
    }
    
    enum Key: CodingKey {
        case history
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        history = try container.decode([InactiveTask].self, forKey: .history)
        viewingPage = 0
    }
        
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        try container.encode(history, forKey: .history)
    }

    
}
