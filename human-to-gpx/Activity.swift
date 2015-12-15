//
//  Activity.swift
//  human-to-gpx
//
//  Created by Evan Coleman on 12/14/15.
//  Copyright © 2015 Evan Coleman. All rights reserved.
//

import Foundation

struct Activity {
    let filePath: String
    let name: String
    
    lazy var points: [Dictionary<String, AnyObject>] = {
        guard let fileData = NSData(contentsOfFile: self.filePath) else {
            print("Could not read file at path \(self.filePath)".f.Red)
            return []
        }
        
        guard let data = try? NSJSONSerialization.JSONObjectWithData(fileData, options: []) else {
            print("Could not parse file at path \(self.filePath)".f.Red)
            return []
        }
        
        guard let points = data["location_data"] as? [Dictionary<String, AnyObject>] else {
            print("Could not parse location data for file at path \(self.filePath)".f.Red)
            return []
        }
        
        return points
    }()
    
    lazy var gpx: String? = {        
        var output = "<gpx version=\"1.1\" xmlns=\"http://www.topografix.com/GPX/1/1\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:schemaLocation=\"http://www.topografix.com/GPX/1/1 http://www.topografix.com/GPX/1/1/gpx.xsd http://www.garmin.com/xmlschemas/GpxExtensions/v3 http://www.garmin.com/xmlschemas/GpxExtensionsv3.xsd http://www.garmin.com/xmlschemas/TrackPointExtension/v1 http://www.garmin.com/xmlschemas/TrackPointExtensionv1.xsd\" xmlns:gpxtpx=\"http://www.garmin.com/xmlschemas/TrackPointExtension/v1\" xmlns:gpxx=\"http://www.garmin.com/xmlschemas/GpxExtensions/v3\"><metadata><time>2015-12-13T17:52:36Z</time></metadata><trk><trkseg>"
        
        for point in self.points {
            guard let lat = point["la"] as? Double else {
                print("Could not parse latitude coordinate for file at path \(self.filePath)".f.Red)
                return nil
            }
            guard let long = point["lo"] as? Double else {
                print("Could not parse longitude coordinate for file at path \(self.filePath)".f.Red)
                return nil
            }
            guard let alt = point["al"] as? Double else {
                print("Could not parse altitude for file at path \(self.filePath)".f.Red)
                return nil
            }
            guard let ts = point["da"] as? Double else {
                print("\(point)")
                print("Could not parse timestamp for file at path \(self.filePath)".f.Red)
                return nil
            }
            let dateString = NSDate(timeIntervalSince1970: ts).iso8601
            
            output += "<trkpt lat=\"\(lat)\" lon=\"\(long)\">"
            output += "<ele>\(alt)</ele>"
            output += "<time>\(dateString)</time>"
            output += "</trkpt>"
        }
        
        output += "</trkseg></trk></gpx>"
        
        return output
    }()
    
    lazy var representativeDate: NSDate? = {
        if self.points.count == 0 {
            return nil
        }
        
        let point = self.points[0]
        guard let ts = point["da"] as? Double else {
            return nil
        }
        
        return NSDate(timeIntervalSince1970: ts)
    }()
    
    init(path: String) {
        self.filePath = path
        self.name = (path as NSString).lastPathComponent
    }
}