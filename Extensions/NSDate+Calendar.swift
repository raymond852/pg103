//
//  EPExtensions.swift
//  EPCalendar
//
//  Created by Prabaharan Elangovan on 29/11/15.
//  Copyright © 2015 Prabaharan Elangovan. All rights reserved.
//

import Foundation
import UIKit

// DateExt里面有重复定义
//internal func ==(lhs: NSDate, rhs: NSDate) -> Bool {
//    return lhs.compare(rhs) == NSComparisonResult.OrderedSame
//}
//
//internal func <(lhs: NSDate, rhs: NSDate) -> Bool {
//    return lhs.compare(rhs) == NSComparisonResult.OrderedAscending
//}
//
//internal func >(lhs: NSDate, rhs: NSDate) -> Bool {
//    return rhs.compare(lhs) == NSComparisonResult.OrderedAscending
//}

//MARK: NSDate Extensions

extension Date {
    
    func sharedCalendar(){
        
    }
    
    func firstDayOfMonth () -> Date {
        let calendar = Calendar.current
        var dateComponent = (calendar as NSCalendar).components([.year, .month, .day ], from: self)
        dateComponent.day = 1
        return calendar.date(from: dateComponent)!
    }
    
    func daysOfMonth() -> Int {
        var days = 30
        let month = self.month()
        let year = self.year()
        switch month {
        case 1, 3, 5, 7, 8, 10, 12:
            days = 31
        case 4, 6, 9, 11:
            days = 30
        case 2:
            // 能被4整除且不能被100整除
            // 能被100整除且能被400整除
            if (year%4 == 8 && year%100 != 0) || (year%100 == 0 && year%400 == 0) {
                days = 29
            } else {
                days = 28
            }
        default:
            days = 30
        }
        return days
    }
    
    func lastDayOfMonth() -> Date {
        var days = 30
        let month = self.month()
        let year = self.year()
        let calendar = Calendar.current
        var dateComponent = (calendar as NSCalendar).components([.year, .month, .day ], from: self)
        switch month {
        case 1, 3, 5, 7, 8, 10, 12:
            days = 31
        case 4, 6, 9, 11:
            days = 30
        case 2:
            // 能被4整除且不能被100整除
            // 能被100整除且能被400整除
            if (year%4 == 8 && year%100 != 0) || (year%100 == 0 && year%400 == 0) {
                days = 29
            } else {
                days = 28
            }
        default:
            days = 30
        }
        dateComponent.day = days
        return calendar.date(from: dateComponent)!
    }
    
    func dayOfMonth(_ day: Int) -> Date? {
        let maxDays = self.daysOfMonth()
        guard day > 0 && day <= maxDays else {
            let domain = "参数错误[1, " + String(maxDays) + "]"
            print(domain)
            return nil
        }
        let calendar = Calendar.current
        var dateComponent = (calendar as NSCalendar).components([.year, .month, .day ], from: self)
        dateComponent.day = Int(day)
        return calendar.date(from: dateComponent)!
    }
    
    init(year : Int, month : Int, day : Int) {
        let calendar = Calendar.current
        var dateComponent = DateComponents()
        dateComponent.year = year
        dateComponent.month = month
        dateComponent.day = day
        self.init(timeInterval:0, since:calendar.date(from: dateComponent)!)
    }
    
    func dateByAddingMonths(_ months : Int ) -> Date {
        let calendar = Calendar.current
        var dateComponent = DateComponents()
        dateComponent.month = months
        return (calendar as NSCalendar).date(byAdding: dateComponent, to: self, options: NSCalendar.Options.matchNextTime)!
    }
    
    func dateByAddingDays(_ days : Int ) -> Date {
        let calendar = Calendar.current
        var dateComponent = DateComponents()
        dateComponent.day = days
        return (calendar as NSCalendar).date(byAdding: dateComponent, to: self, options: NSCalendar.Options.matchNextTime)!
    }
    
    func hour() -> Int {
        let calendar = Calendar.current
        let dateComponent = (calendar as NSCalendar).components(.hour, from: self)
        return dateComponent.hour!
    }
    
    func second() -> Int {
        let calendar = Calendar.current
        let dateComponent = (calendar as NSCalendar).components(.second, from: self)
        return dateComponent.second!
    }
    
    func minute() -> Int {
        let calendar = Calendar.current
        let dateComponent = (calendar as NSCalendar).components(.minute, from: self)
        return dateComponent.minute!
    }
    
    func day() -> Int {
        let calendar = Calendar.current
        let dateComponent = (calendar as NSCalendar).components(.day, from: self)
        return dateComponent.day!
    }
    
    func weekday() -> Int {
        let calendar = Calendar.current
        let dateComponent = (calendar as NSCalendar).components(.weekday, from: self)
        return dateComponent.weekday!
    }
    
    func weekdayStr() -> String {
        return Calendar.current.weekdaySymbols[self.weekday()-1]
    }
    
    func month() -> Int {
        let calendar = Calendar.current
        let dateComponent = (calendar as NSCalendar).components(.month, from: self)
        return dateComponent.month!
    }
    
    func monthStr() -> String {
        return Calendar.current.monthSymbols[self.month()-1]
    }
    
    func year() -> Int {
        let calendar = Calendar.current
        let dateComponent = (calendar as NSCalendar).components(.year, from: self)
        return dateComponent.year!
    }
    
    func numberOfDaysInMonth() -> Int {
        let calendar = Calendar.current
        let days = (calendar as NSCalendar).range(of: NSCalendar.Unit.day, in: NSCalendar.Unit.month, for: self)
        return days.length
    }
    
    func dateByIgnoringTime() -> Date {
        let calendar = Calendar.current
        let dateComponent = (calendar as NSCalendar).components([.year, .month, .day ], from: self)
        return calendar.date(from: dateComponent)!
    }
    
    func monthNameFull() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM YYYY"
        return dateFormatter.string(from: self)
    }
    
    func isSunday() -> Bool
    {
        return (self.getWeekday() == 1)
    }
    
    func isMonday() -> Bool
    {
        return (self.getWeekday() == 2)
    }
    
    func isTuesday() -> Bool
    {
        return (self.getWeekday() == 3)
    }
    
    func isWednesday() -> Bool
    {
        return (self.getWeekday() == 4)
    }
    
    func isThursday() -> Bool
    {
        return (self.getWeekday() == 5)
    }
    
    func isFriday() -> Bool
    {
        return (self.getWeekday() == 6)
    }
    
    func isSaturday() -> Bool
    {
        return (self.getWeekday() == 7)
    }
    
    func getWeekday() -> Int {
        let calendar = Calendar.current
        return (calendar as NSCalendar).components( .weekday, from: self).weekday!
    }
    
    func isToday() -> Bool {
        return self.isDateSameDay(Date())
    }
    
    func isDateSameDay(_ date: Date) -> Bool {

         return (self.day() == date.day()) && (self.month() == date.month() && (self.year() == date.year()))

    }
}
