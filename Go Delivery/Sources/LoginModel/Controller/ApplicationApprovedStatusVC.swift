//
//  ApplicationApprovedStatusVC.swift
//  Go Delivery
//
//  Created by MACBOOK-SHUBHAM V on 10.11.20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit

class ApplicationApprovedStatusVC: UIViewController {
    
    //MARK:- IBOutlet-
    @IBOutlet weak var btnOKExit: UIButton!
    @IBOutlet weak var btnCross: UIButton!
    
    //MARK:- Local Variables -
    
    var buttonTittle = ""
    
    //MARK:- view life cycle  -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnCross.isHidden = true
        
        let notificationCenter = NotificationCenter.default
        
        NotificationCenter.default.addObserver(
            self,
            selector:#selector(appMovedToForground),
            name: UIApplication.didBecomeActiveNotification,
            object: nil)
    }
    
    @objc func appMovedToForground()
    {
        self.view.layoutIfNeeded()
        print("appMovedToForground")
        callCheckProfileStatus1()
        
    }
    
    @objc func appMovedToBackground() {
        
        print("applicationwillResignActve")
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.btnOKExit.btnRadNonCol22()
        self.btnOKExit.setbtnshadow()
        callCheckProfileStatus1()
        
        UserDefaults.standard.set(objAppShareData.userDetail.strUserID, forKey: UserDefaults.KeysDefault.kUserId)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("did apprear")
    }
    
    
    
    //MARK:- Button Action -
    
    @IBAction func btnOkExit(_ sender: Any) {
        //exit(0);
        
        if buttonTittle == "OK"{
            testExample()
            
        }else if buttonTittle == "Exit"{
            self.callWebForLogout1()
        }
    }
    
    @IBAction func btnCross(_ sender: Any) {
        UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
        
    }
    
    //MARK:- Local Methods  -
    
    func testExample() {
        
        UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
    }
}

//MARK:- Webservices -

extension ApplicationApprovedStatusVC {
    
    func callCheckProfileStatus1(){
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
        objWebServiceManager.requestGet(strURL: WsUrl.ChecApprovedProfileStatus , params: param, queryParams: [:], strCustomValidation: "", success: { (response) in
            print(response)
            let status = response["status"] as? String ?? ""
            let message = response["message"] as? String ?? ""
            
            if status == "success"{
                if let dataS = response["data"] as? [String:Any]{
                    objWebServiceManager.hideIndicator()
                    
                    let isAvailable = dataS["is_available"] as? String ?? ""
                    let is_document_uploaded = dataS["is_document_uploaded"] as? String ?? ""
                    let is_profile_approved = dataS["is_profile_approved"] as? String ?? ""
                    _ = dataS["userID"] as? String ?? ""
                    
                    if isfromContractApprovedcheck == true {
                        isfromContractApprovedcheck = false
                        self.btnCross.isHidden = true
                        self.btnOKExit.setTitle("OK", for: .normal)
                        self.buttonTittle = "OK"
                        
                    }else{
                        if is_document_uploaded == "0" && is_profile_approved == "0"{
                            ObjAppdelegate.DeliveryPersonTabBar()
                            
                        }else if is_document_uploaded == "1" && is_profile_approved == "0"{
                            self.btnCross.isHidden = false
                            self.btnOKExit.setTitle("Exit", for: .normal)
                            self.buttonTittle = "Exit"
                            
                        }else if is_document_uploaded == "1" && is_profile_approved == "1"  {
                            ObjAppdelegate.DeliveryPersonTabBar()
                        }
                    }
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
    
    
    func callWebForLogout1(){
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
