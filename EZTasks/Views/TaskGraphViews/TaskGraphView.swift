//
//  TaskStoreManipulator.swift
//  EZTasks
//
//  Created by Samuel Donovan on 7/10/20.
//  Copyright © 2020 Samuel Donovan. All rights reserved.
//

import SwiftUI

struct TaskGraphView: View {
    
    @ObservedObject var taskGraph: TaskGraph
    
    var body: some View {
        VStack {
            Text(taskGraph.getDescription()).italic()
            .foregroundColor(.gray)
            GeometryReader {(proxy: GeometryProxy) in
                ZStack {
                    TaskGraphBackground(proxy: proxy, taskGraph: taskGraph)
                    ForEach(self.taskGraph.tasks) {(task: ActiveTask) in
                        TaskView(task: task, taskGraph: self.taskGraph)
                            .frame(width: min(self.taskGraph.getDX(frameWidth: proxy.size.width),proxy.size.width/4), height: min(self.taskGraph.getDY(frameHeight: proxy.size.height),proxy.size.height/4), alignment: .center)
                            .position(task.getCenter(proxy: proxy))
                    }
                }
                //                .fill(RadialGradient(gradient: .init(colors: [.white,.gray]), center: .center, startRadius: 0, endRadius: proxy.size.width))
            }
            HStack {
                Spacer()
                Button("Add Task", action: self.taskGraph.addTask)
                    .padding()
                Button("WTF", action: self.taskGraph.save)
                Spacer()
            }
        }
    }
}



//struct TaskStoreManipulator_Previews: PreviewProvider {
//    static var previews: some View {
//        TaskStoreManipulator()
//    }
//}
