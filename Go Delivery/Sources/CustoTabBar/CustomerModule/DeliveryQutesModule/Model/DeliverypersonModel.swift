//
//  DeliverypersonModel.swift
//  Go Delivery
//
//  Created by MACBOOK-SHUBHAM V on 09/09/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import Foundation
class DeliverypersonModel: NSObject {
     
  
    // delivery_person_detail -
    
    var strFirst_name: String = ""
    var strLast_name: String = ""
    var strMiddle_name : String = ""
    var strProfile_picture: String = ""
    var strDpRating: String = ""
    var strUserID : String = ""
    var arrQuoteList = [CompletedListModel]()


    
    init(dict : [String : Any]) {
        if let dictUser = dict["delivery_person_detail"]as? [String:Any]{
            
            if let first_name = dictUser["first_name"]as? String{
                strFirst_name = first_name
            }
        
           if let last_name = dictUser["last_name"]as? String{
            strLast_name = last_name
           }
            
            if let middle_name = dictUser["middle_name"]as? String{
                strMiddle_name = middle_name
            }
            
            if let profile_picture = dictUser["profile_picture"]as? String{
                strProfile_picture = profile_picture
            }
            
            if let rating = dictUser["rating"]as? String{
                strDpRating = rating
            }else if let rating = dictUser["rating"]as? Int{
                
                strDpRating = String(rating)
            }
            if let userID = dictUser["userID"]as? String{
                strUserID = userID
            }else if let userID = dictUser["userId"]as? Int{
                strUserID = String(userID)
            }
  
    }
        
        if let arrReqData1 = dict["completed_order_list"] as? [Any]{
                         for dictGetData1 in arrReqData1
                         {
                             let obj = CompletedListModel.init(dict: dictGetData1 as! Dictionary<String, Any>)
                             self.arrQuoteList.append(obj)
                          

                         }
                       print(" array trancation amount - \(arrQuoteList.count)")
                     }else{
                         arrQuoteList = [CompletedListModel]()
                     }
//if let dictUser = dict["accepted_quote"]as? [String:Any]{
//           
//           if let delivery_type_id = dictUser["delivery_type_id"]as? String{
//               strdelivery_type_id = delivery_type_id
//           }else if let delivery_type_id = dictUser["delivery_type_id"]as? Int{
//               strdelivery_type_id = String(delivery_type_id)
//           }
//           if let description = dictUser["description"]as? String{
//               strAcceptQouteDescription = description
//           }
//           
//           if let price = dictUser["price"]as? String{
//               strprice = price
//           }
//           
//       }
    
}
}


class CompletedListModel: NSObject {
    
   
    // Complete order List -
    var strDeliveryID  : String = ""
    var strDelivery_date: String = ""
    var strDelivery_time: String = ""
    var strFrom_location: String = ""
    var strRating : String = ""
    var strToLocation: String = ""
    
      
    
    init(dict:Dictionary<String, Any>) {
        
     if let deliveryID = dict["deliveryID"]as? String{
                    strDeliveryID = deliveryID
                }else if let deliveryID = dict["deliveryID"]as? Int{
                    strDeliveryID = String(deliveryID)
                }
            
               if let delivery_date = dict["delivery_date"]as? String{
                strDelivery_date = delivery_date
               }
                
                if let delivery_time = dict["delivery_time"]as? String{
                    strDelivery_time = delivery_time
                }
                
                if let from_location = dict["from_location"]as? String{
                    strFrom_location = from_location
                }
                
                if let rating = dict["rating"]as? String{
                    strRating = rating
                }else if let rating = dict["rating"]as? Int{
                    
                    strRating = String(rating)
                }
                if let to_location = dict["to_location"]as? String{
                    strToLocation = to_location
                }

    }
    
    
}
