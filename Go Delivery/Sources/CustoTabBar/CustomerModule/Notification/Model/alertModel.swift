//
//  alertModel.swift
//  Go Delivery
//
//  Created by MACBOOK-SHUBHAM V on 15/10/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import Foundation
import Foundation

import Foundation
import UIKit

class alertModel: NSObject {
     
    var stralertID  : String = ""
    var strcreated_at: String = ""
    var stris_read: String = ""
    var strmeta_data: String = ""
    var strparent_id : String = ""
    var strparent_type: String = ""
    var strrecipient_user_id: String = ""
    var strreference_id: String = ""
    var strsender_user_id : String = ""
    var strtype: String = ""
    var strupdated_at: String = ""
    var strdelivery_person_first_name: String = ""
    var strlastName: String = ""
    var strdeliverytype:String = ""
    var strdelivery_person_middle_name: String = ""
   var strdelivery_person_last_name: String = ""
    var strPhoto:String = ""
    var strcurrent_time:String = ""
    
    // list for delivery person sid e
    
    var strcustomer_first_name: String = ""
    var strcustomer_last_name: String = ""
    
    var strcolor: String = ""
    var strmake: String = ""
    var strmodel: String = ""
    var strplate_number: String = ""


    
    init(dict : [String : Any]) {
    //    if let dictUser = dict["user_details"]as? [String:Any]{
            
            if let alertID = dict["alertID"]as? String{
                stralertID = alertID
            }else if let alertID = dict["alertID"]as? Int{
               stralertID = String(alertID)
            }
        
           if let created_at = dict["created_at"]as? String{
            strcreated_at = created_at
           }
        
        if let current_time = dict["current_time"]as? String{
         strcurrent_time = current_time
        }else if let current_time = dict["current_time"]as? Int{
                strcurrent_time = String(current_time)
               }
        
        
        if let customer_first_name = dict["customer_first_name"]as? String{
                strcustomer_first_name = customer_first_name
               }
               
        if let customer_last_name = dict["customer_last_name"]as? String{
                strcustomer_last_name = customer_last_name
             }
        
        
        
        if let delivery_person_first_name = dict["delivery_person_first_name"]as? String{
         strdelivery_person_first_name = delivery_person_first_name
        }
        
        if let delivery_person_middle_name = dict["delivery_person_middle_name"]as? String{
                strdelivery_person_middle_name = delivery_person_middle_name
               }
        
        if let delivery_person_last_name = dict["delivery_person_last_name"]as? String{
         strdelivery_person_last_name = delivery_person_last_name
        }
        
            if let is_read = dict["is_read"]as? String{
                stris_read = is_read
            }else if let is_read = dict["is_read"]as? Int{
                stris_read = String(is_read)
            }
        
        if let last_name = dict["last_name"]as? String{
         strlastName = last_name
        }
        
            if let meta_data = dict["meta_data"]as? String{
                strmeta_data = meta_data
            }
            
            if let parent_id = dict["parent_id"]as? String{
                strparent_id = parent_id
            }else if let parent_id = dict["parent_id"]as? Int{
                strparent_id = String(parent_id)

            }
            if let parent_type = dict["parent_type"]as? String{
                strparent_type = parent_type
            }

           if let recipient_user_id = dict["recipient_user_id"]as? String{
            strrecipient_user_id = recipient_user_id
           }else if let recipient_user_id = dict["recipient_user_id"]as? Int{
            strrecipient_user_id = String(recipient_user_id)
           }
        
            if let reference_id = dict["reference_id"]as? String{
                strreference_id = reference_id
            }else  if let reference_id = dict["reference_id"]as? Int{
                strreference_id = String(reference_id)
            }
        
            if let sender_user_id = dict["sender_user_id"]as? String{
                strsender_user_id = sender_user_id
            }else if let sender_user_id = dict["sender_user_id"]as? Int{
                strsender_user_id = String(sender_user_id)
            }
            
            if let title = dict["title"]as? String{
                strdeliverytype = title
            }
        if let type = dict["type"]as? String{
            strtype = type
        }

            if let updated_at = dict["updated_at"]as? String{
                strupdated_at = updated_at
            }
        if let photo = dict["photo"]as? String{
                     strPhoto = photo
                 }
                
        if let color = dict["color"]as? String{
         strcolor = color
        }else{
            strcolor = ""
        }
        
        if let make = dict["make"]as? String{
         strmake = make
        }else{
            strmake = ""
        }
        
        if let model = dict["model"]as? String{
         strmodel = model
        }else{
            strmodel = ""
        }
        
        if let plate_number = dict["plate_number"]as? String{
         strplate_number = plate_number
        }else{
            strplate_number = ""
        }
             
        
        
    }
    
}
