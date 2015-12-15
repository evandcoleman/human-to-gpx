//
//  main.swift
//  human-to-gpx
//
//  Created by Evan Coleman on 12/13/15.
//  Copyright © 2015 Evan Coleman. All rights reserved.
//

import Foundation

let opts = Args.parsed.flags

let directory = opts["d"]
let file = opts["f"]
let output = opts["o"]

if directory == nil && file == nil {
    print("Usage:".f.Blue)
    print("  Specify a Human JSON file: -f <path>".f.Magenta)
    print("  Specify a Human archive folder: -d <path>".f.Magenta)
    print("  Optionally specify an output directory with (otherwise the current directory is used): -o <path>".f.Magenta)
    
    exit(0)
} else if directory != nil && file != nil {
    print("You can only specify an archive directory or file path. Not both.".f.Red)
    
    exit(0)
}

func processFile(path: String) -> String? {
    guard let fileData = NSData(contentsOfFile: path) else {
        print("Could not read file at path \(path)".f.Red)
        return nil
    }

    guard let data = try? NSJSONSerialization.JSONObjectWithData(fileData, options: []) else {
        print("Could not parse file at path \(path)".f.Red)
        return nil
    }
    
    guard let points = data["location_data"] as? [Dictionary<String, AnyObject>] else {
        print("Could not parse location data for file at path \(path)".f.Red)
        return nil
    }
    
    var output = "<gpx version=\"1.1\" xmlns=\"http://www.topografix.com/GPX/1/1\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:schemaLocation=\"http://www.topografix.com/GPX/1/1 http://www.topografix.com/GPX/1/1/gpx.xsd http://www.garmin.com/xmlschemas/GpxExtensions/v3 http://www.garmin.com/xmlschemas/GpxExtensionsv3.xsd http://www.garmin.com/xmlschemas/TrackPointExtension/v1 http://www.garmin.com/xmlschemas/TrackPointExtensionv1.xsd\" xmlns:gpxtpx=\"http://www.garmin.com/xmlschemas/TrackPointExtension/v1\" xmlns:gpxx=\"http://www.garmin.com/xmlschemas/GpxExtensions/v3\"><metadata><time>2015-12-13T17:52:36Z</time></metadata><trk><trkseg>"
    
    for point in points {
        guard let lat = point["la"] as? Double else {
            print("Could not parse latitude coordinate for file at path \(path)".f.Red)
            return nil
        }
        guard let long = point["lo"] as? Double else {
            print("Could not parse longitude coordinate for file at path \(path)".f.Red)
            return nil
        }
        guard let alt = point["al"] as? Double else {
            print("Could not parse altitude for file at path \(path)".f.Red)
            return nil
        }
        guard let ts = point["da"] as? Double else {
            print("\(point)")
            print("Could not parse timestamp for file at path \(path)".f.Red)
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
}

// MARK: Main Stuff

if let d = directory {
    
} else if let f = file {
    guard let gpxString = processFile(f) else {
        exit(0)
    }
    
    var outputDirectory = NSFileManager.defaultManager().currentDirectoryPath as NSString
    if let o = output {
        outputDirectory = o
    }
    let outputPath = outputDirectory.stringByAppendingPathComponent(((f as NSString).stringByDeletingPathExtension as NSString).lastPathComponent) + ".gpx"
    
    do {
        try gpxString.writeToFile(outputPath, atomically: true, encoding: NSUTF8StringEncoding)
        
        print("File successfully saved to \(outputPath)".f.Green)
    }
    catch {
        print("\(error)".f.Red)
    }
}
