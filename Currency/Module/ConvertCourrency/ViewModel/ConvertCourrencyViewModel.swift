//
//  ConvertCourrencyViewModel.swift
//  Currency
//
//  Created by Sohila on 02/06/2023.
//

import Foundation
import RxSwift
import RxCocoa

protocol ConvertCourrencyViewModelProtocol: AnyObject{
    var amountCurrBehavior: BehaviorRelay<String> { get }
    var fromCurrBehavior: BehaviorRelay<String> { get }
    var toCurrBehavior: BehaviorRelay<String> { get set }
    var resultCurrencyPublish: PublishSubject<String> { get }
    func compineDataValidation()-> Observable<Bool>
    func convertCourr()
}

class ConvertCourrencyViewModel: ConvertCourrencyViewModelProtocol{
    
    var amountCurrBehavior: BehaviorRelay<String> = .init(value: "")
    var fromCurrBehavior: BehaviorRelay<String> = .init(value: "")
    var toCurrBehavior: BehaviorRelay<String> = .init(value: "")
    
    var resultCurrencyPublish: PublishSubject<String> = .init()
   
    func isAmountDataValied()-> Observable<Bool>{
        amountCurrBehavior.map{ amount in
            return amount != ""
        }
    }
    
    func isFromDataValied()-> Observable<Bool>{
        fromCurrBehavior.map{ from in
            return from != "" && from != "From"
        }
    }
    
    func isToDataValied()-> Observable<Bool>{
        toCurrBehavior.map{ to in
            return to != "" && to != "To"
        }
    }
    
    func compineDataValidation()-> Observable<Bool>{
        Observable.combineLatest(isAmountDataValied(), isFromDataValied(), isToDataValied()).map({
            return $0 && $1 && $2
        })
    }
    
    func convertCourr(){
        var resCurrency: String = ""
        NetworkService.getApi(endPoint: EndPoints.convert(amount: amountCurrBehavior.value, from: fromCurrBehavior.value, to: toCurrBehavior.value)) { [weak self] (data: ConvertCourrencyModel?, error) in
            guard let self = self else { return }
            guard let responsData = data else{
                print(error?.localizedDescription ?? "")
                return}
            print(responsData.result)
            print(responsData.success)
            resCurrency = "\(responsData.result)"
            self.resultCurrencyPublish.onNext(resCurrency)
        }
        
    }
}
