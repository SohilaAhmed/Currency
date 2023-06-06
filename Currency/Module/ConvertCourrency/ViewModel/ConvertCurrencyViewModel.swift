//
//  ConvertCourrencyViewModel.swift
//  Currency
//
//  Created by Sohila on 02/06/2023.
//

import Foundation
import RxSwift
import RxCocoa

protocol ConvertCurrencyViewModelProtocol: AnyObject{
    var amountCurrBehavior: BehaviorRelay<String> { get }
    var fromCurrBehavior: BehaviorRelay<String> { get }
    var toCurrBehavior: BehaviorRelay<String> { get set }
    var resultCurrencyPublish: PublishSubject<String> { get }
    func compineDataValidation()-> Observable<Bool>
    func convertCourr()
    func saveTocoreData()
}

class ConvertCurrencyViewModel: ConvertCurrencyViewModelProtocol{
    
    var amountCurrBehavior: BehaviorRelay<String> = .init(value: "")
    var fromCurrBehavior: BehaviorRelay<String> = .init(value: "")
    var toCurrBehavior: BehaviorRelay<String> = .init(value: "")
    
    var resultCurrencyPublish: PublishSubject<String> = .init()
    
    var resCurr: BehaviorRelay<String> = .init(value: "")
    
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
        NetworkService.getApi(endPoint: EndPoints.convert(amount: amountCurrBehavior.value, from: fromCurrBehavior.value, to: toCurrBehavior.value)) { [weak self] (data: ConvertCurrencyModel?, error) in
            guard let self = self else { return }
            guard let responsData = data else{
                print(error?.localizedDescription ?? "")
                return}
            print(responsData.result)
            print(responsData.success)
            resCurrency = "\(responsData.result)"
            self.resCurr.accept(resCurrency)
            DispatchQueue.main.async {
                self.saveTocoreData()
            }
            self.resultCurrencyPublish.onNext(resCurrency)
        }
    }
    
    func saveTocoreData(){
        CoreDataManager.saveToCoreData(currencyAmount: self.amountCurrBehavior.value, currencyFrom: self.fromCurrBehavior.value, currencyTo: self.toCurrBehavior.value, currencyResult: self.resCurr.value)
    }
}
        
