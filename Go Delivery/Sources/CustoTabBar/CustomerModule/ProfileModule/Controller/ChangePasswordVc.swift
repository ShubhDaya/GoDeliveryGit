//
//  ChangePasswordVc.swift
//  Go Delivery
//
//  Created by MACBOOK-SHUBHAM V on 08/09/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit

class ChangePasswordVc: UIViewController {
    
    //MARK:- IBOutlets -
    
    @IBOutlet weak var lblHeaderTitle: UILabel!
    @IBOutlet weak var lblPasswordDescription: UILabel!
    @IBOutlet weak var viewCurrentPassword: customView!
    
    @IBOutlet weak var viewheaderForShadow: UIView!
    @IBOutlet weak var txtCurrentPassword: UITextField!
    @IBOutlet weak var txtNewPassowprd: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    
    @IBOutlet weak var imgCurrentPasshIde: UIImageView!
    @IBOutlet weak var imgNewpassHide: UIImageView!
    @IBOutlet weak var imbConfirmPassHide: UIImageView!
    @IBOutlet weak var btnUpdatePassword: UIButton!
    
    
    //MARK:- Local Variables -
    var isSecureCurrentPassText = false
    var isSecureNewPassText = false
    var isSecureConfirmPassText = false
    var socialPassword = ""
    var signUpType = ""
    
    //MARK:- View Life Cycles -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtCurrentPassword.delegate = self
        self.txtNewPassowprd.delegate = self
        self.txtConfirmPassword.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.initialUISetup()
        socialPassword = objAppShareData.userDetail.strPassword
        signUpType = objAppShareData.userDetail.strsignup_type
        
        print(socialPassword)
        if signUpType == "2"{
            
            if socialPassword != ""{
                self.lblHeaderTitle.text = "Change Password"
                self.lblPasswordDescription.text = "Create a New Password"
                self.viewCurrentPassword.isHidden = false
                
            }else if socialPassword == ""{
                
                self.lblHeaderTitle.text = "Set Password"
                self.lblPasswordDescription.text = "Set a New Password"
                self.viewCurrentPassword.isHidden = true
            }
        }else{
            self.lblHeaderTitle.text = "Change Password"
            self.lblPasswordDescription.text = "Create a New Password"
            self.viewCurrentPassword.isHidden = false
        }
    }
    
    //MARK:- Button Action -
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnHideCurrentPassword(_ sender: Any) {
        if isSecureCurrentPassText == false{
            self.txtCurrentPassword.isSecureTextEntry = true
            imgCurrentPasshIde.image = #imageLiteral(resourceName: "hide_pass_ico")
            isSecureCurrentPassText = true
        }else{
            self.txtCurrentPassword.isSecureTextEntry = false
            isSecureCurrentPassText = false
            imgCurrentPasshIde.image = #imageLiteral(resourceName: "show_pass_ico")
        }
    }
    
    @IBAction func btnHideNewPassword(_ sender: Any) {
        if isSecureNewPassText == false{
            self.txtNewPassowprd.isSecureTextEntry = true
            imgNewpassHide.image = #imageLiteral(resourceName: "hide_pass_ico")
            isSecureNewPassText = true
        }else{
            self.txtNewPassowprd.isSecureTextEntry = false
            isSecureNewPassText = false
            imgNewpassHide.image = #imageLiteral(resourceName: "show_pass_ico")
        }
    }
    
    @IBAction func btnHideConfirmPass(_ sender: Any) {
        if isSecureConfirmPassText == false{
            self.txtConfirmPassword.isSecureTextEntry = true
            imbConfirmPassHide.image = #imageLiteral(resourceName: "hide_pass_ico")
            isSecureConfirmPassText = true
        }else{
            self.txtConfirmPassword.isSecureTextEntry = false
            isSecureConfirmPassText = false
            imbConfirmPassHide.image = #imageLiteral(resourceName: "show_pass_ico")
        }
    }
    
    @IBAction func btnUpdatePassword(_ sender: Any) {
        // self.validation()
        if socialPassword != ""{
            self.validation()
            
        }else if socialPassword == ""{
            self.validationSocialType()
        }
    }
    
    //MARK:- Local Methods  -
    
    func initialUISetup(){
        viewheaderForShadow.layer.shadowColor = UIColor.lightGray.cgColor
        viewheaderForShadow.layer.masksToBounds = false
        viewheaderForShadow.layer.shadowOffset = CGSize(width: 0.0 , height: 5.0)
        viewheaderForShadow.layer.shadowOpacity = 0.3
        viewheaderForShadow.layer.shadowRadius = 3
        self.btnUpdatePassword.btnRadNonCol22()
        self.btnUpdatePassword.setbtnshadow()
    }
    
    func validation(){
        
        let strCurrentPassword = self.txtCurrentPassword.text?.count ?? 0
        let strNewPassword = self.txtNewPassowprd.text?.count ?? 0
        _ = self.txtConfirmPassword.text?.count ?? 0
        
        self.txtCurrentPassword.text = self.txtCurrentPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        self.txtConfirmPassword.text = self.txtConfirmPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        self.txtNewPassowprd.text = self.txtNewPassowprd.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if txtCurrentPassword.text?.isEmpty == true  {
            objAlert.showAlert(message: BlankOldPassword, title: kAlertTitle, controller: self
            )
        }else if strCurrentPassword < 6{
            objAlert.showAlert(message: currentPasslenght, title: kAlertTitle, controller: self
            )
        }else if txtNewPassowprd.text?.isEmpty == true  {
            objAlert.showAlert(message: BlankNewPassword, title: kAlertTitle, controller: self
            )
        }
        else if strNewPassword < 6{
            objAlert.showAlert(message: LengthPassword, title: kAlertTitle, controller: self
            )
        }else if (self.txtConfirmPassword.text?.isEmpty)!{
            objAppShareData.showAlert(title: kAlertTitle, message: BlankConfirmPwd, view: self)
            
        }else if (self.txtNewPassowprd.text != self.txtConfirmPassword.text) {
            objAppShareData.showAlert(title: kAlertTitle, message:InvalidConfirmPwd , view: self)
        }else{
            self.callWebserviceForChangePassword()
        }
    }
    
    func validationSocialType(){
        
        let strNewPassword = self.txtNewPassowprd.text?.count ?? 0
        _ = self.txtConfirmPassword.text?.count ?? 0
        
        self.txtConfirmPassword.text = self.txtConfirmPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        self.txtNewPassowprd.text = self.txtNewPassowprd.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if txtNewPassowprd.text?.isEmpty == true {
            objAlert.showAlert(message: BlankNewPassword, title: kAlertTitle, controller: self)
            
        }else if strNewPassword < 6 {
            objAlert.showAlert(message: LengthPassword, title: kAlertTitle, controller: self)
        }else if (txtConfirmPassword.text?.isEmpty)!{
            objAlert.showAlert(message: BlankConfirmPwd, title: kAlertTitle, controller: self)
        }else if (txtNewPassowprd.text != txtConfirmPassword.text){
            objAlert.showAlert(message: InvalidConfirmPwd, title: kAlertTitle, controller: self)
        }else{
            self.callWebserviceForChangePassword()
            
        }
    }
}

//MARK:- Webservice Calling   -

extension ChangePasswordVc {
    
    func callWebserviceForChangePassword(){
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAppShareData.showNetworkAlert(view:self)
            return
        }
        objWebServiceManager.showIndicator()
        self.view.endEditing(true)
  
        let param = [WsParam.current_password:txtCurrentPassword.text ?? "",
                     WsParam.new_password:txtNewPassowprd.text ?? "",
                     WsParam.confirm_password:txtConfirmPassword.text ?? ""
            ] as [String : Any]
        print(param)
        
        objWebServiceManager.requestPost(strURL:WsUrl.ChangeReview, queryParams: [:], params: param, strCustomValidation: "", showIndicator: true, success: {response in
            
            let status = (response["status"] as? String)
            let message = (response["message"] as? String)
            print(response)
            
            if   status == "success" {
                self.view.endEditing(true)
                
                objWebServiceManager.hideIndicator()
                
                if (response["data"]as? [String:Any]) != nil{
                    self.txtCurrentPassword.text = ""
                    self.txtNewPassowprd.text = ""
                    self.txtConfirmPassword.text = ""
                    self.view.endEditing(true)
                    
                    objAlert.showAlertCallBackOk(alertLeftBtn: "Ok", title: kAlertTitle, message: message ?? "", controller: self, callbackCancel: { () in
                        ObjAppdelegate.loginNavigation()
                    })
                    
                }
            }else{
                objWebServiceManager.hideIndicator()
                if message == "k_sessionExpire"{
                    objAlert.showAlert(message: k_sessionExpire, title: kAlertTitle, controller: self)
                    objAppShareData.resetDefaultsAlluserInfo()
                    ObjAppdelegate.loginNavigation()
                }  else{
                    objAlert.showAlert(message:message ?? "", title: kAlertTitle, controller: self)
                }
                
            }
        }, failure: { (error) in
            print(error)
            objWebServiceManager.hideIndicator()
            objAppShareData.showAlert(title: kAlertTitle, message: kErrorMessage, view: self)
        })
    }
    
}


//MARK:- UITextFieldDelegate  -

extension ChangePasswordVc:UITextFieldDelegate{

func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == self.txtCurrentPassword{
        self.txtNewPassowprd.becomeFirstResponder()
        
    }else if textField == self.txtNewPassowprd{
        self.txtConfirmPassword.becomeFirstResponder()
        
    }else if textField == self.txtConfirmPassword{
        self.txtConfirmPassword.resignFirstResponder()
        
    }
    return true
}
}
