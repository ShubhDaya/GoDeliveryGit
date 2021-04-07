//
//  TrackListModel.swift
//  Go Delivery
//
//  Created by MACBOOK-SHUBHAM V on 01/09/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import Foundation
import UIKit

class TrackListModel: NSObject {
     
    var strCreatedById  : String = ""
    var strDelvieryId: String = ""
    var strCreatedAt: String = ""
    var strdelivery_date: String = ""
    var strdelivery_person_user_id : String = ""
    var strdelivery_time: String = ""
    var strdelivery_type_name: String = ""
    var strdescription: String = ""
    var strdimension_unit : String = ""
    var strfrom_latitude: String = ""
    var strfrom_location: String = ""
    var strfrom_longitude : String = ""
    var strto_location : String = ""
    var strheight: String = ""
    var strlength: String = ""
    var strphoto: String = ""
    var strquote_count: String = ""
    var strstatus:String  = ""
    var strstatus_updated_at: String = ""
    var strto_latitude: String = ""
    var strto_longitude: String = ""
    var strupdated_at: String = ""
    var strweight: String = ""
    var strweight_unit: String = ""
    var strwidth_unit: String = ""

    var strwidth: String = ""
    var strdeliveryPersonUserId = ""
    var strHightUnit = ""
    var strlenghtUnit = ""
    var strIsDeleted = ""
    var strOrderId = ""
    var strStatusTitle = ""
    var strProfile_picture: String = ""




    
    init(dict : [String : Any]) {
    //    if let dictUser = dict["user_details"]as? [String:Any]{
            
            if let created_at = dict["created_at"]as? String{
                strCreatedAt = created_at
            }
        
           if let created_by_id = dict["created_by_id"]as? String{
            strCreatedById = created_by_id
           }
            if let deliveryID = dict["deliveryID"]as? String{
                strDelvieryId = deliveryID
            }
            if let delivery_date = dict["delivery_date"]as? String{
                strdelivery_date = delivery_date
            }
        if let delivery_person_user_id = dict["delivery_person_user_id"]as? String{
            strdeliveryPersonUserId = delivery_person_user_id
        }
            
            if let delivery_person_user_id = dict["delivery_person_user_id"]as? String{
                strdelivery_person_user_id = delivery_person_user_id
            }
            if let delivery_time = dict["delivery_time"]as? String{
                strdelivery_time = delivery_time
            }
        
        if let delivery_type_name = dict["delivery_type_name"]as? String{
                       strdelivery_type_name = delivery_type_name
                   }
        
        
        if let profile_picture = dict["profile_picture"]as? String{
                strProfile_picture = profile_picture
            }else{
                strProfile_picture = ""
            }
            
            
        
        
            if let description = dict["description"]as? String{
                strdescription = description
            }
           
            if let from_latitude = dict["from_latitude"]as? String{
                strfrom_latitude = from_latitude
            }
            if let from_location = dict["from_location"]as? String{
                strfrom_location = from_location
            }
            if let from_longitude = dict["from_longitude"]as? String{
                strfrom_longitude = from_longitude
            }
            if let height = dict["height"]as? String{
                strheight = height
            }
            if let length = dict["length"]as? String{
                strlength = length
            }
       
            if let height_unit = dict["height_unit"]as? String{
                       strHightUnit = height_unit
                   }else if let height_unit = dict["height_unit"]as? Int{
                       strHightUnit = String(height_unit)
                   }
            if let length_unit = dict["length_unit"]as? String{
                       strlenghtUnit = length_unit
                   }else if let length_unit = dict["length_unit"]as? Int{
                       strlenghtUnit = String(length_unit)
                   }
        
         if let is_deleted = dict["is_deleted"]as? String{
                              strIsDeleted = is_deleted
                          }else if let is_deleted = dict["is_deleted"]as? Int{
                              strIsDeleted = String(is_deleted)
                          }
       
            if let photo = dict["photo"]as? String{
                strphoto = photo
            }
        
           if let order_id = dict["order_id"]as? String{
                strOrderId = order_id
           }
        
            if let quote_count = dict["quote_count"]as? String{
                strquote_count = quote_count
            }
            
        if let status_title = dict["status_title"]as? String{
            strStatusTitle = status_title
        }
            
            if let status = dict["status"]as? String{
                strstatus = status
            }else if let status = dict["status"]as? Int{
                strstatus = String(status)
            }
            
            if let to_latitude = dict["to_latitude"]as? String{
                strto_latitude = to_latitude
            }else if let to_latitude = dict["to_latitude"]as? Int{
                strto_latitude = String(to_latitude)
            }
            
            
            if let to_location = dict["to_location"]as? String{
                strto_location = to_location
            }
            
            if let to_longitude = dict["to_longitude"]as? String{
                strto_longitude = to_longitude
            }
            
            if let updated_at = dict["updated_at"]as? String{
                strupdated_at = updated_at
            }
        if let weight = dict["weight"]as? String{
            strweight = weight
        }
        if let weight_unit = dict["weight_unit"]as? String{
            strweight = weight_unit
        }else if let weight_unit = dict["weight_unit"]as? Int{
            strweight = String(weight_unit)
        }
        if let width = dict["width"]as? String{
            strwidth = width
        }
        if let width_unit = dict["width_unit"]as? String{
                   strwidth_unit = width_unit
               }else if let width_unit = dict["width_unit"]as? Int{
                   strwidth_unit = String(width_unit)
        }
    }
    
}
