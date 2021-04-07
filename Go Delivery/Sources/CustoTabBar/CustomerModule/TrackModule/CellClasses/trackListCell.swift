//
//  trackListCell.swift
//  Go Delivery
//
//  Created by MACBOOK-SHUBHAM V on 14/08/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit

import UIKit

class trackListCell: UITableViewCell {

    @IBOutlet weak var viewCellOuterShadow: UIView!
   
    @IBOutlet weak var imgDelivery: UIImageView!
    @IBOutlet weak var lblDeliveryType: UILabel!
    
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var imgverticalyDotLine: UIImageView!
    @IBOutlet weak var lblFromLocation: UILabel!
    @IBOutlet weak var btnChangeStatus: UIButton!
    @IBOutlet weak var lblTolocation: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    
    @IBOutlet weak var lblDateTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.viewCellOuterShadow.setShadowAllView5()
        self.imgUser.setImgCircle()
        self.imgDelivery.setImageFream()
              // self.viewVerticalDashLine.createDottedLine(width: 1.0, color: UIColor.gray.cgColor)
             //  self.viewHorizontaldashLine.createDottedLine2(width: 1.0, color: UIColor.gray.cgColor)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
