//
//  ChartViewModel.swift
//  TemperatureChart
//
//  Created by Triet Le on 14.3.2020.
//  Copyright © 2020 Le Trong Triet. All rights reserved.
//

import UIKit

class ChartViewModel {
    
    // MARK: - Lifecycles
    deinit {
        stopObserving()
    }

    // MARK: - Callback
    var viewCallback: Closure<UIView>?
    
    // MARK: - Private properties
    private var timer: Timer?
    
    private var entries: [Entry] = [] {
        didSet {
            DispatchQueue.main.async {
                self.createChartView()
            }
        }
    }
    
    private var maxTemperature: Double = 0
    private var minTemperature: Double = 0
    
    private var errorMessage = "" {
        didSet {
            DispatchQueue.main.async {
                self.createErrorView()
            }
        }
    }
    
    private var frame: CGRect = .zero
    
    // MARK: - Public methods
    func fetchData(with frame: CGRect) {
        self.frame = frame
        
        if entries.isEmpty {
            DispatchQueue.main.async {
                self.createLoadingView()
            }
        }
        
        NetworkManager.shared.getWeatherData(successfulCallback: { weatherData in
            if let error = weatherData.errors?.first {
                self.errorMessage = error.message
            } else {
                self.process(data: weatherData)
            }
        }, errorCallback: { errorMessage in
            print(errorMessage)
            self.errorMessage = errorMessage
        })
        
        startObserving()
    }
    
    // MARK: - Private method
    private func process(data: WeatherData) {
        print(data)
        var entries = [Entry]()
        
        for entry in data.data.me?.home.weather.entries ?? [] where entry.temperature != nil {
            entries.append(entry)
        }
        
        entries = entries.sorted(by: { (s1, s2) -> Bool in
            if s1.time.hour < s2.time.hour { return true }
            if s1.time.hour == s2.time.hour { return s1.time.minute < s2.time.minute }
            return false
        })
        
        self.maxTemperature = data.data.me?.home.weather.maxTemperature ?? 0
        self.minTemperature = data.data.me?.home.weather.minTemperature ?? 0
        self.entries = entries
    }
    
    private func createChartView() {
        let newChartView = ChartView(data: entries, maxTemperature: maxTemperature, minTemperature: minTemperature, frame: frame)
        viewCallback?(newChartView)
    }
    
    private func createErrorView() {
        let errorLabel = UILabel()
                
        errorLabel.font = UIFont.systemFont(ofSize: 16)
        errorLabel.text = errorMessage
        errorLabel.textColor = .red
        errorLabel.textAlignment = .center
        errorLabel.frame = frame
        errorLabel.numberOfLines = 0
        
        viewCallback?(errorLabel)
    }
    
    private func createLoadingView() {
        let loadingIndicator = UIActivityIndicatorView()
        
        loadingIndicator.style = .whiteLarge
        loadingIndicator.startAnimating()
        loadingIndicator.frame = frame
        
        viewCallback?(loadingIndicator)
    }
    
    private func startObserving() {
        timer?.invalidate()
        timer = nil
        
        timer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true, block: { _ in
            self.fetchData(with: self.frame)
        })
    }
    
    private func stopObserving() {
        timer?.invalidate()
        timer = nil
    }
}
