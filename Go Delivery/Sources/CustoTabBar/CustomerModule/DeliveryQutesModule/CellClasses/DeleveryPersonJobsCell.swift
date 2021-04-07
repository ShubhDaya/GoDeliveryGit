//
//  DeleveryPersonJobsCell.swift
//  Go Delivery
//
//  Created by MACBOOK-SHUBHAM V on 07/09/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit
import HCSStarRatingView

class DeleveryPersonJobsCell: UITableViewCell {

    @IBOutlet weak var viewForRadius: UIView!
    @IBOutlet weak var lblFromAddress: UILabel!
    @IBOutlet weak var lblToAddress: UILabel!
    @IBOutlet weak var lblDateAndTIme: UILabel!
    @IBOutlet weak var viewReviewRating: HCSStarRatingView!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        self.viewForRadius.setShadowAllView5()

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
