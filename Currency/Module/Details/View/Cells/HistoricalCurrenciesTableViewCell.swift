//
//  HistoricalCurrenciesTableViewCell.swift
//  Currency
//
//  Created by Sohila on 06/06/2023.
//

import UIKit

class HistoricalCurrenciesTableViewCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
     
    override func awakeFromNib() {
        super.awakeFromNib()
        desginView(view: cellView)
         
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
 
    }
    
    func setCellData(fromLabel: String, toLabel: String, amountLabel: String, resultLabel: String) {
        self.fromLabel.text = fromLabel
        self.toLabel.text = toLabel
        self.amountLabel.text = amountLabel
        self.resultLabel.text = resultLabel
    }
    
    func desginView(view: UIView){
        view.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
    }
}
