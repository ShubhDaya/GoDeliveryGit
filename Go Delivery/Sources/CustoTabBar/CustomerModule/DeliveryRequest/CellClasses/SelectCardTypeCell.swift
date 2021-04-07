//
//  SelectCardTypeCell.swift
//  Go Delivery
//
//  Created by MACBOOK-SHUBHAM V on 04/08/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit

class SelectCardTypeCell: UITableViewCell {

    @IBOutlet weak var viewForShadow: UIView!
    @IBOutlet weak var imgSelected: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.viewForShadow.setShadowAllView5()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
