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
    @IBOutlet weak var swapBtn: UIButton!
    @IBOutlet weak var fromTF: UITextField!
    @IBOutlet weak var toTF: UITextField!
    @IBOutlet weak var datailsBtn: UIButton!
    @IBOutlet weak var fromTableView: UITableView!
    @IBOutlet weak var toTableView: UITableView!
    
    var getCourrencyViewModel: GetCourrencyViewModelProtocol = GetCourrencyViewModel()
    var convertCourrencyViewModel: ConvertCourrencyViewModelProtocol = ConvertCourrencyViewModel()
    var disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fromTF.delegate = self
        fromTF.keyboardType = .numberPad
        
        fromTableView.isHidden = true
        toTableView.isHidden = true
        
        getAllCourrAndPresentItInTables()
        getAmountFromTF()
        calcResulet()
        checkDataValidation()
        
        swapBtnAction()
    }
    
    func getAllCourrAndPresentItInTables(){
        presentDataBtnActions(button: fromBtn, table: self.fromTableView)
        presentDataBtnActions(button: toBtn, table: self.toTableView)
        subscribeforFromTable()
        subscribeforToTable()
        getCourrencyViewModel.viewDidLoad()
    }
    
    func getAmountFromTF(){
        fromTF.rx.text.orEmpty.bind(to: convertCourrencyViewModel.amountCurrBehavior).disposed(by: disposeBag)
         
        convertCourrencyViewModel.amountCurrBehavior.subscribe(onNext: {title in
            print(title)
        }).disposed(by: disposeBag)
    }
    
    func calcResulet(){
        convertCourrencyViewModel.resultCurrencyPublish.bind(to: toTF.rx.text).disposed(by: disposeBag)
        
        convertCourrencyViewModel.fromCurrBehavior.subscribe(onNext: {title in
            print(title)
        }).disposed(by: disposeBag)
        convertCourrencyViewModel.toCurrBehavior.subscribe(onNext: {title in
            print(title)
        }).disposed(by: disposeBag)
    }
    
    func checkDataValidation(){
        convertCourrencyViewModel.compineDataValidation().subscribe(onNext: {state in
            if state == true{
                self.convertCourrencyViewModel.convertCourr()
            }
        }).disposed(by: disposeBag)
    }
    
    func swapBtnAction(){
        swapBtn.rx.tap.bind{ [weak self] _ in
            guard let self = self else { return }
            let oldToTitle = self.toBtn.title(for: .normal)
            self.toBtn.setTitle(self.fromBtn.title(for: .normal), for: .normal)
            self.fromBtn.setTitle(oldToTitle, for: .normal)
            
            self.convertCourrencyViewModel.toCurrBehavior.accept(self.toBtn.title(for: .normal) ?? "")
            self.convertCourrencyViewModel.fromCurrBehavior.accept(self.fromBtn.title(for: .normal) ?? "")
        }.disposed(by: disposeBag)
    }
}

extension ConvertCourrencyViewController: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacterSet = CharacterSet.decimalDigits
        let stringCharacterSet = CharacterSet(charactersIn: string)
        return allowedCharacterSet.isSuperset(of: stringCharacterSet)
    }
}

extension ConvertCourrencyViewController{
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
            
            self.convertCourrencyViewModel.fromCurrBehavior.accept(self.fromBtn.title(for: .normal) ?? "")
            
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
            
            self.toTableView.isHidden = true
            
            self.convertCourrencyViewModel.toCurrBehavior.accept(self.toBtn.title(for: .normal) ?? "")
             
        }).disposed(by: disposeBag)
    }
    
    func presentDataBtnActions(button: UIButton, table: UITableView){
        button.rx.tap.bind{ _ in
            table.isHidden = !table.isHidden
        }.disposed(by: disposeBag)
    }
}
