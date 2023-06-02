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
    
    var convertCourrencyViewModel: GetCourrencyViewModelProtocol = GetCourrencyViewModel()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        
        fromTableView.isHidden = true
        toTableView.isHidden = true
        btnActions(button: fromBtn, table: self.fromTableView)
        btnActions(button: toBtn, table: self.toTableView)
        subscribeforFromTable()
        subscribeforToTable()
        convertCourrencyViewModel.viewDidLoad()
        
    }
    
    func subscribeforFromTable(){
        convertCourrencyViewModel.currencyPublish
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
//            self.fromBtn.setImage(nil, for: .normal)
            self.fromTableView.isHidden = true
        }).disposed(by: disposeBag)
    }
    
    func subscribeforToTable(){
        convertCourrencyViewModel.currencyPublish
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
//            self.toBtn.setImage(nil, for: .normal)
            self.toTableView.isHidden = true
        }).disposed(by: disposeBag)
    }
    
    func btnActions(button: UIButton, table: UITableView){
        button.rx.tap.bind{ [weak self] in
            guard let self = self else { return }
            table.isHidden = false
        }.disposed(by: disposeBag)
    }
    
}

