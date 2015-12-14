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

if directory == nil && file == nil {
    print("Usage:\n".f.Blue)
    print("  Specify a Human JSON file: -f <path>\n".f.Blue)
    print("  Specify a Human archive folder: -d <path>\n".f.Yellow)
    
    exit(0)
} else if directory != nil && file != nil {
    print("You can only specify an archive directory or file path. Not both.".f.Red)
    
    exit(0)
}

