//
//  YAxisValueFormatter.swift
//  TemperatureChart
//
//  Created by Triet Le on 14.3.2020.
//  Copyright © 2020 Le Trong Triet. All rights reserved.
//

import Foundation
import Charts

class YAxisValueFormatter: NSObject, IAxisValueFormatter {

    let numFormatter: NumberFormatter

    override init() {
        numFormatter = NumberFormatter()
        numFormatter.minimumFractionDigits = 1
        numFormatter.maximumFractionDigits = 1

        numFormatter.minimumIntegerDigits = 1
        numFormatter.positiveSuffix = " C"
        numFormatter.negativeSuffix = " C"
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return numFormatter.string(from: NSNumber(floatLiteral: value)) ?? ""
    }
}
