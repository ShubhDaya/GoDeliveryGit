//
//  DeliveryTypeCell.swift
//  Go Delivery
//
//  Created by MACBOOK-SHUBHAM V on 24/07/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit

class DeliveryTypeCell: UITableViewCell {

    @IBOutlet weak var lblDeliveryType: UILabel!
    @IBOutlet weak var imgSelectedImage: UIImageView!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
