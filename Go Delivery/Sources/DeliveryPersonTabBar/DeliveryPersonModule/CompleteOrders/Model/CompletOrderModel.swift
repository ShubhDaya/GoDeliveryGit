//
//  CompletOrderModel.swift
//  Go Delivery
//
//  Created by MACBOOK-SHUBHAM V on 07.12.20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import Foundation

import Foundation
import UIKit

class CompletOrderModel: NSObject {
    
    var strDelvieryId: String = ""
    var strdelivery_date: String = ""
    var strdelivery_time: String = ""
    var strfrom_Location: String = ""
    var strTo_Location: String = ""
    
    var strPhoto: String = ""
    var strRating: String = ""
    var strStatus: String = ""
    var StrTitle: String = ""
    
    
    
    init(dict : [String : Any]) {
        //    if let dictUser = dict["user_details"]as? [String:Any]{
        
        if let deliveryID = dict["deliveryID"]as? String{
            strDelvieryId = deliveryID
        }
        if let delivery_date = dict["delivery_date"]as? String{
            strdelivery_date = delivery_date
        }
        
        if let delivery_time = dict["delivery_time"]as? String{
            strdelivery_time = delivery_time
        }
        
        if let from_location = dict["from_location"]as? String{
            strfrom_Location = from_location
        }
        
        if let to_location = dict["to_location"]as? String{
            strTo_Location = to_location
        }
        if let photo = dict["photo"]as? String{
            strPhoto = photo
        }
        
        
        if let rating = dict["rating"]as? String{
            strRating = rating
        }else  if let rating = dict["rating"]as? Int{
                   strRating = String(rating)
        }else{
            strRating = ""

        }
        
        
        if let status = dict["status"]as? String{
            strStatus = status
        }else if let status = dict["status"]as? Int{
            strStatus = String(status)
        }
        
        if let title = dict["title"]as? String{
            StrTitle = title
        }
    }
    
}
