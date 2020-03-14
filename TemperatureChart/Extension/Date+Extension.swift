//
//  Date+Extension.swift
//  TemperatureChart
//
//  Created by Triet Le on 14.3.2020.
//  Copyright © 2020 Le Trong Triet. All rights reserved.
//

import Foundation

extension Date {
    var calendar: Calendar {
        var calendar = Calendar.current
        if let timeZone = TimeZone(identifier: "fi_FI") {
           calendar.timeZone = timeZone
        }
        return calendar
    }
    
    var hour: Int {
        return calendar.component(.hour, from: self)
    }
    
    var minute: Int {
        return calendar.component(.minute, from: self)
    }
}
