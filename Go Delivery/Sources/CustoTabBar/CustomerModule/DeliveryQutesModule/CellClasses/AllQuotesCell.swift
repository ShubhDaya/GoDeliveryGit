//
//  AllQuotesCell.swift
//  Go Delivery
//
//  Created by MACBOOK-SHUBHAM V on 27/07/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit

class AllQuotesCell: UITableViewCell {

//    @IBOutlet weak var imgQuotes: UIImageView!
//    @IBOutlet weak var lblDeliveryTypeName: UILabel!
//    @IBOutlet weak var lblAmount: UILabel!
//    @IBOutlet weak var btnAccept: UIButton!
//    @IBOutlet weak var btnReject: UIButton!
//    @IBOutlet weak var lblDescription: UILabel!
  
    @IBOutlet weak var btnAccept: UIButton!
    @IBOutlet weak var btnReject: UIButton!
    @IBOutlet weak var lblTypeName: UILabel!
    @IBOutlet weak var lbPriceDetail: UILabel!
    
    @IBOutlet weak var imgQuote: UIImageView!
    @IBOutlet weak var lblDescription: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
