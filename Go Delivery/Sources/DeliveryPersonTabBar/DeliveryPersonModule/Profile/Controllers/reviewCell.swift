//
//  reviewCell.swift
//  Go Delivery
//
//  Created by MACBOOK-SHUBHAM V on 10.12.20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit
import HCSStarRatingView

class reviewCell: UITableViewCell {

    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var viewProfile: UIView!
    @IBOutlet weak var lblCustomerName: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblReviewtext: UILabel!
    @IBOutlet weak var viewRating: HCSStarRatingView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.imgProfile.setImageFream()
        self.viewProfile.setviewCirclewhite()
        self.viewProfile.setshadowViewCircle2()
        self.viewRating.allowsHalfStars = false
        self.viewRating.maximumValue = 5
        self.viewRating.minimumValue = 0
        viewRating.isUserInteractionEnabled = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
