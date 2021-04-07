//
//  NotificationCell.swift
//  Go Delivery
//
//  Created by MACBOOK-SHUBHAM V on 08/09/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {
    
    @IBOutlet weak var viewForBGcolor: UIView!
    @IBOutlet weak var imgView:UIImageView!
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblTimeAgo:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.imgView.setImageFream()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
