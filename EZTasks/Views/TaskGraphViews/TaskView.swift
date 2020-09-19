//
//  TaskManipulator.swift
//  EZTasks
//
//  Created by Samuel Donovan on 7/10/20.
//  Copyright © 2020 Samuel Donovan. All rights reserved.
//

import SwiftUI

struct TaskView: View {
    
    @ObservedObject var task: ActiveTask
    @ObservedObject var taskGraph: TaskGraph
    
    var body: some View {
        VStack {
            TextField("Name", text: $task.name)
            if task.usesDate {
                DatePicker(selection: $task.dueDate, in: PartialRangeFrom<Date>(taskGraph.lastDate), label: {
                    Text("Done by:")
                })
                if task.getDaysUntilCompletion() < 1 {
                    Text("\(task.getHoursUntilCompletion()) hours left")
                } else {
                    Text("\(task.getDaysUntilCompletion()) days left")
                }
            }
            Button("\(task.usesDate ? "Stop" : "Start") using date", action: {self.task.usesDate.toggle()})
            if taskGraph.hasSelection() {
                if taskGraph.unsafeGetSelection() == task {
                    Button("Unselect", action: taskGraph.unselect)
                } else if taskGraph.unsafeGetSelection().children.contains(task.id) {
                    Button("Remove Dependency", action: {self.taskGraph.removeDependency(parent: self.taskGraph.unsafeGetSelection(), child: self.task)})
                } else if !taskGraph.unsafeGetCycleCausers().contains(task) {
                    Button("Add Dependency", action: {self.taskGraph.addDependency(parent: self.taskGraph.unsafeGetSelection(), child: self.task)})
                }
            } else {
                Button("Edit Dependencies", action: {self.taskGraph.editDependencies(task: self.task)})
            }
            if task.completable() {
                Button("Complete Task", action: {self.taskGraph.complete(task: self.task)})
            }
            Button("🗑") {
                self.taskGraph.delete(task: self.task)
            }
        }
        .foregroundColor(.black)
        .padding()
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
                RoundedRectangle(cornerRadius: 10)
                    .stroke(lineWidth: 3)
                    .fill(Color.black)
            }
        )
            .padding()
    }
}

//struct TaskManipulator_Previews: PreviewProvider {
//    static var previews: some View {
//        TaskView(task: .init(), taskGraph: taskGraph)
//    }
//}
