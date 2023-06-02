//
//  ToTableViewCell.swift
//  Currency
//
//  Created by Sohila on 02/06/2023.
//

import UIKit

class ToTableViewCell: UITableViewCell {

    @IBOutlet weak var toLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCellData(label: String) {
        toLabel.text = label
    }
    
    func getData() -> String{
        return toLabel.text ?? ""
    }
}
