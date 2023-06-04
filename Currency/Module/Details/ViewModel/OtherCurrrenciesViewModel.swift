//
//  OtherCurrrenciesViewModel.swift
//  Currency
//
//  Created by Sohila on 04/06/2023.
//

import Foundation
import RxCocoa
import RxSwift

protocol OtherCurrrenciesViewModelProtocol: AnyObject{
    var otherCurrencyPublish: PublishSubject<[String: Double]> { get }
    var BaseCurr: BehaviorRelay<String> { get }
    func isBaseDataValied()-> Observable<Bool>
    func getOtherCurrrenciesCurr()
}

class OtherCurrrenciesViewModel: OtherCurrrenciesViewModelProtocol{
    
    var otherCurrencyPublish: PublishSubject<[String: Double]> = .init()
    var BaseCurr: BehaviorRelay<String> = .init(value: "")
    
 
    
    func isBaseDataValied()-> Observable<Bool>{
        BaseCurr.map{ base in
            return base != ""
        }
    }
    
    func getOtherCurrrenciesCurr(){
        var otherCurrency: [String: Double] = [String: Double]()
        
        NetworkService.getApi(endPoint: EndPoints.latest(symbols: PublicCurrrencies.publicCurrrencies, base: BaseCurr.value)) { [weak self] (data: OtherCurrrenciesModel?, error) in
            guard let self = self else { return }
            guard let responsData = data else{ return}
            print(Array(responsData.rates.keys))
            print(responsData.success)
            otherCurrency = responsData.rates
            self.otherCurrencyPublish.onNext(otherCurrency)
        }
    }
}
