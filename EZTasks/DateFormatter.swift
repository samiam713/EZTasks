//
//  DateFormatter.swift
//  EZTasks
//
//  Created by Samuel Donovan on 9/7/20.
//  Copyright © 2020 Samuel Donovan. All rights reserved.
//

import Foundation

extension Date {
    
    static var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = "MMMM dd, yyyy"
        formatter.timeZone = try! JSONDecoder().decode(TimeZone.self, from: "{\"identifier\":\"America\\/Los_Angeles\"}".data(using: .utf8)!)
        return formatter
    }
    
    func toShortDate() -> String {
        Self.formatter.string(from: self)
    }
}
