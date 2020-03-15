//
//  ChartView.swift
//  TemperatureChart
//
//  Created by Triet Le on 14.3.2020.
//  Copyright © 2020 Le Trong Triet. All rights reserved.
//

import UIKit
import Charts

class ChartView: UIView {
    
    // MARK: - Dependencies
    var data: [Entry]!
    var maxTemperature: Double!
    var minTemperature: Double!
    
    // MARK: - Lifecycles
    init(data: [Entry], maxTemperature: Double, minTemperature: Double, frame: CGRect) {
        super.init(frame: frame)
        
        self.data = data
        self.maxTemperature = maxTemperature + 5
        self.minTemperature = minTemperature - 5
        
        createChart()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    private func createChart() {
        var chartDataEntries = [ChartDataEntry]()
        
        for entry in data {
            let newChartDataEntry = ChartDataEntry(x: Double(entry.time.hour), y: entry.temperature ?? 0)
            chartDataEntries.append(newChartDataEntry)
        }
        
        let chartDataSet = LineChartDataSet(entries: chartDataEntries)
        chartDataSet.colors = [UIColor.white.withAlphaComponent(0.8)]
        chartDataSet.drawCirclesEnabled = false
        
        let chartData = LineChartData()
        chartData.addDataSet(chartDataSet)
        chartData.setDrawValues(false)
        
        let lineChartView = LineChartView(frame: self.frame)
        lineChartView.data = chartData
        
        /// Remove right axis
        lineChartView.rightAxis.enabled = false
        
        /// Config yAxis of chart
        lineChartView.leftAxis.valueFormatter = YAxisValueFormatter()
        lineChartView.leftAxis.axisMinimum = minTemperature
        lineChartView.leftAxis.axisMaximum = maxTemperature
        lineChartView.leftAxis.axisLineColor = .clear
        lineChartView.leftAxis.labelTextColor = UIColor.white.withAlphaComponent(0.7)
        lineChartView.leftAxis.labelCount = 4
        lineChartView.leftAxis.forceLabelsEnabled = true
        
        lineChartView.leftAxis.gridColor = UIColor.white.withAlphaComponent(0.4)
        
        /// Config xAxis of chart
        lineChartView.xAxis.valueFormatter = XAxisValueFormatter()
        
        lineChartView.xAxis.drawGridLinesEnabled = false
        lineChartView.xAxis.drawAxisLineEnabled = false
        
        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.xAxis.labelTextColor = UIColor.white.withAlphaComponent(0.7)
        lineChartView.xAxis.forceLabelsEnabled = true
        lineChartView.xAxis.avoidFirstLastClippingEnabled = true
        
        lineChartView.xAxis.gridColor = UIColor.white.withAlphaComponent(0.4)
        
        /// Config general area for chart
        lineChartView.legend.enabled = false
        lineChartView.animate(xAxisDuration: 0.4, yAxisDuration: 0.4, easingOption: .easeInCubic)
        
        lineChartView.isUserInteractionEnabled = false
        
        self.addSubview(lineChartView)
        self.bringSubviewToFront(lineChartView)
    }
    
}
