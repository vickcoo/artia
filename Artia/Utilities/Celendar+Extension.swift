//
//  Celendar+Extension.swift
//  Artia
//
//  Created by Vick on 3/29/25.
//

import Foundation

extension Calendar {
    func startOfDay() -> Date {
        let calendar = Calendar.current
        let now = Date()
        let startOfDay = calendar.startOfDay(for: now)
        return startOfDay
    }
    
    func endOfDay() -> Date {
        let calendar = Calendar.current
        let now = Date()
        
        let startOfDay = calendar.startOfDay(for: now)
        let endOfDay = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: startOfDay)!
        return endOfDay
    }
}
