//
//  DeliveryQuotesCell.swift
//  Go Delivery
//
//  Created by MACBOOK-SHUBHAM V on 25/07/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit

class DeliveryQuotesCell: UITableViewCell {

    @IBOutlet weak var lblDeliveryCount: UILabel!
    @IBOutlet weak var viewCellOuterShadow: UIView!
   
    @IBOutlet weak var viewCountView: customView!
    @IBOutlet weak var viewVerticalDashLine: UIView!
    @IBOutlet weak var viewHorizontaldashLine: UIView!
    @IBOutlet weak var imgDelivery: UIImageView!
    @IBOutlet weak var lblDeliveryType: UILabel!
    @IBOutlet weak var lblDateTime: UILabel!
    
    @IBOutlet weak var imgverticalyDotLine: UIImageView!
    @IBOutlet weak var lblFromLocation: UILabel!
    
    @IBOutlet weak var lblTolocation: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.viewCellOuterShadow.setShadowAllView5()
        
              // self.viewVerticalDashLine.createDottedLine(width: 1.0, color: UIColor.gray.cgColor)
             //  self.viewHorizontaldashLine.createDottedLine2(width: 1.0, color: UIColor.gray.cgColor)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
