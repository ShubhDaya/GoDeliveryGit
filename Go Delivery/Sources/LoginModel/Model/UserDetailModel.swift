//
//  UserDetailModel.swift
//  Go Delivery
//
//  Created by MACBOOK-SHUBHAM V on 30/07/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import Foundation
import UIKit

class UserDetailModel: NSObject {
    
    var strUserType : String = ""
    var strUserID : String = ""
    var strUserFirstName: String = ""
    var strUserlastName: String = ""
    var strEmail: String = ""
    var strCountry_code : String = ""
    var strPhone_number: String = ""
    var strProfile_picture: String = ""
    var strPhone_dial_code : String = ""
    var strProfile_timezone: String = ""
    var strStatus: String = ""
    var strDevice_type : String = ""
    var strDevice_Id : String = ""
    var strFirebase_token: String = ""
    var strDevice_timezone: String = ""
    var strAuth_token: String = ""
    var strPassword: String = ""
    var str_is_EmailVerifed:String  = ""
    var strisOnboardingComplete: String = ""
    var strisOnboardingStep: String = ""
    var social_status: String = ""
    var contract_document_url: String = ""
    var privacy_url: String = ""
    var terms_url: String = ""
    var strsignup_type: String = ""
    var AboutUs: String = ""
    var strpushAlertStatus: String = ""

    
    
   // signup_type
    
    
    init(dict : [String : Any]) {
    //    if let dictUser = dict["user_details"]as? [String:Any]{
            
            if let userID = dict["userID"]as? String{
                strUserID = userID
            }else if let userID = dict["userID"]as? Int{
                strUserID = String(userID)
            }
            if let firstname = dict["first_name"]as? String{
                strUserFirstName = firstname
            }
            if let LastName = dict["last_name"]as? String{
                strUserlastName = LastName
            }
           if let user_type = dict["user_type"]as? String{
              strUserType = user_type
           }
        
        
        
        
            if let email = dict["email"]as? String{
                strEmail = email
            }
            if let country_code = dict["phone_country_code"]as? String{
                strCountry_code = country_code
            }
            if let phone_number = dict["phone_number"]as? String{
                strPhone_number = phone_number
            }
            if let phone_dial_code = dict["phone_dial_code"]as? String{
                strPhone_dial_code = phone_dial_code
            }
            if let profile_picture = dict["profile_picture"]as? String{
                strProfile_picture = profile_picture
            }
            if let profile_timezone = dict["profile_timezone"]as? String{
                strProfile_timezone = profile_timezone
            }
            if let status = dict["status"]as? String{
                strStatus = status
            }
            if let device_type = dict["device_type"]as? String{
                strDevice_type = device_type
            }
            if let device_id = dict["device_id"]as? String{
                strDevice_Id = device_id
            }
            if let firebase_token = dict["firebase_token"]as? String{
                strFirebase_token = firebase_token
            }
            if let device_timezone = dict["device_timezone"]as? String{
                strDevice_timezone = device_timezone
            }
        
        if let push_alert_status = dict["push_alert_status"]as? String{
            strpushAlertStatus = push_alert_status
        }else  if let push_alert_status = dict["push_alert_status"]as? Int{
            strpushAlertStatus = String(push_alert_status)
        }
        
            
            if let signup_type = dict["signup_type"]as? String{
                strsignup_type = signup_type
            }else if let signup_type = dict["signup_type"]as? Int{
                strsignup_type = String(signup_type)
        }
        
            if let auth_token = dict["auth_token"]as? String{
                strAuth_token = auth_token
            }else if let auth_token = dict["auth_token"]as? Int{
                strAuth_token = String(auth_token)
            }
            
            if let auth_token = dict["password"]as? String{
                strPassword = auth_token
            }else if let auth_token = dict["password"]as? Int{
                strPassword = String(auth_token)
            }else{
                strPassword = ""
              }
            
            
            if let onboarding_step = dict["onboarding_step"]as? String{
                strisOnboardingStep = onboarding_step
            }else if let onboarding_step = dict["onboarding_step"]as? Int{
                strisOnboardingStep = String(onboarding_step)
            }
            
            if let is_onboarding_completed = dict["is_onboarding_completed"]as? String{
                strisOnboardingComplete = is_onboarding_completed
            }else if let is_onboarding_completed = dict["is_onboarding_completed"]as? Int{
                strisOnboardingComplete = String(is_onboarding_completed)
            }
            
            if let is_email_verified = dict["is_email_verified"]as? String{
                str_is_EmailVerifed = is_email_verified
            }else  if let is_email_verified = dict["is_email_verified"]as? Int{
                str_is_EmailVerifed = String(is_email_verified)
            }
            
            if let dictUser = dict["social_accounts"]as? [String:Any]{
                
                //                if let userID = dictUser["is_signup"]as? String{
                //                    strUserID = userID
                //                }
            }
            //            "social_accounts" =         {
            //                "created_at" = "2020-06-19 11:37:13";
            //                "is_signup" = 1;
            //                socialAccountID = 9;
            //                "social_id" = 110069972433626934030;
            //                "social_type" = 1;
            //                "user_id" = 159;
            //            };
            
       // }
        
          UserDefaults.standard.setValue(strAuth_token, forKey: UserDefaults.Keys.AuthToken)
//        UserDefaults.standard.setValue(strUserFirstName, forKey: UserDefaults.Keys.user_FirstName)
//        UserDefaults.standard.setValue(strUserlastName, forKey: UserDefaults.Keys.user_LastName)
//        UserDefaults.standard.setValue(strPassword, forKey: UserDefaults.Keys.password)
        
    }
    
}
