//
//  FromTableViewCell.swift
//  Currency
//
//  Created by Sohila on 02/06/2023.
//

import UIKit

class FromTableViewCell: UITableViewCell {
    
    @IBOutlet weak var fromLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCellData(label: String) {
        fromLabel.text = label
    }
    
    func getData() -> String{
        return fromLabel.text ?? ""
    }

}
