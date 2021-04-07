//
//  GeneralListModel.swift
//  Go Delivery
//
//  Created by MACBOOK-SHUBHAM V on 13/08/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import Foundation
class GeneralListModel: NSObject {

    var arrDeliveryTypeList = [deliveryListTypeModel]()
    var arrlenght = [length_unit_listModel]()
    var arrHeight = [height_unit_listModel]()
    var arrwidth = [width_unit_listModel]()
    var arrwightUnitList = [weightUnitListModel]()
    
    init(dict:[String:Any]){
        if let agelist = dict["delivery_types_list"] as? [[String:Any]]{
            self.arrDeliveryTypeList.removeAll()
            for obj in agelist{
                let objModel = deliveryListTypeModel.init(dict: obj)
                self.arrDeliveryTypeList.append(objModel)
            }
        }
        
        if let experienceList = dict["height_unit_list"] as? [[String:Any]]{
            self.arrHeight.removeAll()
            for obj in experienceList{
                let objModel = height_unit_listModel.init(dict: obj)
                self.arrHeight.append(objModel)
            }
        }
        
        if let experienceList = dict["length_unit_list"] as? [[String:Any]]{
                   self.arrlenght.removeAll()
                   for obj in experienceList{
                       let objModel = length_unit_listModel.init(dict: obj)
                       self.arrlenght.append(objModel)
                   }
               }
        
        if let experienceList = dict["width_unit_list"] as? [[String:Any]]{
                  self.arrwidth.removeAll()
                  for obj in experienceList{
                      let objModel = width_unit_listModel.init(dict: obj)
                      self.arrwidth.append(objModel)
                  }
              }
    }
}
class deliveryListTypeModel: NSObject {
    var strDeliveryTypeId = ""
    var strtitle = ""
    
    init(dict:[String:Any]){
        
        if let title = dict["title"] as? String{
            self.strtitle = title
        }
        
        if let deliveryTypeID = dict["deliveryTypeID"] as? String{
            self.strDeliveryTypeId = deliveryTypeID
        }else if let deliveryTypeID = dict["deliveryTypeID"] as? Int{
            self.strDeliveryTypeId = String(deliveryTypeID)
        }
    }
}

 class length_unit_listModel: NSObject {
     var strId = ""
     var strValue = ""
    
     
     init(dict:[String:Any]){
         
         if let value = dict["value"] as? String{
             self.strValue = value
         }
         
         if let id = dict["id"] as? String{
             self.strId = id
         }else if let id = dict["id"] as? Int{
             self.strId = String(id)
         }
     }
 }

class width_unit_listModel: NSObject {
    var strId = ""
    var strValue = ""
   
    
    init(dict:[String:Any]){
        
        if let value = dict["value"] as? String{
            self.strValue = value
        }
        
        if let id = dict["id"] as? String{
            self.strId = id
        }else if let id = dict["id"] as? Int{
            self.strId = String(id)
        }

    }
}

class height_unit_listModel: NSObject {
    var strId = ""
    var strValue = ""
   
    
    init(dict:[String:Any]){
        
        if let value = dict["value"] as? String{
            self.strValue = value
        }
        
        if let id = dict["id"] as? String{
            self.strId = id
        }else if let id = dict["id"] as? Int{
            self.strId = String(id)
        }
    }
}
class weightUnitListModel: NSObject {
    var strId = ""
    var strValue = ""
   
    
    init(dict:[String:Any]){
        
        if let value = dict["value"] as? String{
            self.strValue = value
        }
        
        if let id = dict["id"] as? String{
            self.strId = id
        }else if let id = dict["id"] as? Int{
            self.strId = String(id)
        }
    }
}
