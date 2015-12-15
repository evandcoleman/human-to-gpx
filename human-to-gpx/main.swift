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
    print("  Specify a Human archive folder to get information about its contents: -d <path>".f.Magenta)
    print("  Optionally specify an output directory with (otherwise the current directory is used): -o <path>".f.Magenta)
    
    exit(0)
} else if directory != nil && file != nil {
    print("You can only specify an archive directory or file path. Not both.".f.Red)
    
    exit(0)
}

// MARK: Main Stuff

if let d = directory {
    var archive = Archive(path: d)
    let description = archive.description()
    print("\(description)")
} else if let f = file {
    var activity = Activity(path: f)
    guard let gpxString = activity.gpx else {
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
