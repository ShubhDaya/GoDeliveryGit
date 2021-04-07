//
//  CardListCell.swift
//  Go Delivery
//
//  Created by MACBOOK-SHUBHAM V on 04/08/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit

class CardListCell: UITableViewCell {

    @IBOutlet weak var imgCard: UIImageView!
    @IBOutlet weak var lblCardName: UILabel!
    @IBOutlet weak var lblCardNumber: UILabel!
    @IBOutlet weak var lblDefault: UILabel!
    @IBOutlet weak var btnmakeDefault: UIButton!
    @IBOutlet weak var lblValidDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
