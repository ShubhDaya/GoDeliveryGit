//
//  SettingsVc.swift
//  Go Delivery
//
//  Created by MACBOOK-SHUBHAM V on 08/09/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit

var PushAlertStatus = 2
class SettingsVc: UIViewController {
    
    //MARK:- IBOutlets -
    @IBOutlet weak var imgToggle: UIImageView!
    @IBOutlet weak var viewHeaderForShadoe: UIView!
    
    //MARK:- Local varibles -
    var isnotifyOn = false
    var check = true
    var notificationStatus = -1
    var alertStaus = 5
    
    //MARK:- ViewLifeCycles -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.callWSForAppLaunch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        viewHeaderForShadoe.layer.shadowColor = UIColor.lightGray.cgColor
        viewHeaderForShadoe.layer.masksToBounds = false
        viewHeaderForShadoe.layer.shadowOffset = CGSize(width: 0.0 , height: 5.0)
        viewHeaderForShadoe.layer.shadowOpacity = 0.3
        
        viewHeaderForShadoe.layer.shadowRadius = 3
        alertStaus = Int(objAppShareData.userDetail.strpushAlertStatus) ?? 000
        print(alertStaus)
        self.checkNotificationStatus()
    }
    
    //MARK:- Button Actions  -
    
    @IBAction func btnNotification(_ sender: Any) {
        check = !check
        if alertStaus == 0{
            imgToggle.image = #imageLiteral(resourceName: "ON_TOGGLE_ICO")
            //  check = true
            notificationStatus = 1
            print(" for on \(notificationStatus)")
        } else if alertStaus == 1
        {
            imgToggle.image = #imageLiteral(resourceName: "OFF_TOGGLE_ICO")
            notificationStatus = 0
            print(" for off \(notificationStatus)")
        }
        self.callWebforchangeNotificationStatus()
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnChangePassword(_ sender: Any) {

        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordVc") as! ChangePasswordVc
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnAboutUs(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AboutUsVC") as! AboutUsVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnPrivacyPolicy(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PrivacyPolicyVc") as! PrivacyPolicyVc
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnTermsCondition(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "termsConditonVC") as! termsConditonVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnLogout(_ sender: Any) {
        objAlert.showAlertCallBackother(alertLeftBtn: "No", alertRightBtn: "Yes", title: kAlertTitle, message: "Do you want to Logout?", controller: self, callback: {_ in
            self.callWebForLogout()
            
        }, callbackCancel: { () in
            
        })
    }
    
    
    //MARK:- Local Methods -

    func checkNotificationStatus(){
        if alertStaus == 1{
            imgToggle.image = #imageLiteral(resourceName: "ON_TOGGLE_ICO")
            
        }else if alertStaus == 0 {
            imgToggle.image = #imageLiteral(resourceName: "OFF_TOGGLE_ICO")
            print(" for off \(notificationStatus)")
        }else{
            
        }
    }
}


//MARK:- Webservices Calling  -

extension SettingsVc {
    
    func callWSForAppLaunch(){
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAppShareData.showNetworkAlert(view:self)
            return
        }
        objWebServiceManager.showIndicator()
        
        let   param = [
            WsParam.user_id: objAppShareData.userDetail.strUserID,
            ] as [String : Any]
        
        print(param)
        objWebServiceManager.requestGet(strURL: WsUrl.AppLaunch , params: param, queryParams: [:], strCustomValidation: "", success: { (response) in
            print(response)
            let status = response["status"] as? String ?? ""
            let message = response["message"] as? String ?? ""
          
            if status == "success"{
                if let data = response["data"] as? [String:Any]{
                    if let content = data["content"] as? [String:Any]{
                        
                        let contractDoucmentUrl = content["contract_document_url"]as? String ?? ""
                        let privacy_url = content["privacy_url"]as? String ?? ""
                        let terms_url = content["terms_url"]as? String ?? ""
                        let about_us = content["about_us"]as? String ?? ""
                    
                        objAppShareData.userDetail.contract_document_url = contractDoucmentUrl
                        objAppShareData.userDetail.privacy_url = privacy_url
                        objAppShareData.userDetail.terms_url = terms_url
                        objAppShareData.userDetail.AboutUs = about_us
                        
                    }
                    objWebServiceManager.hideIndicator()
                }
            }else{
                objWebServiceManager.hideIndicator()
                objAlert.showAlert(message: message , title: kAlertTitle, controller: self)
            }
        }) { (error) in
            print(error)
            objWebServiceManager.hideIndicator()
            
            objAlert.showAlert(message: kErrorMessage , title: kAlertTitle, controller: self)
        }
    }
}


extension SettingsVc{
    func callWebforchangeNotificationStatus(){
        print(notificationStatus)
        objWebServiceManager.showIndicator()
        objWebServiceManager.requestPatch(strURL: WsUrl.NotificatioChangeStatus+String(notificationStatus), params: [:], queryParams: [:], strCustomValidation: "", success: { (response) in
            print(response)
            objWebServiceManager.hideIndicator()
            
            
            let status = response["status"] as? String
            let message = response["message"] as? String ?? ""
            if status == "success"{
                let dic = response["data"] as? [String:Any] ?? [:]
                let alertStatusapi = dic["push_alert_status"] as? Int ?? 0
                print(alertStatusapi)
                
                objAppShareData.userDetail.strpushAlertStatus = String(alertStatusapi)
                
                PushAlertStatus = alertStatusapi
                self.alertStaus = Int(objAppShareData.userDetail.strpushAlertStatus) ?? 000
                
                self.checkNotificationStatus()
                
            }  else{
                objWebServiceManager.hideIndicator()
                if message == "k_sessionExpire"{
                    objAlert.showAlert(message: k_sessionExpire, title: kAlertTitle, controller: self)
                    ObjAppdelegate.loginNavigation()
                }  else{
                    objWebServiceManager.hideIndicator()
                    
                    objAlert.showAlert(message:message, title: kAlertTitle, controller: self)
                }
            }
            
        }) { (error) in
            print(error)
            objWebServiceManager.hideIndicator()
            objAppShareData.showAlert(title: kAlertTitle, message: kErrorMessage, view: self)
            
        }
    }
    
    
    func callWebForLogout(){
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAppShareData.showNetworkAlert(view:self)
            return
        }
        objWebServiceManager.showIndicator()
        let   param = [
            WsParam.user_id: objAppShareData.userDetail.strUserID,
            ] as [String : Any]
        
        print(param)
        objWebServiceManager.requestGet(strURL: WsUrl.logout, params:param, queryParams: [:], strCustomValidation: "", success: { (response) in
            let status = response["status"] as? String ?? ""
            let message = response["message"] as? String ?? ""
            
            if status == "success"{
                objWebServiceManager.hideIndicator()
                ObjAppdelegate.loginNavigation()
                
            }else{
                objWebServiceManager.hideIndicator()
                
                objAlert.showAlert(message: message, title: "Alert", controller: self)
            }
        }) { (error) in
            objWebServiceManager.hideIndicator()
            objAppShareData.showAlert(title: kAlertTitle, message: kErrorMessage, view: self)
            print(error)
        }
    }
    
}
