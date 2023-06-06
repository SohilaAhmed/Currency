//
//  HistoricalCurrencyViewModel.swift
//  Currency
//
//  Created by Sohila on 06/06/2023.
//

import Foundation
import RxCocoa
import RxSwift

protocol HistoricalCurrencyViewModelProtocol: AnyObject{
    var fetchFromCoreData: PublishSubject<[HistoricalCurrencyModel]>{ get }
    func getHistoricalCurrrenciesCurr()
}

class HistoricalCurrencyViewModel: HistoricalCurrencyViewModelProtocol{
      
    var fetchFromCoreData: PublishSubject<[HistoricalCurrencyModel]> = .init()
     
    func getHistoricalCurrrenciesCurr(){
        fetchFromCoreData.onNext(CoreDataManager.fetchFromCoreData())
    }
}
 
