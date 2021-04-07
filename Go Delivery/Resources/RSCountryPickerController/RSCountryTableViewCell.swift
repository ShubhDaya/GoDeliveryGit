//
//  RSCountryTableViewCell.swift
//  Bang
//
//  Created by RohitSingh-MacMINI on 07/05/19.
//  Copyright © 2019 mindiii. All rights reserved.
//

import UIKit

class RSCountryTableViewCell: UITableViewCell {

    @IBOutlet var imgCountryFlag: UIImageView!
    @IBOutlet var lblCountryName: UILabel!
    @IBOutlet var lblCountryDialCode: UILabel!
    @IBOutlet var imgRadioCheck: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       imgCountryFlag.setImgCircle()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
