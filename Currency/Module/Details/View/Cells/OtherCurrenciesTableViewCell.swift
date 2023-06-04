//
//  OtherCurrenciesTableViewCell.swift
//  Currency
//
//  Created by Sohila on 04/06/2023.
//

import UIKit

class OtherCurrenciesTableViewCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var currName: UILabel!
    @IBOutlet weak var currRate: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        desginView(view: cellView)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
 
    }

    func setCellData(currName: String, currRate: String) {
        self.currName.text = currName
        self.currRate.text = currRate
    }
    
    func desginView(view: UIView){
        view.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
    }
}
