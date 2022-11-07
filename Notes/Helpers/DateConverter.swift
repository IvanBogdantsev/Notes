//
//  DateConverter.swift
//  Notes
//
//  Created by Vanya Bogdantsev on 07.11.2022.
//

import Foundation

struct DateConverter {
    
    private let dateFormatter = DateFormatter()
    
    private let calendar = Calendar(identifier: .gregorian)
    
    private let yesterday = "Yesterday"
    
    func convert(date: Date) -> String {
        if calendar.isDateInToday(date) {
            dateFormatter.dateFormat = "HH:mm"
            return dateFormatter.string(from: date)
        }
        
        if calendar.isDateInYesterday(date) {
            return yesterday
        }
        
        if calendar.isDateInWeekend(date) {
            dateFormatter.dateFormat = "EEEE"
            return dateFormatter.string(from: date)
        }
        
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        return dateFormatter.string(from: date)
    }
    
}
