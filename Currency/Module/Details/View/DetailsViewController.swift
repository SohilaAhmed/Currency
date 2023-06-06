//
//  DetailsViewController.swift
//  Currency
//
//  Created by Sohila on 04/06/2023.
//

import UIKit
import RxCocoa
import RxSwift

class DetailsViewController: UIViewController {

    @IBOutlet weak var headerName: UILabel!
    @IBOutlet weak var otherCurrTableView: UITableView!
    @IBOutlet weak var HistoricalCurrTable: UITableView!
    
    var otherCurrrenciesViewModel: OtherCurrrenciesViewModelProtocol = OtherCurrrenciesViewModel()
    var historicalCurrencyViewModel: HistoricalCurrencyViewModelProtocol = HistoricalCurrencyViewModel()
    var baseCurr = ""
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerName.text = baseCurr
        
        print(baseCurr)
        
        subscribeForOtherCurrrenciesTable()
        checkValidationOfBase()
        subscribeForHistoricalCurrrenciesTable()
        historicalCurrencyViewModel.getHistoricalCurrrenciesCurr()
    }
    
    func checkValidationOfBase(){
        otherCurrrenciesViewModel.BaseCurr.accept(baseCurr)
        otherCurrrenciesViewModel.isBaseDataValied().subscribe(onNext: {state in
            if state == true{
                self.otherCurrrenciesViewModel.getOtherCurrrenciesCurr()
            }
        }).disposed(by: disposeBag)
    }
    
    func subscribeForOtherCurrrenciesTable(){
        otherCurrrenciesViewModel.otherCurrencyPublish
            .bind(to: otherCurrTableView
                .rx
                .items(cellIdentifier: "OtherCurrenciesTableViewCell", cellType: OtherCurrenciesTableViewCell.self)){
                    (index, elemnt, cell) in
                    cell.setCellData(currName: elemnt.key, currRate: String(describing:  elemnt.value))
                }.disposed(by: disposeBag)
         
    }
    
    func subscribeForHistoricalCurrrenciesTable(){
        historicalCurrencyViewModel.fetchFromCoreData
            .bind(to: HistoricalCurrTable
                .rx
                .items(cellIdentifier: "HistoricalCurrenciesTableViewCell", cellType: HistoricalCurrenciesTableViewCell.self)){ (index, elemnt, cell) in
                    cell.setCellData(fromLabel: elemnt.from, toLabel: elemnt.to, amountLabel: elemnt.amount, resultLabel: elemnt.result)
                }.disposed(by: disposeBag)
    }
}
