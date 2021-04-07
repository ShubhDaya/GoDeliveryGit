//
//  DeliverySignUpVcViewController.swift
//  Go Delivery
//
//  Created by MACBOOK-SHUBHAM V on 04.11.20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.


//  Signup_VC.swift
//  Created by Narendra-macbook on 07/05/20.
//  Copyright © 2020 MINDIII. All rights reserved.
//

import UIKit
import AuthenticationServices
import GoogleSignIn
import FacebookCore
import FacebookLogin
import SDWebImage
import TwitterKit
import TwitterCore

//var social_status = ""

class DeliverySignUpVcViewController: UIViewController {
    
    //MARK:- OUTLETS -
    
    @IBOutlet weak var btnSignIn: UIButton!
    @IBOutlet weak var vwFacebooklogin: UIView!
    @IBOutlet weak var vwGooglelogin: UIView!
    @IBOutlet weak var vwApplelogin: UIView!
    @IBOutlet weak var vwOrText: UIView!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var lblCountryCode: UILabel!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    
    @IBOutlet weak var txtMiddleName: UITextField!
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    
    @IBOutlet weak var imgVwUsernameAvail: UIImageView!
    @IBOutlet weak var viewpasswordFiled: UIView!
    @IBOutlet weak var viewCondirmPassField: UIView!
    
    @IBOutlet weak var viewProfile: UIView!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var viewCamera: UIView!
    @IBOutlet weak var imgSecurePassword: UIImageView!
    @IBOutlet weak var imgSecureConfirmPassword: UIImageView!
    
    var imagePicker = UIImagePickerController()
    var convertedImage : UIImage!
    var isFromCountrypicker = false
    var dictSocialData = [String:AnyObject]()
    var strSocialType = ""
    var strSocialID = ""
    var strFirstName = ""
    var strLastName = ""
    var strEmail = ""
    var strProfile = ""
    var strCountryCode = ""
    var strDialCode = "+61"
    var strPhoneNumber = ""
    var SocialImage:UIImage? = nil
    var isSecurePassText = false
    var isSecureConfirmPassText = false
    var ProfilePic = ""
    var selectedDeliveryPersonImg = UIImageView()
    var strCountryName = ""
    var strCity = ""
    var strCityLat = ""
    var strCityLong = ""
    
    //MARK:- View lifecycle methods -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initalUISetup()
        imagePicker.delegate = self
        self.addDoneButtonOnKeyboard()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.view.endEditing(true)
        self.txtFirstName.delegate = self
        self.txtLastName.delegate = self
        self.txtMiddleName.delegate = self
        self.txtEmail.delegate = self
        self.txtPassword.delegate = self
        self.txtConfirmPassword.delegate = self
        isfromSignUp = false
        if self.isFromCountrypicker == true{
            self.isFromCountrypicker = false
        }else{
            self.lblCountryCode.text = "+61"
        }
    }
    
    //MARK:- Local Methods -
    
    func initalUISetup(){
        self.strCountryCode = "US"
        self.strDialCode = "+61"
        self.btnSignIn.btnRadNonCol22()
        self.btnSignIn.setbtnshadow()
        self.imgUser.setImgCircle()
        self.viewProfile.setviewCircle()
        self.viewProfile.setshadowViewCircle()
    }
    
    func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        txtPhoneNumber.inputAccessoryView = doneToolbar
    }
    
    
    @objc func doneButtonAction(){
        txtPhoneNumber.resignFirstResponder()
        self.txtPassword.becomeFirstResponder()
    }
    
    func validation(){
        let strPassword = self.txtPassword.text?.count ?? 0
        _ = self.txtConfirmPassword.text?.count ?? 0
        
        self.txtFirstName.text = self.txtFirstName.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        self.txtLastName.text = self.txtLastName.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        self.txtMiddleName.text = self.txtMiddleName.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        self.txtEmail.text = self.txtEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        self.txtPhoneNumber.text = self.txtPhoneNumber.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        self.txtPhoneNumber.text = self.txtPhoneNumber.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        self.txtPassword.text = self.txtPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        self.txtConfirmPassword.text = self.txtConfirmPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if selectedDeliveryPersonImg.image == nil{
            objAppShareData.showAlert(title: kAlertTitle, message: BlankProfilePic, view: self)
            
            
        }else if (txtFirstName.text?.isEmpty)!{
            objAppShareData.showAlert(title: kAlertTitle, message: BlankFirstName, view: self)
            
        }else if (self.txtFirstName.text?.count ?? 0) < 3 {
            objAppShareData.showAlert(title: kAlertTitle, message: MinLengthFirstName, view: self)
            
        }else if (self.txtFirstName.text?.count ?? 0) > 15 {
            objAppShareData.showAlert(title: kAlertTitle, message: MaxLengthFirstName, view: self)
            
        } else if !objValidationManager.isNameString(nameStr: txtFirstName.text ?? "") {
            objAppShareData.showAlert(title: kAlertTitle, message: InvalidFirstName, view: self)
            
        }else if (txtLastName.text?.isEmpty)!{
            objAppShareData.showAlert(title: kAlertTitle, message: BlankLastName, view: self)
            
        }else if (self.txtLastName.text?.count ?? 0) < 3 {
            objAppShareData.showAlert(title: kAlertTitle, message: MinLengthLastName, view: self)
            
        }else if (self.txtLastName.text?.count ?? 0) > 15 {
            objAppShareData.showAlert(title: kAlertTitle, message: MaxLengthLastName, view: self)
            
        }
        else if !objValidationManager.isNameString(nameStr: txtLastName.text ?? "") {
            
            objAlert.showAlert(message: InvalidLasttName, title: kAlertTitle, controller: self)
            
        }else if (self.txtEmail.text?.isEmpty)!{
            objAppShareData.showAlert(title: kAlertTitle, message: BlankEmail, view: self)
            
        }else if !objValidationManager.validateEmail(with: txtEmail.text ?? "") {
            objAppShareData.showAlert(title: kAlertTitle, message: InvalidEmail, view: self)
            
        }
            
            
        else if  (self.txtPhoneNumber.text!.count ) < 5  &&  self.txtPhoneNumber.text!.count > 0
        {
            objAppShareData.showAlert(title: kAlertTitle, message: InvalidPhonenumber, view: self)
            
        }
        else if  (self.txtPhoneNumber.text!.count ) > 5
        {
            if lblCountryCode.text == "" {
                objAppShareData.showAlert(title: kAlertTitle, message: BlankDialcode, view: self)
            }
            else if txtPassword.text?.isEmpty == true  {
                objAlert.showAlert(message: BlankPassword, title: kAlertTitle, controller: self
                )
            }else if strPassword < 6{
                objAlert.showAlert(message: LengthPassword, title: kAlertTitle, controller: self
                )
            }else if (self.txtConfirmPassword.text?.isEmpty)!{
                objAppShareData.showAlert(title: kAlertTitle, message: BlankConfirmPwd, view: self)
                
            }else if (self.txtPassword.text != self.txtConfirmPassword.text) {
                objAppShareData.showAlert(title: kAlertTitle, message:InvalidConfirmPwd , view: self)
            }else if txtCountry.text == ""{
                objAppShareData.showAlert(title: kAlertTitle, message: BlankCountry, view: self)
                
            }else if txtCity.text == ""{
                objAppShareData.showAlert(title: kAlertTitle, message: BlankCity, view: self)
            }
            else{
                self.callWebSignUp()
                print("validation success")
            }
        }
            
        else if txtPassword.text?.isEmpty == true  {
            objAlert.showAlert(message: BlankPassword, title: kAlertTitle, controller: self
            )
        }else if strPassword < 6{
            objAlert.showAlert(message: LengthPassword, title: kAlertTitle, controller: self
            )
        }else if (self.txtConfirmPassword.text?.isEmpty)!{
            objAppShareData.showAlert(title: kAlertTitle, message: BlankConfirmPwd, view: self)
            
        }else if (self.txtPassword.text != self.txtConfirmPassword.text) {
            objAppShareData.showAlert(title: kAlertTitle, message:InvalidConfirmPwd , view: self)
        }else if txtCountry.text == ""{
            objAppShareData.showAlert(title: kAlertTitle, message: BlankCountry, view: self)
            
        }else if txtCity.text == ""{
            objAppShareData.showAlert(title: kAlertTitle, message: BlankCity, view: self)
        }
        else{
            self.callWebSignUp()
            print("validation without phone and dial code success")
            
        }
    }
    
    func SocialSignUpValidation(){
        
        if strPhoneNumber == ""{
            strCountryCode = ""
            strDialCode = ""
            
        }else{
            self.callWebserviceFrSocialSignIn()
        }
    }
    
    //MARK:- Button Actions -
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.view.endEditing(true)
        objAppShareData.isFromSocialcase  = false
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSignUpAction(_ sender: Any) {
        self.view.endEditing(true)
        self.validation()
    }
    
    @IBAction func btnSignIN(_ sender: Any) {
        self.view.endEditing(true)
        let objVc = UIStoryboard.init(name: "Main", bundle: nil) .instantiateViewController(withIdentifier: "Login_VC")as! Login_VC
        self.navigationController?.pushViewController(objVc, animated: true)
    }
    
    @IBAction func btnCountry(_ sender: Any) {
        
        self.isFromCountrypicker = true
        PlacePicker.shared.openPicker(controller: self, success: { (placeDict) in
            print("place info = \(placeDict)")
            
            let coordLat = placeDict["coordLat"] as? CLLocationDegrees ?? 0.0
            let coordLong = placeDict["coordLong"] as? CLLocationDegrees ?? 0.0
            let Cordinate = CLLocationCoordinate2D.init(latitude: coordLat, longitude: coordLong)
            PlacePicker.shared.reverseGeocodeCoordinate(Cordinate, success: { (addressModel) in
                
                self.strCountryName = addressModel.country ?? ""
                print(self.strCountryName)
                
                self.txtCountry.text = self.strCountryName
            }) { (error) in
                
                print("error in getting address.")
            }
        }) { (error) in
            print("error = \(error.localizedDescription)")
        }
    }
    
    @IBAction func btnCity(_ sender: Any) {
        
        self.isFromCountrypicker = true
        PlacePicker.shared.openPicker(controller: self, success: { (placeDict) in
            print("place info = \(placeDict)")
            self.strCityLat = placeDict["lat"] as? String ?? ""
            print(self.strCityLat)
            self.strCityLong = placeDict["long"]
                as? String ?? ""
            let coordLat = placeDict["coordLat"] as? CLLocationDegrees ?? 0.0
            let coordLong = placeDict["coordLong"] as? CLLocationDegrees ?? 0.0
            
            let Cordinate = CLLocationCoordinate2D.init(latitude: coordLat, longitude: coordLong)
            PlacePicker.shared.reverseGeocodeCoordinate(Cordinate, success: { (addressModel) in
                self.strCity = addressModel.city ?? ""
                
                if self.strCity == ""{
                    
                }else{
                    self.txtCity.text = self.strCity
                }
            }) { (error) in
                
                print("error in getting address.")
            }
        }) { (error) in
            print("error = \(error.localizedDescription)")
        }
    }
    
    
    @IBAction func btnUploadImage(_ sender: Any) {
        self.view.endEditing(true)
        
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: { _ in
            
        }))
        
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alert.popoverPresentationController?.sourceView = sender as? UIView
            alert.popoverPresentationController?.sourceRect = (sender as AnyObject).bounds
            alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func btnSecurePassWord(_ sender: Any) {
        self.view.endEditing(true)
        
        if isSecurePassText == false{
            self.txtPassword.isSecureTextEntry = true
            imgSecurePassword.image = #imageLiteral(resourceName: "hide_pass_ico")
            isSecurePassText = true
        }else{
            self.txtPassword.isSecureTextEntry = false
            isSecurePassText = false
            imgSecurePassword.image = #imageLiteral(resourceName: "show_pass_ico")
        }
    }
    
    
    @IBAction func btnSecureConfirmPassword(_ sender: Any) {
        self.view.endEditing(true)
        
        if isSecureConfirmPassText == false{
            self.txtConfirmPassword.isSecureTextEntry = true
            imgSecureConfirmPassword.image = #imageLiteral(resourceName: "hide_pass_ico")
            
            isSecureConfirmPassText = true
        }else{
            self.txtConfirmPassword.isSecureTextEntry = false
            isSecureConfirmPassText = false
            imgSecureConfirmPassword.image = #imageLiteral(resourceName: "show_pass_ico")
        }
    }
    @IBAction func btnAddCountryCode(_ sender: Any) {
        self.view.endEditing(true)
        
        self.isFromCountrypicker = true
        let sb = UIStoryboard.init(name: "CountryPicker", bundle: Bundle.main).instantiateViewController(withIdentifier: "RSCountryPickerController")as! RSCountryPickerController
        sb.RScountryDelegate = self as? RSCountrySelectedDelegate
        self.navigationController?.pushViewController(sb, animated: true)
    }
    
    @IBAction func btntwitterSIgnIN(_ sender: Any) {
        self.getTwitterData()
    }
    
    
    @IBAction func btnFacebookSignInAction(_ sender: Any) {
        self.view.endEditing(true)
        let objFBSDKLoginManager : LoginManager = LoginManager()
        objFBSDKLoginManager.logOut()
        SocialUtility.shared.getFacebookData(sender: self, completionHandler: {[weak self] (sucess, userDict) in
            guard self != nil else {return}
            if sucess == true, let responseDict = userDict{
                print(responseDict)
                //  objWebServiceManager.showIndicator()
                self!.strSocialType = "2"
                self!.dictSocialData = responseDict as! [String : AnyObject]
                let firstname = self?.dictSocialData["first_name"]
                let lastname = self?.dictSocialData["last_name"]
                let id = self?.dictSocialData["id"]
                _ = self?.dictSocialData["name"]
                _ = self?.dictSocialData["email"]
                let strEmail = self?.dictSocialData["email"] as? String ?? ""
                let picturedata = self?.dictSocialData["picture"] as? [String:Any] ?? [:]
                let data = picturedata["data"] as? [String:Any] ?? [:]
                let url = data["url"] as? String ?? ""
                print(url)
                
                self?.ProfilePic = url
                self?.strFirstName = firstname as? String ?? ""
                self?.strLastName = firstname as? String ?? ""
                self?.strLastName = lastname as? String ?? ""
                self?.strSocialID = id as? String ?? ""
                self?.strSocialType = "2"
                self?.strEmail =  strEmail
                
                self?.callWebserviceForCheckSocialSignIn()
            }
            }
            , isForFBFriends: false, completionHandlerFriends: nil)
    }
    
    @IBAction func btnGoogleSignInAction(_ sender: Any) {
        self.view.endEditing(true)
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    
    @IBAction func btnAppleSignInAction(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    
    //MARK:- Local Methods -
    
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
    func navigateAddVehivleInfo(){
        let storyBoard = UIStoryboard(name: "Main", bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "AddVehicleInfoVc") as! AddVehicleInfoVc
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func navigateToEmailVC(){
        let storyBoard = UIStoryboard(name: "Main", bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "VerifyEmailVc") as! VerifyEmailVc
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func checkApplicationApprovedStatus(){
        let storyBoard = UIStoryboard(name: "Main", bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "ApplicationApprovedStatusVC") as! ApplicationApprovedStatusVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}


//MARK:- TextFieldDelegate -

extension DeliverySignUpVcViewController:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.txtFirstName{
            self.txtMiddleName.becomeFirstResponder()
        }
        else if textField == self.txtMiddleName{
            self.txtLastName.becomeFirstResponder()
            
        }
        else if textField == self.txtLastName{
            self.txtEmail.becomeFirstResponder()
            
        }else if textField == self.txtEmail{
            self.txtPhoneNumber.becomeFirstResponder()
            
        }else if textField == self.txtPhoneNumber{
            if objAppShareData.isFromSocialcase == true {
                self.txtPhoneNumber.resignFirstResponder()
            }else{
                self.txtPassword.becomeFirstResponder()
            }
        }else if textField == self.txtPassword{
            self.txtConfirmPassword.becomeFirstResponder()
            
        }else if textField == self.txtConfirmPassword{
            self.txtConfirmPassword.resignFirstResponder()
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool
    {
        if textField == txtPhoneNumber {
            let maxLength = 12
            let currentString: NSString = txtPhoneNumber.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
            
        }
        return true
    }
}

//MARK:- RSCountrySelectedDelegate -

extension DeliverySignUpVcViewController :RSCountrySelectedDelegate{
    
    func RScountrySelected(countrySelected country: CountryInfo) {
        _ = "CountryPicker.bundle/\(country.country_code).png"
        //  self.imgVwFlag.image = UIImage(named: imagePath)
        //        strCountryDialCode = country.dial_code
        self.lblCountryCode.text = " \(country.dial_code)"
        self.strCountryCode = country.country_code
        self.strDialCode = country.dial_code
        print(strCountryCode)
    }
}

//MARK:- Imagepicker Delegate -
extension DeliverySignUpVcViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true
            imagePicker.modalPresentationStyle = .fullScreen
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert = UIAlertController(title: "Warning", message: "You don't have camera.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func openGallary()
    {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.modalPresentationStyle = .fullScreen
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        imgUser.image = nil
        imgUser.image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        imgUser.image = imgUser.image?.fixOrientation()
        let Uimage = imgUser.image
        selectedDeliveryPersonImg.image = Uimage
        imgUser.layer.cornerRadius = imgUser.frame.size.height / 2
        imgUser.layer.masksToBounds = true
        self.dismiss(animated: true, completion: nil)
    }
    
    func convertImageToBase64(_ image: UIImage) -> String {
        let imageData:NSData = image.jpegData(compressionQuality: 0.4)! as NSData
        let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
        return strBase64
    }
}

//MARK:- WebServiceCalling -

extension DeliverySignUpVcViewController {
    
    func callWebSignUp(){
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAppShareData.showNetworkAlert(view:self)
            return
        }
        objWebServiceManager.showIndicator()
        self.view.endEditing(true)
        
        
        if txtPhoneNumber.text == ""{
            self.strDialCode = ""
            self.strCountryCode = ""
        }else{
            print(self.strDialCode)
            print(self.strCountryCode)
        }
        
        let param = [WsParam.user_firstName:self.txtFirstName.text ?? "",
                     WsParam.user_MiddleName:self.txtMiddleName.text ?? "",
                     WsParam.user_lastName:self.txtLastName.text ?? "",
                     WsParam.email:self.txtEmail.text ?? "",
                     WsParam.phone_dialCode:self.strDialCode,
                     WsParam.country_code:self.strCountryCode,
                     WsParam.phone_number:self.txtPhoneNumber.text ?? "",
                     WsParam.password:self.txtPassword.text ?? "",
                     WsParam.confirm_password:self.txtConfirmPassword.text ?? "",
                     WsParam.country:self.strCountryName,
                     WsParam.location:self.strCity,
                     WsParam.latitude:self.strCityLat,
                     WsParam.longitude:self.strCityLong,
                     WsParam.firebase_token:objAppShareData.strFirebaseToken] as [String : Any]
        
        let imageParam = [WsParam.profilepicture] as [String]
        print(param)
        
        var imageDataCustomer : Data?
        imageDataCustomer = self.imgUser.image?.pngData()
        let imageUploadData = [imageDataCustomer] as! [Data]
        
        objWebServiceManager.uploadMultipartMultipleImagesData(strURL: WsUrl.DeliveryPersonSignUp, params: param, showIndicator: false, imageData: nil, imageToUpload: imageUploadData, imagesParam: imageParam, fileName: nil, mimeType:  "image/*", success: { (response) in
            let status = (response["status"] as? String)
            let message = (response["message"] as? String)
            print(param)
            
            if status == k_success{
                objWebServiceManager.hideIndicator()
                if let data = response["data"]as? [String:Any]{
                    isfromSignUp = true
                    let user_details  = data["user_details"] as? [String:Any]
                    objAppShareData.SaveUpdateUserInfoFromAppshareData(userDetail: user_details ?? [:])
                    objAppShareData.fetchUserInfoFromAppshareData()
                    
                }
                
                let objVc = self.storyboard?.instantiateViewController(withIdentifier: "VerifyEmailVc")as! VerifyEmailVc
                self.navigationController?.pushViewController(objVc, animated: true)
                //
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
        
        let param = [WsParam.firebase_token :objAppShareData.strFirebaseToken,
                     WsParam.social_id :strSocialID,
                     WsParam.email :strEmail,
                     WsParam.user_type :objAppShareData.strUserType,
                     WsParam.social_type :self.strSocialType] as [String : Any]
        print("************* -\(param)")
        
        objWebServiceManager.requestPost(strURL:WsUrl.CheckSocialStatus, queryParams: [:], params: param, strCustomValidation: "", showIndicator: true, success: {response in
            
            let status = (response["status"] as? String)
            _ = (response["message"] as? String)
            var socialStatus:Int?
            
            if status == k_success{
                objWebServiceManager.hideIndicator()
                if let data = response["data"]as? [String:Any]{
                    socialStatus = data["social_status"] as? Int ?? 3
                    let social_statusINt = data["social_status"]as? Int ?? 11
                    print(social_statusINt)
                    objAppShareData.userDetail.social_status = String(social_statusINt)
                    print(objAppShareData.userDetail.social_status)
                    
                }
                if socialStatus == 0{
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
                            
                            self.SocialSignUpValidation()
                            
                        }else{
                            
                            self.callWebForSocialSignInDeliveryPerson()
                        }
                    }
                    
                }else{
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
                                
                            }else if objAppShareData.userDetail.strisOnboardingStep == "4"{
                                self.navigateAddVehivleInfo()
                            }
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

//MARK:- Google sign in method

extension DeliverySignUpVcViewController:GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if (error) != nil {
            // handle here the error case
        }else {
            // objWebServiceManager.showIndicator()
            self.strSocialType = "1"
            let userId = user.userID
            self.strSocialID = userId ?? ""
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
            let profileImg = self.dictSocialData["pic"] as? String ?? ""
            
            self.ProfilePic = profileImg
            
            print(firstname ?? "")
            print(name ?? "")
            print(id ?? "")
            print(" email address \(String(describing: email))")
            //strUserName  = String(firstname ?? "")
            self.strFirstName = firstname as? String ?? ""
            self.strLastName = lastname as? String ?? ""
            self.strSocialID = id as? String ?? ""
            self.strSocialType = "1"
            self.strEmail =  strEmail
            self.callWebserviceForCheckSocialSignIn()
            //  self.callWebserviceForCheckSocialSignIn()
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
extension DeliverySignUpVcViewController{
    
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
                            self.strSocialType = "2"
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
