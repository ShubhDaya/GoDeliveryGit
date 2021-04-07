//  VerifyEmailVc.swift
//  Go Delivery
//  Created by MACBOOK-SHUBHAM V on 27/07/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.

import UIKit

class VerifyEmailVc: UIViewController {
    
    //MARK:- IBOutlet -
    @IBOutlet weak var btnSkipEmail: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var btnVerified: UIButton!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var viewEmailForShadow: UIView!
    
    //MARK:- Local Variables -
    
    var closerEmailVerify:((_ BackToPop:Bool)  ->())?
    
    
    //MARK:- View Life Cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.endEditing(true)
        self.initialUiSetup()
        self.userInterfaceAccordingDevice()
        self.closerEmailVerify?(true)
        self.btnSkipEmail.isHidden = true
        
        self.lblEmail.text = objAppShareData.userDetail.strEmail
        self.lblEmail.text = objAppShareData.userDetail.strEmail
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    //MARK:- Buttons -
    
    @IBAction func btnBack(_ sender: Any) {
        self.view.endEditing(true)
        
        if  isfromSignUp == true {
            
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: MainInitial_VC.self) {
                    _ = self.navigationController!.popToViewController(controller, animated: true)
                    break
                }
            }
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    @IBAction func btnSkipEmail(_ sender: Any) {
        self.view.endEditing(true)
        objAppShareData.showLogoutAlert(view: self)
    }
    
    
    @IBAction func btnVerified(_ sender: Any) {
        self.view.endEditing(true)
        callWSForEmailAlredyVerified()
    }
    
    
    @IBAction func btnResend(_ sender: Any) {
        callWSForVerifyResend()
    }
    
    //MARK:- Local Methods -
    
    func initialUiSetup(){
        self.btnVerified.btnRadNonCol22()
        self.btnVerified.setbtnshadow()
        self.viewEmailForShadow.setviewCircle()
        self.viewEmailForShadow.setshadowViewCircle()
    }
    
    func userInterfaceAccordingDevice(){
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                scrollView.isScrollEnabled = true
                
            case 1334:
                scrollView.isScrollEnabled = true
                
            case 1920, 2208:
                scrollView.isScrollEnabled = true
                
            case 2436:
                scrollView.isScrollEnabled = false
                
            case 2688:
                scrollView.isScrollEnabled = false
                
            case 1792:
                scrollView.isScrollEnabled = false
                
            default:
                print("Unknown")
            }
        }
    }
    
}

//MARK:- webservice Calling -

extension VerifyEmailVc {
    
    func callWSForEmailAlredyVerified(){
        objWebServiceManager.showIndicator()
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAppShareData.showNetworkAlert(view:self)
            return
        }
        
        let   param = [
            WsParam.email: objAppShareData.userDetail.strEmail,
            ] as [String : Any]
        
        print(param)
        objWebServiceManager.requestGet(strURL: WsUrl.EmailVerifyCheck , params:param, queryParams: [:], strCustomValidation: "", success: { (response) in
            print(response)
            _ = response["code"] as? Int
            let status = response["status"] as? String ?? ""
            
            let message = response["message"] as? String ?? ""
            let verification = response["is_email_verified"] as? Int ?? 11
            
            if status == "success"{
                objWebServiceManager.hideIndicator()
                print(objAppShareData.userDetail.strUserType)
                print(objAppShareData.strUserType)
                
                if objAppShareData.userDetail.strUserType == "customer" && objAppShareData.strUserType ==  "customer"{
                    
                    if verification == 1{
                        
                        self.view.endEditing(true)
                        ObjAppdelegate.showTabbarNavigation()
                        
                    }else{
                        objWebServiceManager.hideIndicator()
                        
                        objAlert.showAlert(message: message, title: kAlertTitle, controller: self)
                    }
                }else{
                    
                    if verification == 1{
                        
                        self.view.endEditing(true)
                        let objVc = UIStoryboard.init(name: "Main", bundle: nil) .instantiateViewController(withIdentifier: "SignUpUploadDocsVc")as! SignUpUploadDocsVc
                        self.navigationController?.pushViewController(objVc, animated: false)
                    }else{
                        objWebServiceManager.hideIndicator()
                        
                        objAlert.showAlert(message: message, title: kAlertTitle, controller: self)
                        
                    }
                }
                
                
            }else{
                objWebServiceManager.hideIndicator()
                
                objAlert.showAlert(message: message, title: "Alert", controller: self)
            }
        }) { (error) in
            print(error)
        }
    }
    
    
    
    func callWSForVerifyResend(){
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAppShareData.showNetworkAlert(view:self)
            return
        }
        objWebServiceManager.showIndicator()
        
        
        let   param = [
            WsParam.email: objAppShareData.userDetail.strEmail,
            ] as [String : Any]
        
        
        objWebServiceManager.requestGet(strURL: WsUrl.EmailVerifyResend, params:param, queryParams: [:], strCustomValidation: "", success: { (response) in
            print(response)
            objWebServiceManager.hideIndicator()
            
            let code = response["code"] as? Int
            let message = response["message"] as? String ?? ""
            if code == 200{
                let data = response["data"] as? [String:Any] ?? [:]
                var verification = ""
                if let veri = data["is_verified"] as? String{
                    verification = veri
                }else if let veri = data["is_verified"] as? Int{
                    verification = String(veri)
                }
                if verification == "1"{
                    
                    
                }else{
                    objAlert.showAlert(message: message, title: kAlertTitle, controller: self)
                    
                }
                
                objWebServiceManager.hideIndicator()
                
            }else{
                objWebServiceManager.hideIndicator()
                
                objAlert.showAlert(message: message, title: "Alert", controller: self)
            }
        }) { (error) in
            objWebServiceManager.hideIndicator()
            objAppShareData.showAlert(title: kAlertTitle, message: kErrorMessage, view: self)          }
    }
}
