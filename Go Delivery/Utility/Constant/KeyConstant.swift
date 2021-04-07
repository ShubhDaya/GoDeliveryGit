//
//  KeyConstant.swift
//  Hoggz
//  Created by MACBOOK-SHUBHAM V on 27/12/19.
//  Copyright © 2019 MACBOOK-SHUBHAM V. All rights reserved.
//  KeyConstant.swift
//  Mualab
//  Created by MINDIII on 10/16/17.
//  Copyright © 2017 MINDIII. All rights reserved.
//

import Foundation
import UIKit


let userDefaults =  UserDefaults.standard
let objAppShareData : AppSharedClass  = AppSharedClass.shared

extension UserDefaults {
    
    enum Keys {
        static let strVenderId = "udid"
        static let strAccessToken = "access_token"
        static let AuthToken = "AuthToken"
        static let email = "email"
        static let user_FirstName = "username"
        static let user_LastName = "username"

        static let userID = "userID"
        static let status = "status"
        static let profileImg = "profileImg"
        static let password = "password"
        static let countryCode = "countryCode"
        static let is_favorite = "is_favorite"

        static let DPersonName = "DPersonName"
        static let DPersonImage = "DPersonImage"
        static let DPersonRating = "DPersonRating"
        
    }
}


 
