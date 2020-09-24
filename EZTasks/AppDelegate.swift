//
//  AppDelegate.swift
//  EZTasks
//
//  Created by Samuel Donovan on 7/10/20.
//  Copyright © 2020 Samuel Donovan. All rights reserved.
//

import Cocoa
import SwiftUI

let secondsPerHour: Double = 60*60
let secondsPerDay: Double = 24*secondsPerHour

var appManager: AppManager! = nil
class AppManager {
    
    static let aug_2_2020_1200AM_PT_encoded = "618044400"
    static let day0 = try! fileSystem.decoder.decode(Date.self, from: aug_2_2020_1200AM_PT_encoded.data(using: .utf8)!)
    
    let currentDayIndex: Int
    let now: Date
        
    init() {
        self.now = Date()
        let timeInterval = Self.day0.distance(to: now)
        self.currentDayIndex = Int(timeInterval/secondsPerDay)
    }
}

var windowReference: NSWindow! = nil
func toView<T:View>(_ view: T) {
    windowReference.contentView = NSHostingView(rootView: view.frame(maxWidth: .infinity, maxHeight: .infinity))
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var window: NSWindow!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        appManager = .init()

        // Create the window and set the content view.
        window = NSWindow(
            contentRect: NSScreen.main!.visibleFrame,
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        window.isReleasedWhenClosed = false
        window.center()
        window.setFrameAutosaveName("Main Window")
        windowReference = window
        toView(MainMenu())
        window.makeKeyAndOrderFront(nil)
    
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        recurringTaskManager.save()
        vocationalTaskGraph.save()
        educationalTaskGraph.save()
        lovingTaskGraph.save()
        taskHistory.save()
    }

}
