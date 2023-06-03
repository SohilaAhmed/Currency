//
//  ViewController.swift
//  Currency
//
//  Created by Sohila on 31/05/2023.
//

import UIKit
import RxSwift
import RxCocoa

class ConvertCourrencyViewController: UIViewController {
    
    
    
    @IBOutlet weak var fromBtn: UIButton!
    @IBOutlet weak var toBtn: UIButton!
    @IBOutlet weak var covertBtn: UIButton!
    @IBOutlet weak var fromTF: UITextField!
    @IBOutlet weak var toTF: UITextField!
    @IBOutlet weak var datailsBtn: UIButton!
    @IBOutlet weak var fromTableView: UITableView!
    @IBOutlet weak var toTableView: UITableView!
    
    var getCourrencyViewModel: GetCourrencyViewModelProtocol = GetCourrencyViewModel()
    var convertCourrencyViewModel: ConvertCourrencyViewModelProtocol = ConvertCourrencyViewModel()
    var disposeBag = DisposeBag()
    
//    var toRes = ""
//    var fromRes = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
          
        fromTableView.isHidden = true
        toTableView.isHidden = true
        
        getAllCourrAndPresentItInTables()
        getAmountFromTF()
        calcResulet()
        checkDataValidation()
    }
    
    func getAllCourrAndPresentItInTables(){
        presentDataBtnActions(button: fromBtn, table: self.fromTableView)
        presentDataBtnActions(button: toBtn, table: self.toTableView)
        subscribeforFromTable()
        subscribeforToTable()
        getCourrencyViewModel.viewDidLoad()
    }
     
    func subscribeforFromTable(){
        getCourrencyViewModel.currencyPublish
            .bind(to: fromTableView
                .rx
                .items(cellIdentifier: "FromTableViewCell", cellType: FromTableViewCell.self)){
                    (index, title, cell) in
                    cell.setCellData(label: title)
                }.disposed(by: disposeBag)
        
        fromTableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            guard let self = self else { return }
            let cell = self.fromTableView.cellForRow(at: indexPath) as? FromTableViewCell
            self.fromBtn.setTitle(cell?.getData(), for: .normal)
            self.fromTableView.isHidden = true
            self.convertCourrencyViewModel.fromCurrBehavior.accept(cell?.getData() ?? "")
        }).disposed(by: disposeBag)
    }
    
    func subscribeforToTable(){
        getCourrencyViewModel.currencyPublish
            .bind(to: toTableView
                .rx
                .items(cellIdentifier: "ToTableViewCell", cellType: ToTableViewCell.self)){
                    (index, title, cell) in
                    cell.setCellData(label: title)
                }.disposed(by: disposeBag)
        
        toTableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            guard let self = self else { return }
            let cell = self.toTableView.cellForRow(at: indexPath) as? ToTableViewCell
            self.toBtn.setTitle(cell?.getData(), for: .normal)
//            self.fromBtn.setTitle("NAD", for: .normal)
            self.toTableView.isHidden = true
            self.convertCourrencyViewModel.toCurrBehavior.accept(cell?.getData() ?? "")
//            self.convertCourrencyViewModel.toCurrBehavior.accept(self.toBtn.titleLabel?.text ?? "")
        }).disposed(by: disposeBag)
    }
    
    func presentDataBtnActions(button: UIButton, table: UITableView){
        button.rx.tap.bind{ [weak self] in
            guard let self = self else { return }
            table.isHidden = !table.isHidden
        }.disposed(by: disposeBag)
    }
    
    func getAmountFromTF(){
        fromTF.rx.text.orEmpty.bind(to: convertCourrencyViewModel.amountCurrBehavior).disposed(by: disposeBag)
        
//        toBtn.rx.title(for: .normal).orEmpty.bind(to: convertCourrencyViewModel.toCurrBehavior)
        
//        self.convertCourrencyViewModel.toCurrBehavior.accept(toBtn.titleLabel?.text ?? "")
//        convertCourrencyViewModel.toCurrBehavior
//            .asDriver()
//            .drive(toBtn.rx.title())
//            .disposed(by: disposeBag)
//
//        convertCourrencyViewModel.fromCurrBehavior
//            .asDriver()
//            .drive(fromBtn.rx.title())
//            .disposed(by: disposeBag)
//        convertCourrencyViewModel.toCurrBehavior.accept(toBtn.title(for: .normal) ?? "")
        convertCourrencyViewModel.amountCurrBehavior.subscribe(onNext: {title in
            print(title)
        }).disposed(by: disposeBag)
    }
    
    func calcResulet(){
//        convertCourrencyViewModel.convertCourr(from: fromBtn.titleLabel?.text ?? "", to: toBtn.titleLabel?.text ?? "", amount: fromTF.text ?? "0")
        convertCourrencyViewModel.resultCurrencyPublish.bind(to: toTF.rx.text).disposed(by: disposeBag)
        convertCourrencyViewModel.fromCurrBehavior.subscribe(onNext: {title in
            print(title)
        }).disposed(by: disposeBag)
        convertCourrencyViewModel.toCurrBehavior.subscribe(onNext: {title in
            print(title)
        }).disposed(by: disposeBag)
//        convertCourrencyViewModel.resultCurrencyPublish.subscribe(onNext: {title in
//            self.toTF.text = title
//            print(title)
//        }).disposed(by: disposeBag)
    }
    
    func checkDataValidation(){
        convertCourrencyViewModel.compineDataValidation().subscribe(onNext: {state in
            if state == true{
                self.convertCourrencyViewModel.convertCourr()
            }
        }).disposed(by: disposeBag)
    }
}

