//
//  DateExtensions.swift
//  Prism
//
//  Created by Shiv Shah on 3/10/18.
//  Copyright © 2018 Satish Boggarapu. All rights reserved.
//

import Foundation

// Gets time in milliseconds
extension Date {
    func milliseconds() -> Int64! {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
    
    init(milliseconds: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
}


extension Date {
    func isBetween(_ date1: Date, and date2: Date) -> Bool {
        return (min(date1, date2) ... max(date1, date2)).contains(self)
    }
}

extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int64 {
        return Int64(Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0)
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int64 {
        return Int64(Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0)
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int64 {
        return Int64(Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0)
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int64 {
        return Int64(Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0)
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int64 {
        return Int64(Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0)
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int64 {
        return Int64(Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0)
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int64 {
        return Int64(Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0)
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return ""
    }
}
