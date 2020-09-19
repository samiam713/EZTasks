//
//  RTTodayPlanManipulator.swift
//  EZTasks
//
//  Created by Samuel Donovan on 9/13/20.
//  Copyright © 2020 Samuel Donovan. All rights reserved.
//

import SwiftUI

struct RecurringTaskTodayPlanManipulator: View {
    @ObservedObject var recurringTaskManager: RecurringTaskManager
    var body: some View {
        List(recurringTaskManager.todaysTasks) {(task: RecurringTask) in
            RecurringTaskManipulator(task: task)
        }
    }
}

struct RecurringTaskManipulator: View {
    let task: RecurringTask
    var body: some View {
        HStack {
            Text(task.name)
            Spacer()
            Button("Complete") {
                recurringTaskManager.completeRecurringTask(recurringTask: self.task)
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10)
        .foregroundColor(.white))
    }
}

//struct RTTodayPlanManipulator_Previews: PreviewProvider {
//    static var previews: some View {
//        RTTodayPlanManipulator()
//    }
//}
