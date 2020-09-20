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
    
    let window: NSWindow
    let styleMask: NSWindow.StyleMask = [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView]
    
    let frame = NSScreen.main!.frame
    
    init() {
        self.window = NSWindow(
            contentRect: frame,
            styleMask: styleMask,
            backing: .buffered, defer: false)
        
        self.now = Date()
        let timeInterval = Self.day0.distance(to: now)
        self.currentDayIndex = Int(timeInterval/secondsPerDay)
    }

    func toView<T:View>(view: T) {
        window.contentViewController = NSHostingController(rootView: view.frame(minWidth: frame.width, minHeight: frame.height*0.9))
    }
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var window: NSWindow!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        appManager = .init()
        window = appManager.window
        window.setFrameAutosaveName("Main Window")
        window.isReleasedWhenClosed = false
        window.center()
        appManager.toView(view: MainMenu())
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
