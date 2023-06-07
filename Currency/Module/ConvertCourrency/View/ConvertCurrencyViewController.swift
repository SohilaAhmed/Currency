//
//  ViewController.swift
//  Currency
//
//  Created by Sohila on 31/05/2023.
//

import UIKit
import RxSwift
import RxCocoa

class ConvertCurrencyViewController: UIViewController {
     
    @IBOutlet weak var fromBtn: UIButton!
    @IBOutlet weak var toBtn: UIButton!
    @IBOutlet weak var swapBtn: UIButton!
    @IBOutlet weak var fromTF: UITextField!
    @IBOutlet weak var toTF: UITextField!
    @IBOutlet weak var datailsBtn: UIButton!
    @IBOutlet weak var fromTableView: UITableView!
    @IBOutlet weak var toTableView: UITableView!
    
    var getCurrencyViewModel: GetCurrencyViewModelProtocol = GetCurrencyViewModel()
    var convertCurrencyViewModel: ConvertCurrencyViewModelProtocol = ConvertCurrencyViewModel()
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
        
        detailsBtnAction()
    }
    
    func getAllCourrAndPresentItInTables(){
        presentDataBtnActions(button: fromBtn, table: self.fromTableView)
        presentDataBtnActions(button: toBtn, table: self.toTableView)
        subscribeforFromTable()
        subscribeforToTable()
        getCurrencyViewModel.viewDidLoad()
    }
    

    func getAmountFromTF(){
        fromTF.rx.text.orEmpty.bind(to: convertCurrencyViewModel.amountCurrBehavior).disposed(by: disposeBag)
         
//        convertCurrencyViewModel.amountCurrBehavior.subscribe(onNext: {title in
//            print(title)
//        }).disposed(by: disposeBag)
    }
    
    func calcResulet(){
        convertCurrencyViewModel.resultCurrencyPublish.bind(to: toTF.rx.text).disposed(by: disposeBag)
        
//        convertCurrencyViewModel.fromCurrBehavior.subscribe(onNext: {title in
//            print(title)
//        }).disposed(by: disposeBag)
//        convertCurrencyViewModel.toCurrBehavior.subscribe(onNext: {title in
//            print(title)
//        }).disposed(by: disposeBag)
    }
    
    func checkDataValidation(){
        convertCurrencyViewModel.compineDataValidation().subscribe(onNext: {state in
            if state == true{
                self.convertCurrencyViewModel.convertCourr() 
            }
        }).disposed(by: disposeBag)
    }
    
    func swapBtnAction(){
        swapBtn.rx.tap.bind{ [weak self] _ in
            guard let self = self else { return }
            let oldToTitle = self.toBtn.title(for: .normal)
            self.toBtn.setTitle(self.fromBtn.title(for: .normal), for: .normal)
            self.fromBtn.setTitle(oldToTitle, for: .normal)
            
            self.convertCurrencyViewModel.toCurrBehavior.accept(self.toBtn.title(for: .normal) ?? "")
            self.convertCurrencyViewModel.fromCurrBehavior.accept(self.fromBtn.title(for: .normal) ?? "")
        }.disposed(by: disposeBag)
    }
    
    func detailsBtnAction(){
        datailsBtn.rx.tap.bind{ [weak self] _ in
            guard let self = self else { return }
            let storyboard =  UIStoryboard(name: "Details", bundle: nil)
            let detailsViewController = storyboard.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
            detailsViewController.baseCurr = self.fromBtn.title(for: .normal) ?? ""
            self.navigationController?.pushViewController(detailsViewController, animated: true)
            self.fromTF.text = "1"
            self.toTF.text = ""
            self.toBtn.setTitle("To", for: .normal)
            self.fromBtn.setTitle("From", for: .normal)
            self.convertCurrencyViewModel.fromCurrBehavior.accept(self.fromBtn.title(for: .normal) ?? "")
            self.convertCurrencyViewModel.toCurrBehavior.accept(self.toBtn.title(for: .normal) ?? "")
            
        }.disposed(by: disposeBag)
    }
    
    
    //    func KnowTheFocusTF(){
    //        let editingChanges = Observable.merge(
    //            fromTF.rx.controlEvent(.editingDidBegin).map { true },
    //            fromTF.rx.controlEvent(.editingDidEnd).map { false },
    //            toTF.rx.controlEvent(.editingDidBegin).map { true },
    //            toTF.rx.controlEvent(.editingDidEnd).map { false }
    //        )
    //
    //        // Subscribe to the observable and print whether each text field is on focus or not
    //        editingChanges.subscribe(onNext: { isEditing in
    //            if self.fromTF.isFirstResponder {
    //                print("fromTF is on focus: \(isEditing)")
    //                self.fromTF.rx.text.orEmpty.bind(to: self.convertCurrencyViewModel.amountCurrBehavior).disposed(by: self.disposeBag)
    //                self.convertCurrencyViewModel.resultCurrencyPublish.bind(to: self.toTF.rx.text).disposed(by: self.disposeBag)
    //            } else if self.toTF.isFirstResponder {
    //                print("toTF is on focus: \(isEditing)")
    //                self.toTF.rx.text.orEmpty.bind(to: self.convertCurrencyViewModel.amountCurrBehavior).disposed(by: self.disposeBag)
    //                self.convertCurrencyViewModel.resultCurrencyPublish.bind(to: self.fromTF.rx.text).disposed(by: self.disposeBag)
    //            }
    //        }).disposed(by: disposeBag)
    //    }
        
    
}

extension ConvertCurrencyViewController: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacterSet = CharacterSet.decimalDigits
        let stringCharacterSet = CharacterSet(charactersIn: string)
        return allowedCharacterSet.isSuperset(of: stringCharacterSet)
    }
}

extension ConvertCurrencyViewController{
    func subscribeforFromTable(){
        getCurrencyViewModel.currencyPublish
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
            
            self.convertCurrencyViewModel.fromCurrBehavior.accept(self.fromBtn.title(for: .normal) ?? "")
            
        }).disposed(by: disposeBag)
    }
    
    func subscribeforToTable(){
        getCurrencyViewModel.currencyPublish
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
            
            self.convertCurrencyViewModel.toCurrBehavior.accept(self.toBtn.title(for: .normal) ?? "")
             
        }).disposed(by: disposeBag)
    }
    
    func presentDataBtnActions(button: UIButton, table: UITableView){
        button.rx.tap.bind{ _ in
            table.isHidden = !table.isHidden
        }.disposed(by: disposeBag)
    }
}
