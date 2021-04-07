//
//  ReviewModel.swift
//  Go Delivery
//
//  Created by MACBOOK-SHUBHAM V on 10.12.20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//



import Foundation
import UIKit

class ReviewModel: NSObject {
    
    var strcreated_at: String = ""
    var strdelivery_id: String = ""
    var strfirst_name: String = ""
    var strlast_name : String = ""
    var strprofile_picture: String = ""
    var strrating: String = ""
    var strreview: String = ""
    var strreviewID : String = ""
    var strreviewed_by_id: String = ""
    var strstatus: String = ""
    var strcurrent_time: String = ""

    
    
    
    
    init(dict : [String : Any]) {
        //    if let dictUser = dict["user_details"]as? [String:Any]{
        
        if let delivery_id = dict["delivery_id"]as? String{
            strdelivery_id = delivery_id
        }else if let delivery_id = dict["delivery_id"]as? Int{
            strdelivery_id = String(delivery_id)
        }
        
        if let created_at = dict["created_at"]as? String{
            strcreated_at = created_at
        }
        if let currentTime = dict["current_time"]as? String{
            strcurrent_time = currentTime
        }
        

        
        
        if let first_name = dict["first_name"]as? String{
            strfirst_name = first_name
        }
        
        if let last_name = dict["last_name"]as? String{
            strlast_name = last_name
        }
        
        
        
        if let profile_picture = dict["profile_picture"]as? String{
            strprofile_picture = profile_picture
        }
        
        if let rating = dict["rating"]as? String{
            strrating = rating
        }else if let rating = dict["rating"]as? Int{
            strrating = String(rating)
        }
        
        if let review = dict["review"]as? String{
            strreview = review
        }
        
        if let reviewID = dict["reviewID"]as? String{
            strreviewID = reviewID
        }else if let reviewID = dict["reviewID"]as? Int{
            strreviewID = String(reviewID)
        }
        
        if let reviewed_by_id = dict["reviewed_by_id"]as? String{
            strreviewed_by_id = reviewed_by_id
        }else if let reviewed_by_id = dict["reviewed_by_id"]as? String{
            strreviewed_by_id = reviewed_by_id
        }
        
        if let status = dict["status"]as? String{
            strstatus = status
        }else if let status = dict["status"]as? Int{
            strstatus = String(status)
        }
        
        
        
    }
    
}
