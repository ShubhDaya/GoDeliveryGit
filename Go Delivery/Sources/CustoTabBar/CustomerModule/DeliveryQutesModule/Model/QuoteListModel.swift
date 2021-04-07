//
//  QuoteListModel.swift
//  Go Delivery
//
//  Created by MACBOOK-SHUBHAM V on 27/08/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import Foundation
import Foundation
import UIKit

class QuoteListModel: NSObject {
    
    var strQuoteDeliveryTypeId : String = ""
     var strQuoteDescription : String = ""
     var strQuotePrice : String = ""
     var strQuoteStatus : String = ""
    
      
    
    init(dict:Dictionary<String, Any>) {
        
      if let price = dict["price"] as? String{
                  self.strQuotePrice = price
              }else if let price = dict["price"] as? Int{
                  self.strQuotePrice = String(price)
              }else if let price = dict["price"] as? Double{
                  self.strQuotePrice = String(price)
              }
        if let delivery_type_id = dict["delivery_type_id"] as? String{
                  self.strQuoteDeliveryTypeId = delivery_type_id
              }else if let delivery_type_id = dict["delivery_type_id"] as? Int{
                  self.strQuoteDeliveryTypeId = String(delivery_type_id)
              }
        
        if let description = dict["description"] as? String{
                  self.strQuoteDescription = description
              }
        
        if let status = dict["status"] as? String{
                  self.strQuoteStatus = status
              }else if let status = dict["status"] as? Int{
                  self.strQuoteStatus = String(status)
              }


    }
    
    
}
