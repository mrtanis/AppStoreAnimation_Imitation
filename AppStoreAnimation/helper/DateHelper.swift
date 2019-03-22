//
//  DateHelper.swift
//  AppStoreAnimation
//
//  Created by mrtanis on 2019/3/14.
//  Copyright © 2019 mrtanis. All rights reserved.
//

import Foundation

enum DateFormatterType {
    case ymdhms(_ length: DateFormatterLength)
    case ymdhm(_ length: DateFormatterLength)
    case ymdh(_ length: DateFormatterLength)
    case ymd(_ length: DateFormatterLength)
    case md(_ length: DateFormatterLength)
    case hms(_ length: DateFormatterLength)
    case hm(_ length: DateFormatterLength)
}

enum DateFormatterLength {
    case full(_ local: DateFormatterLocal)
    case half(_ local: DateFormatterLocal)
}

enum DateFormatterLocal {
    case gl
    case zh
}

extension Date {
    
    var weekday: Int {
        let calendar = Calendar.current
        let calendarCompennent = Calendar.Component.weekday
        let weekday = calendar.component(calendarCompennent, from: self)
        return weekday
    }
    
    func weekdayString(_ length: DateFormatterLength) -> String {
        let weekdays_full_zh = ["星期日","星期一","星期二","星期三","星期四","星期五","星期六"]
        let weekdays_full_en = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
        let weekdays_half_zh = ["周日","周一","周二","周三","周四","周五","周六"]
        let weekdays_half_en = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"]
        
        //weekday从1开始
        let index = self.weekday - 1
        
        switch length {
        case let .full(local):
            switch local {
            case .gl:
                return weekdays_full_en[index]
            case .zh:
                return weekdays_full_zh[index]
            }
        case let .half(local):
            switch local {
            case .gl:
                return weekdays_half_en[index]
            case .zh:
                return weekdays_half_zh[index]
            }
        }
    }
    
    func dateString(_ formatterType: DateFormatterType) -> String {
        let formatterStr = self.dateFormatterStr(type: formatterType)
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = formatterStr
        let str = formatter.string(from: self)
        
        return str
    }
    
    fileprivate func dateFormatterStr(type: DateFormatterType) -> String {
        switch type {
        case let .ymdhms(length):
            return self.dateLengthString(originStr: "yyyy年MM月dd日 HH时mm分ss秒", length: length)
        case let .ymdhm(length):
            return self.dateLengthString(originStr: "yyyy年MM月dd日 HH时mm分", length: length)
        case let .ymdh(length):
            return self.dateLengthString(originStr: "yyyy年MM月dd日 HH时", length: length)
        case let .ymd(length):
            return self.dateLengthString(originStr: "yyyy年MM月dd日", length: length)
        case let .md(length):
            return self.dateLengthString(originStr: "MM月dd日", length: length)
        case let .hms(length):
            return self.dateLengthString(originStr: "HH时mm分ss秒", length: length)
        case let .hm(length):
            return self.dateLengthString(originStr: "HH时mm分", length: length)
    }
    }
    
    fileprivate func dateLengthString(originStr: String, length: DateFormatterLength) -> String {
        switch length {
        case let .full(local):
            return self.dateLocalString(originStr: originStr, local: local)
        case let .half(local):
            var newStr = originStr.replacingOccurrences(of: "yyyy", with: "yy")
            newStr = newStr.replacingOccurrences(of: "MM", with: "M")
            newStr = newStr.replacingOccurrences(of: "dd", with: "d")
            newStr = newStr.replacingOccurrences(of: "HH", with: "H")
            newStr = newStr.replacingOccurrences(of: "mm", with: "m")
            newStr = newStr.replacingOccurrences(of: "ss", with: "s")
            return self.dateLocalString(originStr: newStr, local: local)
        }
        }
    
    fileprivate func dateLocalString(originStr: String, local: DateFormatterLocal) -> String {
        switch local {
        case .gl:
            var newStr = originStr.replacingOccurrences(of: "年", with: "-")
            newStr = newStr.replacingOccurrences(of: "月", with: "-")
            newStr = newStr.replacingOccurrences(of: "日", with: "")
            newStr = newStr.replacingOccurrences(of: "时", with: ":")
            newStr = newStr.replacingOccurrences(of: "分", with: ":")
            newStr = newStr.replacingOccurrences(of: "秒", with: "")
            
            return newStr
        case .zh:
            return originStr
        }
        }
    
}
