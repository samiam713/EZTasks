//
//  RecurringTaskPlansManipulator.swift
//  EZTasks
//
//  Created by Samuel Donovan on 9/13/20.
//  Copyright © 2020 Samuel Donovan. All rights reserved.
//

import SwiftUI

struct RecurringTaskPlansManipulator: View {
    @ObservedObject var recurringTaskManager: RecurringTaskManager
    var body: some View {
        List {
            ForEach(recurringTaskManager.recurringTaskPlans, content: {(todayTask: RecurringTaskPlan) in
                RecurringTaskPlanManipulator(recurringTaskPlan: todayTask)
            })
            HStack {
                Spacer()
                Button("Add Daily Task", action: recurringTaskManager.addRecurringTaskPlan)
                Spacer()
            }
        }
    }
}

struct RecurringTaskPlansManipulator_Previews: PreviewProvider {
    static var previews: some View {
        RecurringTaskPlansManipulator(recurringTaskManager: .init())
    }
}
