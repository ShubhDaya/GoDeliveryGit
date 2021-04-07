//
//  MyProfileModel.swift
//  Go Delivery
//
//  Created by MACBOOK-SHUBHAM V on 17/08/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import Foundation

class MyProfileModel: NSObject {
    
    //custome rside-
    var strUserFirstName: String = ""
    var strUserlastName: String = ""
    var strUserMiddleName: String = ""

    var strEmail: String = ""
    var strCountry_code : String = ""
    var strPhone_number: String = ""
    var strProfile_picture: String = ""
    
    // Delivery side -
    var strcountry: String = ""
    var stremail: String = ""
    var strlocation: String = ""
    var strphone_dial_code: String = ""
    var strphone_number: String = ""
    var strrating: String = ""
    var struserID: String = ""
    var struser_type: String = ""
    var stris_available: String = ""
    var stris_profile_approved: String = ""
    
    var strcolor : String = ""
    var strmake : String = ""
    var strmodele : String = ""
    var strphone_country_code : String = ""
    var strplate_number : String = ""
    var reviewed_to_id : String = ""
    var strvehicleID : String = ""
    
    var stris_contract_updated : String = ""


    var strcharacter_certificate_file: String = ""
    var strdriver_license_file: String = ""
    var strnational_insurance_file: String = ""
    var strpassport_file : String = ""
    var strsigned_contract_form_file: String = ""
    var strsigned_contract_form_file_metadata: String = ""
    var strvehicle_insurance_file: String = ""
    var strcontract_signed_at: String = ""
        
    init(dict : [String : Any]) {
        
        
        if let firstname = dict["first_name"]as? String{
            strUserFirstName = firstname
        }else{
           strUserFirstName = ""

        }
        if let LastName = dict["last_name"]as? String{
            strUserlastName = LastName
        }else{
            strUserlastName = ""

        }
        
        if let middle_name = dict["middle_name"]as? String{
            strUserMiddleName = middle_name
        }else{
            strUserMiddleName = ""

        }
        
        if let email = dict["email"]as? String{
            strEmail = email
        }else{
            strEmail = ""
        }
        if let country_code = dict["phone_dial_code"]as? String{
            strCountry_code = country_code
        }
        else{
            strCountry_code = ""
        }
        if let phone_number = dict["phone_number"]as? String{
            strPhone_number = phone_number
        }else if let phone_number = dict["phone_number"]as? Int{
            strPhone_number = String(phone_number)
        }
        else{
            strPhone_number = ""
        }
    
        if let profile_picture = dict["profile_picture"]as? String{
            strProfile_picture = profile_picture
        }else{
            strProfile_picture = ""
        }
        
        //delivery person -
        if let color = dict["color"]as? String{
            strcolor = color
        }else{
            strcolor = ""
        }
        
        if let country = dict["country"]as? String{
                   strcountry = country
               }else{
                   strcountry = ""
        }
        if let is_available = dict["is_available"]as? String{
                    stris_available = is_available
        }else if let is_available = dict["is_available"]as? Int{
                    stris_available = String(is_available)
        }else{
                stris_available = ""
            }
        
        if let is_profile_approved = dict["is_profile_approved"]as? String{
                stris_profile_approved = is_profile_approved
               }else{
                stris_profile_approved = ""
            }
        if let location = dict["location"]as? String{
                       strlocation = location
                      }else{
                       strlocation = ""
                   }
        if let make = dict["make"]as? String{
                            strmake = make
                           }else{
                            strmake = ""
                        }
        if let model = dict["model"]as? String{
                            strmodele = model
                           }else{
                            strmodele = ""
                        }
        if let phone_country_code = dict["phone_country_code"]as? String{
                                 strphone_country_code = phone_country_code
                                }else{
                                 strphone_country_code = ""
                    }
      
        if let plate_number = dict["plate_number"]as? String{
                            strplate_number = plate_number
                                      }else{
                                       strplate_number = ""
                                   }
        
        if let rating = dict["rating"]as? String{
                            strrating = rating
                                      }else{
                            strrating = ""
                    }
        
        if let reviewed_to_id = dict["reviewed_to_id"]as? String{
            self.reviewed_to_id = reviewed_to_id
                                        }else{
                              reviewed_to_id = ""
                      }
            
        if let is_contract_updated = dict["is_contract_updated"]as? String{
                  self.stris_contract_updated = is_contract_updated
                                              }else{
                  self.stris_contract_updated = ""
                            }
        
        
       

        if let userID = dict["userID"]as? String{
                                    struserID = userID
                                              }else{
                                    struserID = ""
                            }
        
        
        if let vehicleID = dict["vehicleID"]as? String{
                                    strvehicleID = vehicleID
                                              }else{
                                    strvehicleID = ""
                            }
                
        
        if let character_certificate_file = dict["character_certificate_file"]as? String{
            strcharacter_certificate_file = character_certificate_file
        }else{
            strcharacter_certificate_file = ""
        }
        if let driver_license_file = dict["driver_license_file"]as? String{
            strdriver_license_file = driver_license_file
        }else{
            strdriver_license_file = ""
            
        }
        if let national_insurance_file = dict["national_insurance_file"]as? String{
            strnational_insurance_file = national_insurance_file
        }else{
          strnational_insurance_file = ""
            
        }
        if let passport_file = dict["passport_file"]as? String{
            strpassport_file = passport_file
        }else{
            strpassport_file = ""

            
        }
        if let signed_contract_form_file = dict["signed_contract_form_file"]as? String{
            strsigned_contract_form_file = signed_contract_form_file
        }else{
            strsigned_contract_form_file = ""
        }
        if let signed_contract_form_file_metadata = dict["signed_contract_form_file_metadata"]as? String{
            strsigned_contract_form_file_metadata = signed_contract_form_file_metadata
        }else{
            
            strsigned_contract_form_file_metadata = ""
        }
        
        if let vehicle_insurance_file = dict["vehicle_insurance_file"]as? String{
            strvehicle_insurance_file = vehicle_insurance_file
        }else{
            strvehicle_insurance_file = ""
        }
        
        if let user_type = dict["user_type"]as? String{
            struser_type = user_type
        }else{
            struser_type = ""
            
        }
        

        
    }
    
}

