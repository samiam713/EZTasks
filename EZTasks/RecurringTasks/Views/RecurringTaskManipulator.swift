//
//  RecurringTaskManipulator.swift
//  EZTasks
//
//  Created by Samuel Donovan on 7/11/20.
//  Copyright © 2020 Samuel Donovan. All rights reserved.
//

import SwiftUI

struct RecurringTaskPlanManipulator: View {
    let recurringTask: RecurringTask
    @State var ph = "Hello"
    
    var body: some View {
        VStack {
            TextField("Name:", text: $placeHolder)
                .foregroundColor(.black)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12))
        .foregroundColor(.blue)
    }
}


struct RecurringTaskManipulator_Previews: PreviewProvider {
    static var previews: some View {
        RecurringTaskPlanManipulator(recurringTask: .init())
    }
}
