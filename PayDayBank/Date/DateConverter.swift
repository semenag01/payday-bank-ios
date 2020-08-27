//
//  DateConverter.swift
//  PayDayBank
//
//  Created by Developer on 15.07.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

import Foundation

class DateConverter {
    static let shared: DateConverter = DateConverter()

    let dateFormatter: DateFormatter = DateFormatter()
    let serverDateFormat: String = "yyyy-MM-dd'T'HH:mm:ssZ"
    let baseDateFormat: String = "dd MMMM YYYY"
    let baseMonthDateFormat: String = "MMMM YYYY"
    let baseTimeFormat: String = "HH:mm:ss"
    
    private init() {
        dateFormatter.locale = Locale.current
    }
    
    func convertDateToServerString(date: Date?) -> String? {
        guard let date = date else { return nil }
        
        let result: String = convertDateToStringWithFormat(aDate: date, aFormat: serverDateFormat)
        
        return result
    }
    
    func convertServerStringToDate(string: String?) -> Date? {
        guard let string = string else { return nil }
        
        let result: Date? = convertStringToDateWithFormat(aDateStr: string, aFormat: serverDateFormat)
        
        return result
    }
    
    func convertDateToBaseDateString(date: Date?) -> String? {
        guard let date = date else { return nil }
        
        let result: String = convertDateToStringWithFormat(aDate: date, aFormat: baseDateFormat)
        
        return result
    }
    
    func convertBaseDateStringToDate(string: String?) -> Date? {
        guard let string = string else { return nil }
        
        let result: Date? = convertStringToDateWithFormat(aDateStr: string, aFormat: baseDateFormat)
        
        return result
    }
    
    func convertDateToBaseMonthString(date: Date?) -> String? {
        guard let date = date else { return nil }
        
        let result: String = convertDateToStringWithFormat(aDate: date, aFormat: baseMonthDateFormat)
        
        return result
    }
    
    func convertDateToBaseTimeString(date: Date?) -> String? {
        guard let date = date else { return nil }
        
        let result: String = convertDateToStringWithFormat(aDate: date, aFormat: baseTimeFormat)
        
        return result
    }
    
    func convertDateToStringWithFormat(aDate: Date, aFormat: String) -> String {
        
        var result: String
        
        dateFormatter.dateFormat = aFormat
        result = dateFormatter.string(from: aDate)
        
        return result
    }
    
    func convertStringToDateWithFormat(aDateStr: String, aFormat: String) -> Date? {
        
        var result: Date?
        
        dateFormatter.dateFormat = aFormat
        result = dateFormatter.date(from: aDateStr)
        
        return result
    }
}
