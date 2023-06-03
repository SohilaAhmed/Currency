//
//  ConvertCourrencyModel.swift
//  Currency
//
//  Created by Sohila on 02/06/2023.
//

import Foundation

struct ConvertCourrencyModel: Codable {
//    let date, historical: String
//    let info: Info
//    let query: Query
    let result: Double
    let success: Bool
}
 
struct Info: Codable {
    let rate,timestamp: String
}
 
struct Query: Codable {
    let amount,from, to: String
}
