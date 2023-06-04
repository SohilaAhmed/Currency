//
//  GetCourrencyViewModel.swift
//  Currency
//
//  Created by Sohila on 01/06/2023.
//

import Foundation
import RxSwift

protocol GetCurrencyViewModelProtocol: AnyObject{
    var currencyPublish: PublishSubject<[String]> { get }
    func viewDidLoad()
}

class GetCurrencyViewModel: GetCurrencyViewModelProtocol{
    
    var currencyPublish: PublishSubject<[String]> = .init()
    
    func viewDidLoad(){
        getAllCurr()
    }
    
    private func getAllCurr(){
        var currency: [String] = [String]()
        
        NetworkService.getApi(endPoint: EndPoints.symbols) { [weak self] (data: allCourrency?, error) in
            guard let self = self else { return }
            guard let responsData = data else{ return}
            print(responsData.symbols.first as Any)
            print(responsData.success)
            currency = Array(responsData.symbols.keys)
            self.currencyPublish.onNext(currency)
        } 
    }
}
