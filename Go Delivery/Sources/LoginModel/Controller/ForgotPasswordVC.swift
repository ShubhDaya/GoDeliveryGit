//
//  ForgotPasswordVC.swift
//  Breath
//  Created by MACBOOK-SHUBHAM V on 11/07/20.
//  Copyright © 2020 MINDIII. All rights reserved.

import UIKit

class ForgotPasswordVC: UIViewController,UITextFieldDelegate{
    
    //MARK: IBOutlet-
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    
    //MARK: ViewLifeCycle-
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtEmail.delegate = self
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.endEditing(true)
        super.viewWillAppear(animated)
        self.btnSubmit.btnRadNonCol22()
        self.btnSubmit.setbtnshadow()
    }
    
    // MARK: Buttons Method -
    
    @IBAction func btnBack(_ sender: Any) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSend(_ sender: Any) {
        self.view.endEditing(true)
        self.validationForSend()
    }
}

//MARK: Custom methods -
extension ForgotPasswordVC{
    
    func validationForSend(){
        self.txtEmail.text = self.txtEmail.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let isEmailAddressValid = objValidationManager.validateEmail(with: txtEmail.text ?? "")
        if txtEmail.text?.isEmpty == true  {
            objAppShareData.showAlert(title: kAlertTitle, message: BlankEmail, view: self)
        }else if !isEmailAddressValid  {
            objAppShareData.showAlert(title: kAlertTitle, message: InvalidEmail, view: self)
        }else{
            self.callWSForResetPswd()
        }
    }
    
    //MARK: WebServices -
    
    func callWSForResetPswd(){
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAppShareData.showNetworkAlert(view:self)
            return
        }
        
        self.view.endEditing(true)
        objWebServiceManager.showIndicator()
        
        let param = [WsParam.email : self.txtEmail.text!,WsParam.user_type:objAppShareData.strUserType]
        print(param)
        
        objWebServiceManager.requestPatch(strURL: WsUrl.ResetPassword, params: param, queryParams: [:], strCustomValidation: "", success: { (response) in
            print(response)
            let code = response["status_code"] as? Int
            let message = response["message"] as? String
            
            if code == 200{
                objWebServiceManager.hideIndicator()
                objAppShareData.showAlertCallBackOk(alertLeftBtn: "Ok", title: kAlertTitle, message: message ?? "", controller: self) {
                    self.navigationController?.popViewController(animated: true)
                }
                
                self.txtEmail.text = ""
            }else{
                objWebServiceManager.hideIndicator()
                objAppShareData.showAlert(title: kAlertTitle, message: message ?? "", view: self)
                
            }
        }) { (error) in
            print(error)
            objWebServiceManager.hideIndicator()
        }
    }
}

//MARK: TextFieldDelegate -

extension ForgotPasswordVC{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtEmail {
            textField.resignFirstResponder()
            self.view.endEditing(true)
        }
        return true
    }
}
