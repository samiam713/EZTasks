//
//  TaskStoreBackground.swift
//  EZTasks
//
//  Created by Samuel Donovan on 9/5/20.
//  Copyright © 2020 Samuel Donovan. All rights reserved.
//

import SwiftUI

struct TaskGraphBackground: View {
    
    let proxy: GeometryProxy
    let taskGraph: TaskGraph
    
    func getTrianglePoints(parentCenter: CGPoint, childCenter: CGPoint) -> [CGPoint] {
        let dx = childCenter.x - parentCenter.x
        let dy = childCenter.y - parentCenter.y
        
        let vectorMag = sqrt(dx*dx+dy*dy)
        var orthodx = -dy
        var orthody = dx
        
        orthodx = (orthodx*20)/vectorMag
        orthody = (orthody*20)/vectorMag
        
        let nearParent1 = CGPoint(x: parentCenter.x + orthodx, y: parentCenter.y + orthody)
        let nearParent2 = CGPoint(x: parentCenter.x - orthodx, y: parentCenter.y - orthody)
        
        return [nearParent1,nearParent2,childCenter,nearParent1]
    }
    
    var body: some View {
        Path {(path: inout Path) in
            for task in taskGraph.tasks {
                let parents = task.getParents()
                for parent in parents {
                    let parentCenter = parent.getCenter(proxy: proxy)
                    let childCenter = task.getCenter(proxy: proxy)
                    
                    let trianglePoints = getTrianglePoints(parentCenter: parentCenter, childCenter: childCenter)
                    
                    path.move(to: trianglePoints.last!)
                    path.addLines(trianglePoints)
                }
            }
        }
        .strokedPath(.init())
        .foregroundColor(.blue)
    }
}

//struct TaskStoreBackground_Previews: PreviewProvider {
//    static var previews: some View {
//        TaskGraphBackground()
//    }
//}
