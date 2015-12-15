//
//  archive.swift
//  human-to-gpx
//
//  Created by Evan Coleman on 12/14/15.
//  Copyright © 2015 Evan Coleman. All rights reserved.
//

import Foundation

struct Archive {
    let archivePath: String
    
    lazy var activities: [Activity] = {
        var paths: [String] = []
        do {
            paths = try NSFileManager.defaultManager().contentsOfDirectoryAtPath(self.archivePath)
        } catch {
            print("\(error)".f.Red)
            return []
        }
        
        var activities: [Activity] = []
        for path in paths {
            activities.append(Activity(path: (self.archivePath as NSString).stringByAppendingPathComponent(path)))
        }
        
        return activities
    }()
    
    init(path: String) {
        self.archivePath = (path as NSString).stringByAppendingPathComponent("activities/json")
    }
    
    mutating func description() -> String {
        var ret = ""
        
        for var activity in self.activities {
            if let dateString = activity.representativeDate {
                ret += "\(activity.name): \(dateString.formatted)\n".f.Green
            }
        }
        
        return ret
    }
}