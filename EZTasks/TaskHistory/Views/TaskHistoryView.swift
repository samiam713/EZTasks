//
//  InactiveTaskView.swift
//  EZTasks
//
//  Created by Samuel Donovan on 9/7/20.
//  Copyright © 2020 Samuel Donovan. All rights reserved.
//

import SwiftUI

struct TaskHistoryView: View {
    
    @ObservedObject var taskHistory: TaskHistory
    
    var body: some View {
        List(1..<(TaskHistory.tasksPerPage+1)) {(index: Int) in
            if self.taskHistory.screenIndexToInactiveTask(oneThroughTasksPerPage: index) != nil {
                InactiveTaskView(inactiveTask: self.taskHistory.screenIndexToInactiveTask(oneThroughTasksPerPage: index)!)
            } else {
                EmptyView()
            }
        }
    }
}

struct InactiveTaskView: View {
    let inactiveTask: InactiveTask
    
    var body: some View {
        HStack {
            Text("\(inactiveTask.name) completed at \(inactiveTask.completionDate)")
            Spacer()
            Button.init("🗑", action: {
                taskHistory.removeTask(inactiveTask: self.inactiveTask)
            })
        }
    .padding()
    .background(RoundedRectangle(cornerRadius: 10)
    .foregroundColor(.gray))
    }
}

//struct InactiveTaskView_Previews: PreviewProvider {
//    static var previews: some View {
//        InactiveTaskView()
//    }
//}
