//
//  SocialSignUpEmailVc.swift
//  Go Delivery
//
//  Created by MACBOOK-SHUBHAM V on 16/09/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit
import TwitterKit
import TwitterCore

var is_email_manually_added = ""

class SocialSignUpEmailVc: UIViewController {
    
    //MARK:- IBOutlet-
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var btnSignUp: UIButton!
    
    //MARK:- Local variables-
    
    var isfromManualyAddedEmail = false
    var strSocialID = ""
    var strFirstName = ""
    var strLastName = ""
    var strEmail = ""
    var strProfile = ""
    var strSocialType = ""
    var strCountryCode = ""
    var strDialCode = ""
    var strPhoneNumber = ""
    var SocialImage:UIImage? = nil
    var ProfilePic = ""
    
    //MARK:- View LifeLifeCycle-

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.endEditing(true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.endEditing(true)
        self.initialUISetup()
             
        if isfromManualyAddedEmail == true {
            self.navigationController?.popViewController(animated: false)
            isfromManualyAddedEmail = false
        }
    }
    
    
    //MARK:- UIButtons-
    @IBAction func btnBack(_ sender: Any) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSignUP(_ sender: Any) {
        self.view.endEditing(true)
        self.validation()
    }
    
    
    //MARK:- Local Methods -
    
    func initialUISetup(){
        self.btnSignUp.btnRadNonCol22()
        self.btnSignUp.setbtnshadow()
    }
    func validation(){
        self.view.endEditing(true)
        
        self.txtEmail.text = self.txtEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if (self.txtEmail.text?.isEmpty)!{
            objAppShareData.showAlert(title: kAlertTitle, message: BlankEmail, view: self)
            
        }else if !objValidationManager.validateEmail(with: txtEmail.text ?? "") {
            objAppShareData.showAlert(title: kAlertTitle, message: InvalidEmail, view: self)
        }else{
            strEmail = txtEmail.text ?? ""
            is_email_manually_added = "1"
            
                                if objAppShareData.strUserType == "customer"{
                                    
                                    self.callWebserviceFrSocialSignIn()

                                }else{
                                    self.callWebForSocialSignInDeliveryPerson()
                }
        }
    }
    func navigateToEmailVC(){
             let storyBoard = UIStoryboard(name: "Main", bundle:nil)
             let vc = storyBoard.instantiateViewController(withIdentifier: "VerifyEmailVc") as! VerifyEmailVc
             self.navigationController?.pushViewController(vc, animated: true)
         }
      
      
      func navigateToUploadDocs(){
               let storyBoard = UIStoryboard(name: "Main", bundle:nil)
               let vc = storyBoard.instantiateViewController(withIdentifier: "SignUpUploadDocsVc") as! SignUpUploadDocsVc
               self.navigationController?.pushViewController(vc, animated: true)
           }

        
        func navigateToDownloadContract(){
                   let storyBoard = UIStoryboard(name: "Main", bundle:nil)
                   let vc = storyBoard.instantiateViewController(withIdentifier: "SignUpContractVc") as! SignUpContractVc
                   self.navigationController?.pushViewController(vc, animated: true)
               }
      
      func checkApplicationApprovedStatus(){
                let storyBoard = UIStoryboard(name: "Main", bundle:nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "ApplicationApprovedStatusVC") as! ApplicationApprovedStatusVC
                self.navigationController?.pushViewController(vc, animated: true)
            }
      
      func navigateAddVehivleInfo(){
                    let storyBoard = UIStoryboard(name: "Main", bundle:nil)
                    let vc = storyBoard.instantiateViewController(withIdentifier: "AddVehicleInfoVc") as! AddVehicleInfoVc
                    self.navigationController?.pushViewController(vc, animated: true)
              }
}

//MARK:- Webservice Calling -

extension SocialSignUpEmailVc{
        func callWebserviceFrSocialSignIn(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAppShareData.showNetworkAlert(view:self)
            return
        }
        objWebServiceManager.showIndicator()
        self.view.endEditing(true)
    
        let param = [WsParam.user_firstName:self.strFirstName ,
                     WsParam.user_lastName:self.strLastName ,
                     WsParam.email :strEmail,
                     WsParam.phone_dialCode :strDialCode,
                     WsParam.country_code :strCountryCode,
                     WsParam.profilepicture : ProfilePic,
                     WsParam.phone_number :strPhoneNumber,
                     WsParam.firebase_token :objAppShareData.strFirebaseToken,
                     WsParam.social_id :self.strSocialID,
                     WsParam.is_email_manually_added : is_email_manually_added,
                     WsParam.social_type :self.strSocialType] as [String : Any]
        
        print(param)
        
        objWebServiceManager.requestPost(strURL:WsUrl.SocialSignUp, queryParams: [:], params: param, strCustomValidation: "", showIndicator: true, success: {response in
            
            let status = (response["status"] as? String)
            _ = (response["message"] as? String)
            print(response)
            
            if status == k_success{
                objWebServiceManager.hideIndicator()
                if let data = response["data"]as? [String:Any]{
                    let user_details  = data["user_details"] as? [String:Any]
                    
                    objAppShareData.SaveUpdateUserInfoFromAppshareData(userDetail: user_details ?? [:])
                    objAppShareData.fetchUserInfoFromAppshareData()
                }
                if objAppShareData.userDetail.strUserType == "customer"{
                    if objAppShareData.userDetail.strisOnboardingComplete == "1"{
                        
                        ObjAppdelegate.showTabbarNavigation()
                    }else if objAppShareData.userDetail.strisOnboardingComplete == "0"{
                      
                        if objAppShareData.userDetail.strisOnboardingStep == "1"{
                            
                            if objAppShareData.userDetail.str_is_EmailVerifed == "0"{

                                let objVc = UIStoryboard.init(name: "Main", bundle: nil) .instantiateViewController(withIdentifier: "VerifyEmailVc")as! VerifyEmailVc
                                     objVc.closerEmailVerify = {
                                         BackToPop in
                                         self.isfromManualyAddedEmail = BackToPop
                                    }
                                 self.navigationController?.pushViewController(objVc, animated: true)
                             }else {
                                ObjAppdelegate.showTabbarNavigation()
                            }
                        }
                    }
                    
                }else{
                    if objAppShareData.userDetail.strisOnboardingComplete == "1"{
                        ObjAppdelegate.DeliveryPersonTabBar()

                    }else if objAppShareData.userDetail.strisOnboardingComplete == "0"{
                        
                        if objAppShareData.userDetail.strisOnboardingStep == "1"{
                            
                          
                            if objAppShareData.userDetail.str_is_EmailVerifed == "1"{
                                objAlert.showAlert(message: k_UnderDevlope, title: kAlertTitle, controller: self)
                                
                            }else{
                                
                                self.navigateToEmailVC()
                            }
                        }else if objAppShareData.userDetail.strisOnboardingStep == "2"{
                            
                            self.navigateToUploadDocs()
                            
                        }else if objAppShareData.userDetail.strisOnboardingStep == "3"{
                            
                            self.navigateToDownloadContract()
                        }else if objAppShareData.userDetail.strisOnboardingStep == "4"{
                            self.navigateAddVehivleInfo()
                        }
                    }
                }
                
            }else{
                objWebServiceManager.hideIndicator()
                
            }
        }, failure: { (error) in
            print(error)
            objWebServiceManager.hideIndicator()
            objAppShareData.showAlert(title: kAlertTitle, message: kErrorMessage, view: self)
        })
    }
    
    
       func callWebForSocialSignInDeliveryPerson(){
           
           if !objWebServiceManager.isNetworkAvailable(){
               objWebServiceManager.hideIndicator()
               objAppShareData.showNetworkAlert(view:self)
               return
           }
           objWebServiceManager.showIndicator()
           self.view.endEditing(true)
        
             let param = [WsParam.user_firstName:self.strFirstName ,
                             WsParam.user_lastName:self.strLastName ,
                             WsParam.email :strEmail,
                             WsParam.phone_dialCode :strDialCode,
                             WsParam.country_code :strCountryCode,
                             WsParam.profilepicture : ProfilePic,
                             WsParam.phone_number :strPhoneNumber,
                             WsParam.firebase_token :objAppShareData.strFirebaseToken,
                             WsParam.social_id :self.strSocialID,
                             WsParam.is_email_manually_added : is_email_manually_added,
                             WsParam.social_type :self.strSocialType] as [String : Any]
                
                print(param)
           
           objWebServiceManager.requestPost(strURL:WsUrl.DeliveryPersonSocialSignUp, queryParams: [:], params: param, strCustomValidation: "", showIndicator: true, success: {response in
               
               
               let status = (response["status"] as? String)
               let message = (response["message"] as? String)
               print(response)
               
               if status == k_success{
                   objWebServiceManager.hideIndicator()
                   if let data = response["data"]as? [String:Any]{
                       
                       let social_statusINt = data["social_status"]as? Int ?? 11
                       print(social_statusINt)
                       objAppShareData.userDetail.social_status = String(social_statusINt)
                       
                       print(objAppShareData.userDetail.social_status)
                       
                       let user_details  = data["user_details"] as? [String:Any]
                       
                       objAppShareData.SaveUpdateUserInfoFromAppshareData(userDetail: user_details ?? [:])
                       objAppShareData.fetchUserInfoFromAppshareData()
                    
                    self.isfromManualyAddedEmail = true

                       
                   }
                   
                   if objAppShareData.userDetail.strUserType == "customer"{
                       if objAppShareData.userDetail.strisOnboardingComplete == "1"{
                           
                           ObjAppdelegate.showTabbarNavigation()
                       }else if objAppShareData.userDetail.strisOnboardingComplete == "0"{
                           
                           if objAppShareData.userDetail.strisOnboardingStep == "1"{
                               
                               if objAppShareData.userDetail.str_is_EmailVerifed == "0"{
                                   let objVc = UIStoryboard.init(name: "Main", bundle: nil) .instantiateViewController(withIdentifier: "VerifyEmailVc")as! VerifyEmailVc
                                objVc.closerEmailVerify = {
                                                                   BackToPop in
                                                                   self.isfromManualyAddedEmail = BackToPop
                                                               }
                                   self.navigationController?.pushViewController(objVc, animated: true)
                               }else {
                                   ObjAppdelegate.showTabbarNavigation()
                               }
                           }
                       }
                       
                   }else{
                       if objAppShareData.userDetail.strisOnboardingComplete == "1"{
                        
                        ObjAppdelegate.DeliveryPersonTabBar()

                       }else if objAppShareData.userDetail.strisOnboardingComplete == "0"{
                           
                           if objAppShareData.userDetail.strisOnboardingStep == "1"{
                               
                               if objAppShareData.userDetail.str_is_EmailVerifed == "1"{
                                   objAlert.showAlert(message: k_UnderDevlope, title: kAlertTitle, controller: self)
                                   
                               }else{
                                   
                                   self.navigateToEmailVC()
                               }
                           }else if objAppShareData.userDetail.strisOnboardingStep == "2"{
                               
                               self.navigateToUploadDocs()
                               
                           }else if objAppShareData.userDetail.strisOnboardingStep == "3"{
                               
                               self.navigateToDownloadContract()

                           }else if objAppShareData.userDetail.strisOnboardingStep == "4"{
                               self.navigateAddVehivleInfo()

                           }
                      }
                   }
             
               }else{
                   objWebServiceManager.hideIndicator()
                   objAppShareData.showAlert(title: kAlertTitle, message: message ?? "", view: self)
               }
           }, failure: { (error) in
               print(error)
               objWebServiceManager.hideIndicator()
               objAppShareData.showAlert(title: kAlertTitle, message: kErrorMessage, view: self)
           })
       }
    
  
}
