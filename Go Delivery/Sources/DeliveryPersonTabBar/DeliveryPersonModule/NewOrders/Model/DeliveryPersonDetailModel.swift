//
//  DeliveryPersonDetailModel.swift
//  Go Delivery
//
//  Created by MACBOOK-SHUBHAM V on 18.11.20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import Foundation
//
//  DeliveryDetailsModel.swift
//  Go Delivery
//
//  Created by MACBOOK-SHUBHAM V on 27/08/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import Foundation
import Foundation
import Foundation
import UIKit

class DeliveryPersonDetailModel: NSObject {
    
    //Accept Qoutes -
    var strdelivery_type_id  : String = ""
    var strAcceptQouteDescription: String = ""
    var strprice: String = ""
    var strdelivery_type_name: String = ""
    var strstatus_title: String = ""

    //Customer -
    
    var stremail: String = ""
    var strfirst_name : String = ""
    var strlast_name: String = ""
    var strphone_country_code: String = ""
    var strphone_dial_code : String = ""
    var strphone_number : String = ""
    var strprofile_picture : String = ""
    var struserID : String = ""
    var struser_type : String = ""
    
    //Delivery Person -
    
    var strDPersonEmail: String = ""
    var strDPersonFirst_name: String = ""
    var strDPersonlast_name : String = ""
    var strDPersonmiddle_name : String = ""
    var strDPersonphone_dial_code: String = ""
    var strDPersonphone_country_code: String = ""
    var strDPersonphone_number: String = ""
    var strDPersonprofile_picture: String = ""
    var strDPersonuserID: String = ""
    var strDPersonuser_type: String = ""
    var strDPRating: String = ""

    
    //delivery details -
    var strReviewGiven : String = ""
    var strCreated_by_id: String = ""
    var strDeliveryID:String  = ""
    var strdelivery_date: String = ""
    var strdelivery_person_user_id: String = ""
    var strdelivery_time: String = ""
    var strdescription: String = ""
    var strfrom_latitude: String = ""
    var strfrom_location: String = ""
    var strdimension_unit: String = ""
    var strfrom_longitude: String = ""
    var strHeight: String = ""
    var strLength: String = ""
    var strPhoto: String = ""
    var strstatus: String = ""
    var strto_latitude: String = ""
    var strto_location: String = ""
    var strto_longitude: String = ""
    var strweight: String = ""
 
    var strweight_unit: String = ""
    var strLength_unit: String = ""
    var strwidth_unit: String = ""
    var strhight_unit: String = ""

    var strwidth: String = ""
    
    var arrQuoteList = [QuoteListModel]()
    
    
    //
    
    // review -
       var strRevCreated_at: String = ""
       var strRevRating: String = ""
       var strRevReview: String = ""
       var strCurrentTime : String = ""
    

    init(dict : [String : Any]) {
        if let dictUser = dict["delivery_detail"]as? [String:Any]{
            
            if let created_by_id = dictUser["created_by_id"]as? String{
                strCreated_by_id = created_by_id
            }else if let created_by_id = dictUser["created_by_id"]as? Int{
                strCreated_by_id = String(created_by_id)
            }
            if let deliveryID = dictUser["deliveryID"]as? String{
                strDeliveryID = deliveryID
            }
            if let delivery_date = dictUser["delivery_date"]as? String{
                strdelivery_date = delivery_date
            }
            
            if let delivery_person_user_id = dictUser["delivery_person_user_id"]as? String{
                strdelivery_person_user_id = delivery_person_user_id
            }
            
            if let delivery_time = dictUser["delivery_time"]as? String{
                           strdelivery_person_user_id = delivery_time
                       }
            
         
            if let review = dictUser["review"]as? String{
                strReviewGiven = review
            }
            
            if let delivery_type_name = dictUser["delivery_type_name"]as? String{
                strdelivery_type_name = delivery_type_name
            }
            
            if let status_title = dictUser["status_title"]as? String{
                strstatus_title = status_title
            }
            if let delivery_person_user_id = dictUser["delivery_person_user_id"]as? String{
                strdelivery_person_user_id = delivery_person_user_id
            }
            if let delivery_time = dictUser["delivery_time"]as? String{
                strdelivery_time = delivery_time
            }
            
            
        
            
            
            
            
            if let description = dictUser["description"]as? String{
                strdescription = description
            }else{
                strdescription = ""
            }
     
            if let from_latitude = dictUser["from_latitude"]as? String{
                strfrom_latitude = from_latitude
            }
            if let from_location = dictUser["from_location"]as? String{
                strfrom_location = from_location
            }
            if let from_longitude = dictUser["from_longitude"]as? String{
                strfrom_longitude = from_longitude
            }
            if let height = dictUser["height"]as? String{
                strHeight = height
            }else if let height = dictUser["height"]as? Int{
                strHeight = String(height)
            }
            
            if let length = dictUser["length"]as? String{
                strLength = length
            }else if let length = dictUser["length"]as? Int{
                strLength = String(length)
            }
            
            if let photo = dictUser["photo"]as? String{
                strPhoto = photo
            }
            
            
            
            if let status = dictUser["status"]as? String{
                strstatus = status
            }else if let status = dictUser["status"]as? Int{
                strstatus = String(status)
            }
            
            if let to_latitude = dictUser["to_latitude"]as? String{
                strto_latitude = to_latitude
            }else if let to_latitude = dictUser["to_latitude"]as? Int{
                strto_latitude = String(to_latitude)
            }
            
            
            if let to_location = dictUser["to_location"]as? String{
                strto_location = to_location
            }
            
            if let to_longitude = dictUser["to_longitude"]as? String{
                strto_longitude = to_longitude
            }
            
            if let weight = dictUser["weight"]as? String{
                strweight = weight
            }
            
          
            
            if let height_unit = dictUser["height_unit"]as? String{
                strhight_unit = height_unit
            }else if let height_unit = dictUser["height_unit"]as? Int{
                strhight_unit = String(height_unit)
            }
            
            if let length_unit = dictUser["length_unit"]as? String{
                strLength_unit = length_unit
            }else if let length_unit = dictUser["length_unit"]as? Int{
                strLength_unit = String(length_unit)
            }
            
            if let weight_unit = dictUser["weight_unit"]as? String{
                strweight_unit = weight_unit
            }else if let weight_unit = dictUser["weight_unit"]as? Int{
                strweight_unit = String(weight_unit)
            }
            
            if let width_unit = dictUser["width_unit"]as? String{
                strwidth_unit = width_unit
            }else if let width_unit = dictUser["width_unit"]as? Int{
                strwidth_unit = String(width_unit)
            }
            
            if let width = dictUser["width"]as? String{
                strwidth = width
            }else if let width = dictUser["width"]as? Int{
                strwidth = String(width)
            }
            
            if let dictUser = dictUser["accepted_quote"]as? [String:Any]{
                
                if let delivery_type_id = dictUser["delivery_type_id"]as? String{
                    strdelivery_type_id = delivery_type_id
                }else if let delivery_type_id = dictUser["delivery_type_id"]as? Int{
                    strdelivery_type_id = String(delivery_type_id)
                }
                if let description = dictUser["description"]as? String{
                    strAcceptQouteDescription = description
                }
                
                if let price = dictUser["price"]as? String{
                    strprice = price
                }
                
            }else{
                strdelivery_type_id = ""
                strdelivery_type_id = ""
                strAcceptQouteDescription = ""
                strprice = ""
                
                
            }
            
            
            if let dictUser = dictUser["customer"]as? [String:Any]{
                
                if let email = dictUser["email"]as? String{
                    stremail = email
                }
                if let first_name = dictUser["first_name"]as? String{
                    strfirst_name = first_name
                }
                
                if let last_name = dictUser["last_name"]as? String{
                    strlast_name = last_name
                }
                
                if let phone_country_code = dictUser["phone_country_code"]as? String{
                    strphone_country_code = phone_country_code
                }
                if let phone_dial_code = dictUser["phone_dial_code"]as? String{
                    strphone_dial_code = phone_dial_code
                }
                
                if let phone_number = dictUser["phone_number"]as? String{
                    strphone_number = phone_number
                }
                
                if let profile_picture = dictUser["profile_picture"]as? String{
                    strprofile_picture = profile_picture
                }
                if let userID = dictUser["userID"]as? String{
                    struserID = userID
                }
                
                if let user_type = dictUser["user_type"]as? String{
                    struser_type = user_type
                }
         
            }
            
            
            if let dictUser = dictUser["delivery_person"]as? [String:Any]{
                
                if let email = dictUser["email"]as? String{
                    strDPersonEmail = email
                }
                if let first_name = dictUser["first_name"]as? String{
                    strDPersonFirst_name = first_name
                }
                
                if let last_name = dictUser["last_name"]as? String{
                    strDPersonlast_name = last_name
                }
                
                if let middle_name = dictUser["middle_name"]as? String{
                                   strDPersonmiddle_name = middle_name
                               }
                if let phone_country_code = dictUser["phone_country_code"]as? String{
                    strDPersonphone_country_code = phone_country_code
                }
                if let phone_dial_code = dictUser["phone_dial_code"]as? String{
                    strDPersonphone_dial_code = phone_dial_code
                }
                
                if let phone_number = dictUser["phone_number"]as? String{
                    strDPersonphone_number = phone_number
                }
                
                if let profile_picture = dictUser["profile_picture"]as? String{
                    strDPersonprofile_picture = profile_picture
                }
                if let userID = dictUser["userID"]as? String{
                    strDPersonuserID = userID
                }
                
                if let user_type = dictUser["user_type"]as? String{
                    strDPersonuser_type = user_type
                }
                
                if let rating = dictUser["rating"]as? String{
                    strDPRating = rating
                }else if let rating = dictUser["rating"]as? Int{
                    strDPRating = String(rating)
                }
            }
            
            
            if let dicR = dictUser["review"]as? [String:Any]{
                        strReviewGiven = "1"

                        if let created_at = dicR["created_at"]as? String{
                            strRevCreated_at = created_at
                        }
                        
                
                   if let current_time = dicR["current_time"]as? String{
                         strCurrentTime = current_time
                    }
                        if let review = dicR["review"]as? String{
                            strRevReview = review
                        }
                        
                        if let rating = dicR["rating"]as? String{
                            strRevRating = rating
                        }else if let rating = dicR["rating"]as? String{
                            strRevRating = rating
                        }
                        
            }else{
                strReviewGiven = "0"
                
            }
            
 
            
          
           
                 if let arrReqData1 = dictUser["quote_list"] as? [Any]{
                     for dictGetData1 in arrReqData1
                     {
                         let obj = QuoteListModel.init(dict: dictGetData1 as! Dictionary<String, Any>)
                         self.arrQuoteList.append(obj)
                     

                       
                     }
                   print(" array trancation amount - \(arrQuoteList.count)")
                 }else{
                     arrQuoteList = [QuoteListModel]()
                 }
            
        }
    }
    
}
