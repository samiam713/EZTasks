//
//  RecurringTaskManipulator.swift
//  EZTasks
//
//  Created by Samuel Donovan on 7/11/20.
//  Copyright © 2020 Samuel Donovan. All rights reserved.
//

import SwiftUI

struct RecurringTaskPlanManipulator: View {
    @ObservedObject var recurringTaskPlan: RecurringTaskPlan
    
    var body: some View {
        HStack {
            VStack {
                TextField("Name", text: $recurringTaskPlan.name)
                Divider()
                HStack {
                    VStack {
                        if recurringTaskPlan.rangeDecrementable() {
                            Button(action: recurringTaskPlan.decrementRange) {
                                Text("Decrease Cycle Size")
                            }
                        }
                        if recurringTaskPlan.rangeIncrementable() {
                            Button(action: recurringTaskPlan.incrementRange) {
                                Text("Increase Cycle Size") // REPLACE ME WITH A IMAGE(SYSTEMNAME: )
                            }
                        }
                    }
                    Text("\(recurringTaskPlan.days.count) day\(recurringTaskPlan.days.count == 1 ? "" : "s") in cycle")
                }
                Divider()
                Button(action: {recurringTaskManager.removeRecurringTaskPlan(plan: self.recurringTaskPlan)}) {
                    Text("🗑").bold()
                }
                Spacer()
            }
            VStack {
                ForEach(recurringTaskPlan.days) {(day: RecurringTaskPlan.IdentifiableBool) in
                    DayTogglerView(day: day)
                }
            }
        }
        .foregroundColor(.black)
        .padding()
        .background(RoundedRectangle(cornerRadius: 10)
        .foregroundColor(.white)
        )
    }
}

struct DayTogglerView: View {
    @ObservedObject var day: RecurringTaskPlan.IdentifiableBool
    
    var body: some View {
        Button(day.value ? "Active" : "Inactive", action: day.toggle)
    }
}


struct RecurringTaskManipulator_Previews: PreviewProvider {
    static var previews: some View {
        RecurringTaskPlanManipulator(recurringTaskPlan: .init())
    }
}
