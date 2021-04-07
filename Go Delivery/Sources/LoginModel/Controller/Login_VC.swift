
//  Login_VC.swift
//  Breath
//  Created by Narendra-macbook on 06/05/20.
//  Copyright © 2020 MINDIII. All rights reserved.

import UIKit
import IQKeyboardManagerSwift
import AuthenticationServices
import GoogleSignIn
import FacebookCore
import FacebookLogin
import TwitterKit
import TwitterCore

class Login_VC: UIViewController {
    
    //MARK:- OUTLETS-
    
    @IBOutlet weak var btnSignIn: UIButton!
    @IBOutlet weak var vwFacebooklogin: UIView!
    @IBOutlet weak var vwGooglelogin: UIView!
    @IBOutlet weak var vwApplelogin: UIView!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnback: UIButton!
    @IBOutlet weak var imgback: UIImageView!
    @IBOutlet weak var imgHideText: UIImageView!
    
    //MARK:- Local Variables -
    
    var dictSocialData = [String:AnyObject]()
    var isSecureText = false
    var strSocialID = ""
    var strFirstName = ""
    var strLastName = ""
    var strEmail = ""
    var strProfile = ""
    var strSocialType = ""
    var strCountryCode = ""
    var strDialCode = ""
    var strPhoneNumber = ""
    var ProfilePic = ""
    var SocialImage:UIImage? = nil
    var strSocial_type = ""
    
    
    //MARK:- View lifecycle methods -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.endEditing(true)
        self.txtPassword.delegate = self
        self.txtUsername.delegate = self
        self.txtPassword.isSecureTextEntry = true
        self.btnSignIn.setbtnshadow()
        self.btnSignIn.btnRadNonCol22()
        print(objAppShareData.userDetail.strEmail)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.endEditing(true)
        txtUsername.text = ""
        txtPassword.text = ""
    }
    
    //MARK:- Custom Functions-
    
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
    
    
    func  checkOnboardingSteps(){
        let emailVerified = objAppShareData.userDetail.str_is_EmailVerifed
        let auth = UserDefaults.standard.string(forKey: UserDefaults.Keys.AuthToken) ?? ""
        let userID = UserDefaults.standard.value(forKey: UserDefaults.KeysDefault.kUserId)
        let usertype = objAppShareData.userDetail.strUserType
        let token = objAppShareData.userDetail.strAuth_token
        
        if token == ""{
            
        }else if userID == nil{
            // for if user in tab bar we check user id
            if usertype == "customer" && objAppShareData.strUserType == "customer" {
                if objAppShareData.userDetail.str_is_EmailVerifed == "0"{
                    self.navigateToEmailVC()
                    
                }else{
                    ObjAppdelegate.showTabbarNavigation()
                }
                
            }else {
                if   objAppShareData.userDetail.strisOnboardingComplete == "1"{
                    
                }else if  objAppShareData.userDetail.strisOnboardingComplete == "0"{
                    if objAppShareData.userDetail.str_is_EmailVerifed == "0"{
                        self.navigateToEmailVC()
                        
                    }
                    else if objAppShareData.userDetail.strisOnboardingStep == "1"{
                        objAlert.showAlert(message: k_UnderDevlope, title: kAlertTitle, controller: self)
                        
                        
                    }else if objAppShareData.userDetail.strisOnboardingStep == "2"{
                        
                        objAlert.showAlert(message: k_UnderDevlope, title: kAlertTitle, controller: self)
                        
                    }else if objAppShareData.userDetail.strisOnboardingStep == "3"{
                        
                        objAlert.showAlert(message: k_UnderDevlope, title: kAlertTitle, controller: self)
                        
                    }
                    
                }
            }
            
        }
    }
    
    
    func validation(){
        let strPassword = self.txtPassword.text?.count ?? 0
        let isEmailAddressValid = objValidationManager.validateEmail(with: txtUsername.text ?? "")
        self.txtUsername.text = self.txtUsername.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        self.txtPassword.text = self.txtPassword.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if txtUsername.text?.isEmpty  == true  {
            objAlert.showAlert(message: BlankEmail, title: kAlertTitle, controller: self)
        }else if !isEmailAddressValid  {
            objAlert.showAlert(message:InvalidEmail, title: kAlertTitle, controller: self)
            
        } else if txtPassword.text?.isEmpty == true  {
            objAlert.showAlert(message: BlankPassword, title: kAlertTitle, controller: self
            )
        }
        else if strPassword < 6{
            objAlert.showAlert(message: LengthPassword, title: kAlertTitle, controller: self
            )
        }
        else{
            self.callWebserviceForLogin()
        }
    }
    
    //MARK:- Button Actions-
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSignInAction(_ sender: Any) {
        self.view.endEditing(true)
        self.validation()
    }
    
    @IBAction func btnSecuretext(_ sender: Any) {
        self.view.endEditing(true)
        
        if isSecureText == false{
            self.txtPassword.isSecureTextEntry = true
            imgHideText.image = #imageLiteral(resourceName: "hide_pass_ico")
            isSecureText = true
        }else{
            self.txtPassword.isSecureTextEntry = false
            isSecureText = false
            imgHideText.image = #imageLiteral(resourceName: "show_pass_ico")
        }
    }
    
    @IBAction func btnForgotPassword(_ sender: Any) {
        self.view.endEditing(true)
        let objVc = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordVC")as! ForgotPasswordVC
        self.navigationController?.pushViewController(objVc, animated: true)
    }
    
    @IBAction func btnFacebookSignInAction(_ sender: Any) {
        self.view.endEditing(true)
        self.view.endEditing(true)
        let objFBSDKLoginManager : LoginManager = LoginManager()
        objFBSDKLoginManager.logOut()
        SocialUtility.shared.getFacebookData(sender: self, completionHandler: {[weak self] (sucess, userDict) in
            guard let weakSelf = self else {return}
            if sucess == true, let responseDict = userDict{
                print(responseDict)
                self!.strSocial_type = "2"
                objAppShareData.isfromFacebookLgin = true
                self?.dictSocialData = responseDict as! [String : AnyObject]
                
                let firstname = self?.dictSocialData["first_name"]
                let lastname = self?.dictSocialData["last_name"]
                let id = self?.dictSocialData["id"]
                _ = self?.dictSocialData["name"]
                let strEmail = self?.dictSocialData["email"] as? String ?? ""
                
                let picturedata = self?.dictSocialData["picture"] as? [String:Any] ?? [:]
                let data = picturedata["data"] as? [String:Any] ?? [:]
                let url = data["url"] as? String ?? ""
                self?.ProfilePic = url
                
                self?.strFirstName = firstname as? String ?? ""
                self?.strLastName = lastname as? String ?? ""
                self?.strSocialID = id as? String ?? ""
                self?.strSocialType = "2"
                self?.strEmail =  strEmail
                
                self?.callWebserviceForCheckSocialSignIn()
            }
            }
            , isForFBFriends: false, completionHandlerFriends: nil)
    }
    
    @IBAction func btnSignUp(_ sender: Any) {
        
        if objAppShareData.strUserType == "customer"{
            self.view.endEditing(true)
            let objVc = self.storyboard?.instantiateViewController(withIdentifier: "Signup_VC")as! Signup_VC
            self.navigationController?.pushViewController(objVc, animated: true)
        }else{
            self.view.endEditing(true)
            let objVc = self.storyboard?.instantiateViewController(withIdentifier: "DeliverySignUpVcViewController")as! DeliverySignUpVcViewController
            self.navigationController?.pushViewController(objVc, animated: true)
            
        }
    }
    
    @IBAction func btnGoogleSignInAction(_ sender: Any) {
        self.view.endEditing(true)
        self.view.endEditing(true)
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func btnTwitterSignIN(_ sender: Any) {
        self.getTwitterData()
    }
    
    @IBAction func btnAppleSignInAction(_ sender: Any) {
        self.view.endEditing(true)
        objAlert.showAlert(message: "Under Development ", title: "Alert", controller: self)
        
        //        self.view.endEditing(true)
        //
        //        if #available(iOS 13.0, *) {
        //            let appleIDProvider = ASAuthorizationAppleIDProvider()
        //            let request = appleIDProvider.createRequest()
        //            request.requestedScopes = [.fullName, .email]
        //            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        //            //  authorizationController.delegate = self
        //            // Create an authorization controller with the given requests.
        //            authorizationController.delegate = self
        //            authorizationController.presentationContextProvider = self
        //            authorizationController.performRequests()
        //        } else {
        //            // Fallback on earlier versions
        //        }
        //    }
    }
    //
    
    ////MARK:- Apple login
    //@available(iOS 13.0, *)
    //extension Login_VC: ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding{
    //
    //    @available(iOS 13.0, *)
    //    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
    //        return self.view.window!
    //    }
    //
    //    @available(iOS 13.0, *)
    //    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    //        if #available(iOS 13.0, *) {
    //            switch authorization.credential {
    //            case let appleIDCredential as ASAuthorizationAppleIDCredential:
    //
    //                // Create an account in your system.
    //                let userIdentifier = appleIDCredential.user
    //                let fullName = appleIDCredential.fullName
    //                let email = appleIDCredential.email
    //                let givenName = appleIDCredential.fullName?.givenName
    //                let familyName = appleIDCredential.fullName?.familyName
    //                dictSocialData = ["id": userIdentifier,"name":fullName ?? "","email":email ?? "","pic":"urlString"] as [String : AnyObject]
    //                //                print("Test Rohit")
    //                //                print(appleIDCredential.fullName?.givenName)
    //                //                print(appleIDCredential.fullName?.familyName)
    //                //                print(email)
    //                //                print(userIdentifier)
    //
    //                //                self.strUserSocialEmail = email as? String ?? ""
    //                //                self.strUserSocialId = userIdentifier as? String ?? ""
    //                //                self.strUsername = "\(givenName) " + (familyName ?? "")
    //                //                self.strUserSocialType = "3"
    //                //
    //                self.strSocial_type = "3"
    //                self.callWebserviceForCheckSocialSignIn()
    //
    //            case let passwordCredential as ASPasswordCredential:
    //
    //                // Sign in using an existing iCloud Keychain credential.
    //                let username = passwordCredential.user
    //                let password = passwordCredential.password
    //
    //                // For the purpose of this demo app, show the password credential as an alert.
    //                DispatchQueue.main.async {
    //                    // self.showPasswordCredentialAlert(username: username, password: password)
    //                }
    //
    //            default:
    //                break
    //            }
    //        } else {
    //            // Fallback on earlier versions
    //        }
    //
    //
    //    }
    //
    //
    //}
}

extension Login_VC:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.txtUsername{
            self.txtPassword.becomeFirstResponder()
            
        }else if textField == self.txtPassword{
            self.txtPassword.resignFirstResponder()
        }
        return true
    }
}

//MARK:- Webservice calling -

extension Login_VC {
    
    func callWebserviceForLogin(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAppShareData.showNetworkAlert(view:self)
            return
        }
        objWebServiceManager.showIndicator()
        self.view.endEditing(true)
        
        
        let param = [WsParam.email:self.txtUsername.text ?? "",
                     WsParam.password:self.txtPassword.text ?? "",
                     WsParam.firebase_token :objAppShareData.strFirebaseToken,
                     WsParam.user_type:objAppShareData.strUserType] as [String : Any]
        
        print(param)
        
        objWebServiceManager.requestPost(strURL:WsUrl.login, queryParams: [:], params: param, strCustomValidation: "", showIndicator: true, success: {response in
            
            let status = (response["status"] as? String)
            let message = (response["message"] as? String)
            print(response)
            
            if status == k_success{
                objWebServiceManager.hideIndicator()
                if let data = response["data"]as? [String:Any]{
                    let user_details  = data["user_details"] as? [String:Any]
                    objAppShareData.SaveUpdateUserInfoFromAppshareData(userDetail: user_details ?? [:])
                    objAppShareData.fetchUserInfoFromAppshareData()
                    
                    if objAppShareData.userDetail.strUserType == "customer"{
                        if objAppShareData.userDetail.strisOnboardingComplete == "1"{
                            print("******  OnBoarding Completed for customer ")
                            ObjAppdelegate.showTabbarNavigation()
                        }else if objAppShareData.userDetail.strisOnboardingComplete == "0"{
                            
                            print("******  OnBoarding Not Completed for customer ")
                            
                            if objAppShareData.userDetail.strisOnboardingStep == "1"{
                                
                                if objAppShareData.userDetail.str_is_EmailVerifed == "0"{
                                    print("email not verify ")
                                    let objVc = UIStoryboard.init(name: "Main", bundle: nil) .instantiateViewController(withIdentifier: "VerifyEmailVc")as! VerifyEmailVc
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
                            }
                            else if objAppShareData.userDetail.strisOnboardingStep == "3"{
                                
                                self.navigateToDownloadContract()
                            }else  if objAppShareData.userDetail.strisOnboardingStep == "4"{
                                self.navigateAddVehivleInfo()
                            }
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
    
    func callWebserviceForCheckSocialSignIn(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAppShareData.showNetworkAlert(view:self)
            return
        }
        objWebServiceManager.showIndicator()
        self.view.endEditing(true)
        
        let param = [ WsParam.firebase_token :objAppShareData.strFirebaseToken,
                      WsParam.social_id :strSocialID,
                      WsParam.email :strEmail,
                      WsParam.user_type :objAppShareData.strUserType,
                      WsParam.social_type :self.strSocialType] as [String : Any]
        
        objWebServiceManager.requestPost(strURL:WsUrl.CheckSocialStatus, queryParams: [:], params: param, strCustomValidation: "", showIndicator: true, success: {response in
            
            let status = response["status"] as? String ?? ""
            let message = response["message"] as? String ?? ""
            
            if status == k_success{
                objWebServiceManager.hideIndicator()
                var socialStatus:Int?
                
                if let data = response["data"]as? [String:Any]{
                    socialStatus = data["social_status"] as? Int ?? 3
                }
                if socialStatus == 0 {
                    
                    if self.strEmail == ""{
                        let objVc = self.storyboard?.instantiateViewController(withIdentifier: "SocialSignUpEmailVc")as! SocialSignUpEmailVc
                        objVc.strSocialID = self.strSocialID
                        objVc.strFirstName = self.strFirstName
                        objVc.strLastName = self.strLastName
                        objVc.strEmail = self.strEmail
                        objVc.strSocialType = self.strSocialType
                        objVc.ProfilePic = self.ProfilePic
                        
                        self.navigationController?.pushViewController(objVc, animated: true)
                    }else{
                        is_email_manually_added = "0"
                        
                        if objAppShareData.strUserType == "customer"{
                            
                            self.callWebserviceFrSocialSignIn()
                            
                        }else{
                            
                            self.callWebForSocialSignInDeliveryPerson()
                        }
                    }
                    
                    
                }else{
                    if let data = response["data"]as? [String:Any]{
                        
                        let social_statusINt = data["social_status"]as? Int ?? 11
                        print(social_statusINt)
                        objAppShareData.userDetail.social_status = String(social_statusINt)
                        
                        print(objAppShareData.userDetail.social_status)
                        
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
                                
                            }else  if objAppShareData.userDetail.strisOnboardingStep == "4"{
                                self.navigateAddVehivleInfo()
                            }
                        }
                        
                        
                    }
                    
                }
                
            }else{
                objWebServiceManager.hideIndicator()
                objAppShareData.showAlert(title: kAlertTitle, message: message, view: self)
            }
            
        }, failure: { (error) in
            print(error)
            objWebServiceManager.hideIndicator()
            objAppShareData.showAlert(title: kAlertTitle, message: kErrorMessage, view: self)
        })
    }
    
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
        
        print("******\(param)")
        
        objWebServiceManager.requestPost(strURL:WsUrl.SocialSignUp, queryParams: [:], params: param, strCustomValidation: "", showIndicator: true, success: {response in
            
            
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
                    
                }
                
                if objAppShareData.userDetail.strUserType == "customer"{
                    if objAppShareData.userDetail.strisOnboardingComplete == "1"{
                        
                        ObjAppdelegate.showTabbarNavigation()
                    }else if objAppShareData.userDetail.strisOnboardingComplete == "0"{
                        
                        if objAppShareData.userDetail.strisOnboardingStep == "1"{
                            
                            if objAppShareData.userDetail.str_is_EmailVerifed == "0"{
                                let objVc = UIStoryboard.init(name: "Main", bundle: nil) .instantiateViewController(withIdentifier: "VerifyEmailVc")as! VerifyEmailVc
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
                            
                        }else  if objAppShareData.userDetail.strisOnboardingStep == "4"{
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
        
        print("******\(param)")
        
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
                    
                }
                
                if objAppShareData.userDetail.strUserType == "customer"{
                    if objAppShareData.userDetail.strisOnboardingComplete == "1"{
                        
                        ObjAppdelegate.showTabbarNavigation()
                    }else if objAppShareData.userDetail.strisOnboardingComplete == "0"{
                        
                        if objAppShareData.userDetail.strisOnboardingStep == "1"{
                            
                            if objAppShareData.userDetail.str_is_EmailVerifed == "0"{
                                print("email not verify ")
                                let objVc = UIStoryboard.init(name: "Main", bundle: nil) .instantiateViewController(withIdentifier: "VerifyEmailVc")as! VerifyEmailVc
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
                            
                        }else  if objAppShareData.userDetail.strisOnboardingStep == "4"{
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

extension Login_VC{
    func callWSForEmailAlredyVerified(){
        objWebServiceManager.showIndicator()
        
        let   param = [
            WsParam.email: objAppShareData.userDetail.strEmail,
            ] as [String : Any]
        
        objWebServiceManager.requestGet(strURL: WsUrl.EmailVerifyCheck , params: param, queryParams: [:], strCustomValidation: "", success: { (response) in
            print(response)
            _ = response["code"] as? Int
            let status = response["status"] as? String ?? ""
            _ = response["message"] as? String ?? ""
            let verification = response["is_email_verified"] as? Int ?? 11
            
            if status == "success"{
                objWebServiceManager.hideIndicator()
                
                if verification == 1{
                    ObjAppdelegate.showTabbarNavigation()
                    
                }else{
                    let objVc = UIStoryboard.init(name: "Main", bundle: nil) .instantiateViewController(withIdentifier: "VerifyEmailVc")as! VerifyEmailVc
                    self.navigationController?.pushViewController(objVc, animated: true)
                }
                
                
            }else{
                objWebServiceManager.hideIndicator()
                
            }
        }) { (error) in
            objWebServiceManager.hideIndicator()
            objAppShareData.showAlert(title: kAlertTitle, message: kErrorMessage, view: self)
            print(error)
        }
    }
}
//MARK:- Google sign in method for get Google Data -

extension Login_VC:GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if (error) != nil {
        }else {
            self.strSocial_type  = "1"
            objAppShareData.isfromFacebookLgin = false
            let userId = user.userID
            _ = user.authentication.idToken
            let fullName = user.profile.name
            let email = user.profile.email
            let dimension = round(100 * UIScreen.main.scale)
            let pic = user.profile.imageURL(withDimension: UInt(dimension))
            let urlString = pic!.absoluteString
            dictSocialData = ["id": userId!,"name":fullName!,"email":email!,"pic":urlString] as [String : AnyObject]
            print(dictSocialData)
            GIDSignIn.sharedInstance().signOut()
            
            let firstname = self.dictSocialData["name"]
            let lastname = self.dictSocialData["last_name"]
            let id = self.dictSocialData["id"]
            let name = self.dictSocialData["name"]
            let strEmail = self.dictSocialData["email"] as? String ?? ""
            let  ProfilePic = self.dictSocialData["pic"]
            let profileImg = self.dictSocialData["pic"] as? String ?? ""
            self.ProfilePic = profileImg
            
            self.strFirstName = firstname as? String ?? ""
            self.strLastName = lastname as? String ?? ""
            self.strSocialID = id as? String ?? ""
            self.strSocialType = "1"
            self.ProfilePic = ProfilePic as? String ?? ""
            self.strEmail =  strEmail
            self.callWebserviceForCheckSocialSignIn()
        }
        
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
    }
    func sign(_ signIn: GIDSignIn!,present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        self.dismiss(animated: false, completion: nil)
    }
}

//MARK: GetTwiiterData -
extension Login_VC{
    
    func getTwitterData()
    {
        TWTRTwitter.sharedInstance().logIn(with: self) { (session, error) in
            if (session != nil) {
                print("signed in as \(String(describing: session?.userName))");
                
                self.dismiss(animated: true) {
                    print("Logged in ")
                }
                
                let client = TWTRAPIClient.withCurrentUser()
                
                client.requestEmail { email, error in
                    if (email != nil) {
                        self.strEmail = email!
                    } else {
                        self.strEmail = ""
                        
                        print("error: \(error!.localizedDescription)");
                    }
                    
                    
                    if (session?.userName) != nil {
                        let client = TWTRAPIClient(userID: session!.userID)
                        client.loadUser(withID: session!.userID) { (unwrappedTwtrUser, error) in
                            guard let twtrUser = unwrappedTwtrUser, error == nil else {
                                print("Twitter : TwTRUser is nil, or error has occured: ")
                                print("Twitter error: \(error!.localizedDescription)")
                                return
                            }
                            self.strSocialType = "4"
                            self.strFirstName = twtrUser.name
                            self.strSocialID  = twtrUser.userID
                            self.ProfilePic = twtrUser.profileImageLargeURL
                            
                            self.callWebserviceForCheckSocialSignIn()
                            
                            let store = TWTRTwitter.sharedInstance().sessionStore
                            if let userID = store.session()?.userID {
                                store.logOutUserID(userID)
                            }
                            
                        }
                    }
                }
            } else {
                print("error: \(error?.localizedDescription ?? "")");
            }
            
        }
    }
    
}
