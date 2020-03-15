//
//  AppPantry.swift
//  TemperatureChart
//
//  Created by Triet Le on 13.3.2020.
//  Copyright © 2020 Le Trong Triet. All rights reserved.
//

import UIKit

/// AppPantry is where all global variables are stored
struct Color {
    static let topColor: UIColor = UIColor(red: 8/255, green: 98/255, blue: 121/255, alpha: 1)
    static let bottomColor: UIColor = UIColor(red: 43/255, green: 144/255, blue: 162/255, alpha: 1)
}

struct APIUrlString {
    static let credentialUrlString = "https://app.tibber.com/v4/login.credentials"
    static let dataUrlString = "https://app.tibber.com/v4/gql"
}
