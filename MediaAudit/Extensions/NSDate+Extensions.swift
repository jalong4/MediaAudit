//
//  NSDate+Extensions.swift
//  go90
//
//  Created by Ollie Wagner on 12/3/15.
//  Copyright © 2015 Verizon Media LLC. All rights reserved.
//

import Foundation

func <=(lhs: NSDate, rhs: NSDate) -> Bool {
	return lhs.timeIntervalSince1970 <= rhs.timeIntervalSince1970
}

func >=(lhs: NSDate, rhs: NSDate) -> Bool {
	return lhs.timeIntervalSince1970 >= rhs.timeIntervalSince1970
}

func >(lhs: NSDate, rhs: NSDate) -> Bool {
	return lhs.timeIntervalSince1970 > rhs.timeIntervalSince1970
}

func <(lhs: NSDate, rhs: NSDate) -> Bool {
	return lhs.timeIntervalSince1970 < rhs.timeIntervalSince1970
}

func ==(lhs: NSDate, rhs: NSDate) -> Bool {
	return lhs.timeIntervalSince1970 == rhs.timeIntervalSince1970
}

extension NSDate {
	
	func timeSinceStringCondensed() -> String {
		
		var ti = -Int(timeIntervalSinceNow)
		
		let secs = ti
		ti = ti/60
		let minutes = ti % 60;
		ti = ti/60
		let hours = ti % 24;
		ti = ti/24
		let days = ti;
		ti = ti/7;
		let weeks = ti;
		
		var timeSinceString = ""
		
		if weeks > 1 {
			timeSinceString = String(format: NSLocalizedString("%d wks", tableName: "Utilities", comment: ""), weeks)
		} else if weeks == 1 {
			timeSinceString = NSLocalizedString("1 wk", tableName: "Utilities", comment: "")
		} else if days > 1 {
			timeSinceString = String(format: NSLocalizedString("%d days", tableName: "Utilities", comment: ""), days)
		} else if days == 1	{
			timeSinceString = NSLocalizedString("1 day", tableName: "Utilities", comment: "")
		} else if hours > 1 {
			timeSinceString = String(format: NSLocalizedString("%d hrs", tableName: "Utilities", comment: ""), hours)
		} else if hours == 1 {
			timeSinceString = NSLocalizedString("1 hr", tableName: "Utilities", comment: "")
		} else if minutes > 1 {
			timeSinceString = String(format: NSLocalizedString("%d mins", tableName: "Utilities", comment: ""), minutes)
		}	else if minutes == 1 {
			timeSinceString = NSLocalizedString("1 min", tableName: "Utilities", comment: "")
		} else if secs == 1 {
			timeSinceString = NSLocalizedString("1 sec", tableName: "Utilities", comment: "")
		} else if secs > 1 {
			timeSinceString = String(format: NSLocalizedString("%d secs", tableName: "Utilities", comment: ""), secs)
		}
		return timeSinceString
	}
	
	class func currentTimeMilliseconds() -> Int64 {
		
		return Int64(NSDate().timeIntervalSince1970 * 1000)
	}
}
