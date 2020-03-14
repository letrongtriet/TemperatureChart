//
//  NetworkManager.swift
//  TemperatureChart
//
//  Created by Triet Le on 13.3.2020.
//  Copyright © 2020 Le Trong Triet. All rights reserved.
//

import Foundation

public typealias Closure<T> = (T) -> Void

class NetworkManager {
    
    // MARK:- Lifecycles
    private init() {}
    
    static let shared = NetworkManager()
    
    // MARK: - Public methods
    func getWeatherData(successfulCallback: Closure<WeatherData>?, errorCallback: Closure<String>?) {
        getToken(successfulCallback: { authToken in
            let headers = [
                "Authorization": "Bearer \(authToken)",
                "Content-Type": "application/json"
            ]
            
            let parameters = ["query":"{me{home(id:\"a8c210fc-2988-4f06-9fe9-ab1bad9529d5\"){weather{minTemperature,maxTemperature,entries{time,temperature,type}}}}}"]
            
            guard let postData = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
                errorCallback?("Something wrong happens")
                return
            }
            
            guard let url = URL(string: "https://app.tibber.com/v4/gql") else {
                errorCallback?("Something wrong happens")
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = headers
            request.httpBody = postData
            
            URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                if let error = error {
                    errorCallback?(error.localizedDescription)
                } else {
                    if let data = data {
                        do {
                            let decoder = JSONDecoder()
                            decoder.dateDecodingStrategy = .iso8601
                            let weatherData = try decoder.decode(WeatherData.self, from: data)
                            successfulCallback?(weatherData)
                        } catch {
                            errorCallback?(error.localizedDescription)
                        }
                    }
                }
            }).resume()
            
        }, errorCallback: errorCallback)
    }
    
    // MARK: - Private methods
    private func getToken(successfulCallback: Closure<String>?, errorCallback: Closure<String>?) {
        let headers = ["Content-Type": "application/x-www-form-urlencoded"]
        
        guard let emailData = "email=demo@tibber.com".data(using: .utf8) else {
            errorCallback?("Something wrong happens")
            return
        }
        
        guard let passwordData = "&password=Electric".data(using: .utf8) else {
            errorCallback?("Something wrong happens")
            return
        }
        
        guard let url = URL(string: "https://app.tibber.com/v4/login.credentials") else {
            errorCallback?("Something wrong happens")
            return
        }
        
        let postData = emailData + passwordData
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData
        
        URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            if let error = error {
                errorCallback?(error.localizedDescription)
            } else {
                if let data = data {
                    do {
                        let token = try JSONDecoder().decode(Token.self, from: data)
                        successfulCallback?(token.token)
                    } catch {
                        errorCallback?(error.localizedDescription)
                    }
                }
            }
        }).resume()
    }
}
