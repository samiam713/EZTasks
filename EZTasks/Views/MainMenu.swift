//
//  MainMenu.swift
//  EZTasks
//
//  Created by Samuel Donovan on 7/11/20.
//  Copyright © 2020 Samuel Donovan. All rights reserved.
//

import SwiftUI

struct MainMenu: View {
    var body: some View {
        VStack {
            VStack {
                Text("THE CLOCK IS TICKING!")
                    .font(.largeTitle)
                Text("\(appManager.now.toShortDate()) (Day \(appManager.currentDayIndex))")
                    .italic()
            }
            .padding()
            .foregroundColor(.black)
            .background(RoundedRectangle(cornerRadius: 20).foregroundColor(.white))
            TabView {
                TaskGraphView(taskGraph: vocationalTaskGraph)
                    .foregroundColor(.black)
                    .tabItem {
                        Text("Vocational Tasks")
                    }
                TaskGraphView(taskGraph: educationalTaskGraph)
                    .foregroundColor(.black)
                    .tabItem {
                        Text("Educational Tasks")
                    }
                TaskGraphView(taskGraph: lovingTaskGraph)
                    .foregroundColor(.black)
                    .tabItem {
                        Text("Loving Tasks")
                    }
                HStack {
                    RecurringTaskPlansManipulator(recurringTaskManager: recurringTaskManager)
                    Divider()
                    RecurringTaskTodayPlanManipulator(recurringTaskManager: recurringTaskManager)
                    Divider()
                    TaskHistoryView(taskHistory: taskHistory)
                }
                .tabItem {
                    Text("Daily Tasks")
                }
            }
        }
    }
}

struct MainMenu_Previews: PreviewProvider {
    static var previews: some View {
        MainMenu()
    }
}

