//
//  EndPoints.swift
//  Currency
//
//  Created by Sohila on 01/06/2023.
//

import Foundation


enum EndPoints {
    case symbols
    case convert(amount: String, from: String, to: String)
    case latest(symbols: String, base: String)
    
    var path:String{
        switch self {
        case .symbols:
            return "symbols"
        case .convert(amount: let amount, from: let from, to: let to):
            return "convert?to=\(to)&from=\(from)&amount=\(amount)"
        case .latest(symbols: let symbols, base: let base):
            return "latest?symbols=\(symbols)&base=\(base)"
        }
    }
    
}
