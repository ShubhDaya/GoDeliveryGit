//
//  CompleteOrderCell.swift
//  Go Delivery
//
//  Created by MACBOOK-SHUBHAM V on 23.11.20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit
import HCSStarRatingView

class CompleteOrderCell: UITableViewCell {

    @IBOutlet weak var imgDeliverdType: customImage!
    @IBOutlet weak var lblDeliveryTypeName: UILabel!
    @IBOutlet weak var lblDeliveryCreatedDate: UILabel!
    
    @IBOutlet weak var lblFromLocation: UILabel!
    @IBOutlet weak var lblToLocation: UILabel!
    @IBOutlet weak var viewRating: HCSStarRatingView!
    
    @IBOutlet weak var ViewCellouterBorderShodw: UIView!
   
    @IBOutlet weak var btnShowImg: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
  self.ViewCellouterBorderShodw.setShadowAllView5()
        self.viewRating.allowsHalfStars = false
        self.viewRating.maximumValue = 5
        self.viewRating.minimumValue = 0
        self.viewRating.isUserInteractionEnabled = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
