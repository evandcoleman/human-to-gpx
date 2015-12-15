//
//  NSDate+ISO8601.swift
//  human-to-gpx
//
//  Created by Evan Coleman on 12/13/15.
//  Copyright © 2015 Evan Coleman. All rights reserved.
//

import Foundation

extension NSDate {
    struct Date {
        static let formatter = NSDateFormatter()
    }
    var iso8601: String {
        Date.formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSX"
        Date.formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        Date.formatter.calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierISO8601)!
        Date.formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        return Date.formatter.stringFromDate(self)
    }
}