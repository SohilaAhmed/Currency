//
//  GetCourrencyViewModel.swift
//  Currency
//
//  Created by Sohila on 01/06/2023.
//

import Foundation
import RxSwift

protocol GetCourrencyViewModelProtocol: AnyObject{
    var currencyPublish: PublishSubject<[String]> { get }
    func viewDidLoad()
}

class GetCourrencyViewModel: GetCourrencyViewModelProtocol{
    
    var currencyPublish: PublishSubject<[String]> = .init()
    
    func viewDidLoad(){
        getAllCourr()
    }
    
    private func getAllCourr(){
        var currency: [String] = [String]()
        
        NetworkService.getApi(endPoint: EndPoints.symbols) { [weak self] (data: allCourrency?, error) in
            guard let responsData = data else{ return}
            print(responsData.symbols.first as Any)
            print(responsData.success)
            currency = Array(responsData.symbols.keys)
            self?.currencyPublish.onNext(currency)
        } 
    }
}
