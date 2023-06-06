//
//  OtherCurrrenciesModel.swift
//  Currency
//
//  Created by Sohila on 04/06/2023.
//

import Foundation

struct OtherCurrrenciesModel: Codable {
    var success: Bool
    var timestamp: Int
    var base, date: String
    var rates: [String: Double]
}

struct PublicCurrrencies {
    static let publicCurrrencies: String = "USD%2C%20EUR%2C%20JPY%2C%20GBP%2C%20AUD%2C%20CAD%2C%20CHF%2C%20CNY%2C%20HKD%2C%20NZD%2C%20SGD"
}
 
