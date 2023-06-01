//
//  ViewController.swift
//  Currency
//
//  Created by Sohila on 31/05/2023.
//

import UIKit

class ConvertCourrencyViewController: UIViewController {

    @IBOutlet weak var fromBtn: UIButton!
    @IBOutlet weak var toBtn: UIButton!
    @IBOutlet weak var covertBtn: UIButton!
    @IBOutlet weak var fromTF: UITextField!
    @IBOutlet weak var toTF: UITextField!
    @IBOutlet weak var datailsBtn: UIButton!
    
    var convertCourrencyViewModel : ConvertCourrencyViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        convertCourrencyViewModel = ConvertCourrencyViewModel()
  
    }
   

    

}

