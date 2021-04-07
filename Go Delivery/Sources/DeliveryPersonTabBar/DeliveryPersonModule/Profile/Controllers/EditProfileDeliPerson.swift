//
//  EditProfileDeliPerson.swift
//  Go Delivery
//  Created by MACBOOK-SHUBHAM V on 09.12.20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.

import UIKit
import AuthenticationServices
import CoreLocation
import Foundation

var isfromEditProfileDeliveryPerosn = false

class EditProfileDeliPerson: UIViewController {
    
    
    //MARK:- IBOutlet-
    @IBOutlet weak var viewHeader: UIView!
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var viewProfile: UIView!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var viewCamera: UIView!
    
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtMiddleName: UITextField!
    
    @IBOutlet weak var lblCountryCode: UILabel!
    @IBOutlet weak var
    txtPhoneNumber: UITextField!
    
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    
    @IBOutlet weak var btnUpdateProfile: UIButton!
    
    
    //MARK:- Local variables-

    var closerUpdate:((_ Updateprofile:Bool)  ->())?
    var Mydata : MyProfileModel?
    var isFromCountrypicker = false
    var strCountryName = ""
    var strCity = ""
    var strCityLat = ""
    var strCityLong = ""
   
    let imagePicker = UIImagePickerController()
    var SelectedProfileImage:UIImage? = nil
    var isEditProfile = false
    var strCountryCode = ""
    var strDialCode = ""
    var imageSize: Double = 0.0
    var isfromimgPicker = false
    var isCountryCode = true
    
    //MARK:- View Life Cycle-

    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePicker.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.initalUISetup()
        self.view.endEditing(true)
        self.txtFirstName.delegate = self
        self.txtLastName.delegate = self
        self.txtMiddleName.delegate = self
        self.txtPhoneNumber.delegate = self
    
        if isFromDeliveryPersonProfile == true && isCountryCode == true{
           
            self.txtFirstName.text = "\(objAppShareData.strDeliveryPersonUserdetails.strUserFirstName )"
            self.txtEmail.text = "\(objAppShareData.strDeliveryPersonUserdetails.strEmail )"
            
            if objAppShareData.strDeliveryPersonUserdetails.strCountry_code == "" {
                        self.lblCountryCode.text = "+61"
                        self.strCountryCode = "US"
                        self.strDialCode = "+61"
                }else{
                        self.lblCountryCode.text = "\(objAppShareData.strDeliveryPersonUserdetails.strCountry_code)"
                       }
          
                self.txtMiddleName.text = "\(objAppShareData.strDeliveryPersonUserdetails.strUserMiddleName )"
                self.txtLastName.text = "\(objAppShareData.strDeliveryPersonUserdetails.strUserlastName )"
                self.txtPhoneNumber.text = "\(objAppShareData.strDeliveryPersonUserdetails.strPhone_number )"
            
            
            if isFromCountrypicker == true{
               
                
            }else{
                self.txtCountry.text = "\(objAppShareData.strDeliveryPersonUserdetails.strcountry )"
                self.txtCity.text = "\(objAppShareData.strDeliveryPersonUserdetails.strlocation )"
                
            }
               

                let strimage = objAppShareData.strDeliveryPersonUserdetails.strProfile_picture
                let urlImg = URL(string: strimage)
                self.imgUser.sd_setImage(with: urlImg, placeholderImage:UIImage(named: "user_placeholder_img"))
            }
            
            if  isfromimgPicker == true {
                self.imgUser.image = SelectedProfileImage
            }
        }
    
    //MARK:- UiButton Action-

    @IBAction func btnBack(_ sender: Any) {        self.navigationController?.popViewController(animated: true)
             isEditProfile = false
    }

    @IBAction func btnUploadProfile(_ sender: Any) {
        self.validation()
    }
        
    @IBAction func btnUploadProfileImg(_ sender: Any) {

      self.view.endEditing(true)
            
            let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
                self.openCamera1()
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
    
    
    @IBAction func btnSelectdialCode(_ sender: Any) {
              isEditProfile = true
              isCountryCode = false
              let sb = UIStoryboard.init(name: "CountryPicker", bundle: Bundle.main).instantiateViewController(withIdentifier: "RSCountryPickerController")as! RSCountryPickerController
              sb.RScountryDelegate = self as? RSCountrySelectedDelegate
              self.navigationController?.pushViewController(sb, animated: true)
                    
    }
    
    @IBAction func btnSelectContry(_ sender: Any) {
        
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
    
    @IBAction func btnSelectCity(_ sender: Any) {
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
    
    
      //MARK:- Local Methods-

      func validation(){
        let signUpType = objAppShareData.userDetail.strsignup_type
        self.txtEmail.text = self.txtEmail.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        self.txtLastName.text = self.txtLastName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        self.txtFirstName.text = self.txtFirstName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        self.txtMiddleName.text = self.txtMiddleName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        self.txtPhoneNumber.text = self.txtPhoneNumber.text!.trimmingCharacters(in: .whitespacesAndNewlines)

        
        
//            if signUpType == "2"{
//
//                if txtLastName.text?.isEmpty == true {
//                    objAppShareData.showAlert(title: kAlertTitle, message: BlankLastName, view: self)
//                }else{
//                    if txtMobileNumber.text == "" {
//                        strDialCode = ""
//                        strCountryCode = ""
//                        callWebForUpdateProfile()
//                    }else {
//                        if  (self.txtMobileNumber.text!.count ) > 5{
//                          callWebForUpdateProfile()
//
//                        }else
//                        {
//                            objAppShareData.showAlert(title: kAlertTitle, message: InvalidPhonenumber, view: self)
//
//                        }
//                    }
//
//                }
//            }else if txtMobileNumber.text == "" {
//                strDialCode = ""
//                strCountryCode = ""
//                callWebForUpdateProfile()
//            }else {
//                if  (self.txtMobileNumber.text!.count ) > 5{
//                  callWebForUpdateProfile()
//
//                }else
//                {
//                    objAppShareData.showAlert(title: kAlertTitle, message: InvalidPhonenumber, view: self)
//
//                }
//            }
        
        if signUpType == "1"{
            if txtLastName.text?.isEmpty == true {
                objAppShareData.showAlert(title: kAlertTitle, message: BlankLastName, view: self)
            }else{
                if txtPhoneNumber.text == "" {
                    strDialCode = ""
                    strCountryCode = ""
                    callWebForUpdateProfile()
                   return
                }else {
                    if  (self.txtPhoneNumber.text!.count ) > 5{
                      callWebForUpdateProfile()
                      return

                    }else
                    {
                        objAppShareData.showAlert(title: kAlertTitle, message: InvalidPhonenumber, view: self)
                    }
                }
                
            }
            
            
        }else{
            if txtPhoneNumber.text == "" {
                strDialCode = ""
                strCountryCode = ""
                callWebForUpdateProfile()
               return
            }else {
                if  (self.txtPhoneNumber.text!.count ) > 5{
                  callWebForUpdateProfile()
                  return

                }else
                {
                    objAppShareData.showAlert(title: kAlertTitle, message: InvalidPhonenumber, view: self)
                }
            }
         // callWebForUpdateProfile()
            
        }
  
      }
    func initalUISetup(){
        self.btnUpdateProfile.btnRadNonCol22()
        self.btnUpdateProfile.setbtnshadow()
        self.imgUser.setImgCircle()
        self.viewProfile.setviewCircle()
        self.viewProfile.setshadowViewCircle()
        
        viewHeader.layer.shadowColor = UIColor.lightGray.cgColor
        viewHeader.layer.masksToBounds = false
        viewHeader.layer.shadowOffset = CGSize(width: 0.0 , height: 5.0)
        viewHeader.layer.shadowOpacity = 0.3
        viewHeader.layer.shadowRadius = 3
    }
}

//MARK:- UITextFieldDelegate-

extension EditProfileDeliPerson:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.txtFirstName{
            self.txtMiddleName.becomeFirstResponder()
        }
            else if textField == self.txtMiddleName{
                self.txtLastName.becomeFirstResponder()
                
            }
        else if textField == self.txtLastName{
            self.txtPhoneNumber.becomeFirstResponder()
            
        }else if textField == self.txtPhoneNumber{
           
                self.txtPhoneNumber.resignFirstResponder()
            
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
//MARK:- CountryPickerDelegate -
extension EditProfileDeliPerson :RSCountrySelectedDelegate{
    
    func RScountrySelected(countrySelected country: CountryInfo) {
        _ = "CountryPicker.bundle/\(country.country_code).png"
        if   isEditProfile == true{
            self.lblCountryCode.text = " \(country.dial_code)"
            self.strCountryCode = country.country_code
            self.strDialCode = country.dial_code
            self.lblCountryCode.text = country.dial_code
            print(strCountryCode)
        }
        
    }
}
//MARK:- Webservices calling  -

extension EditProfileDeliPerson {
    
    func callWebForUpdateProfile(){
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAppShareData.showNetworkAlert(view:self)
            return
        }
        objWebServiceManager.showIndicator()
        self.view.endEditing(true)
        
        var strUdidi = ""
        if let MyUniqueId = UserDefaults.standard.string(forKey:UserDefaults.Keys.strVenderId) {
            print("defaults VenderID: \(MyUniqueId)")
            strUdidi = MyUniqueId
        }
        
        let param = [WsParam.user_firstName:self.txtFirstName.text ?? "",
                     WsParam.user_MiddleName:self.txtMiddleName.text ?? "",
                     WsParam.user_lastName:self.txtLastName.text ?? "",
                     WsParam.location:self.txtCity.text ?? "",
                     WsParam.country:self.txtCountry.text ?? "",

                     WsParam.phone_dialCode:self.strDialCode,
                     WsParam.country_code:self.strCountryCode,
                     WsParam.phone_number:self.txtPhoneNumber.text ?? ""
            ] as [String : Any]
        
        let imageParam = [WsParam.profilepicture] as [String]
        var arrImageData = [Data]()

                if self.imgUser.image ==  nil
                {
                    print("BlankImage")
                }
                else
                {
                    let img = self.resizeImage(image: imgUser.image!, targetSize: CGSize(width: 200,height: 200))
                    print(img)

                    var imgData = Data()
                    imgData = (img.pngData())!
                    arrImageData.append(imgData)

                }

        objWebServiceManager.uploadMultipartMultipleImagesData(strURL: WsUrl.DeliveryPersonUpdateProfile, params: param, showIndicator: false, imageData: nil, imageToUpload: arrImageData, imagesParam: imageParam, fileName: nil, mimeType:  "image/*", success: { (response) in
            let status = (response["status"] as? String)
            let message = (response["message"] as? String)
            print(param)
            
            if status == k_success{
               // objWebServiceManager.hideIndicator()
                if let data = response["data"]as? [String:Any]{
                    if let dictExcercise = data["user_details"] as? [String:Any]{
                        let objdata = MyProfileModel.init(dict: dictExcercise)
                        self.isFromCountrypicker = false
                        objAppShareData.strDeliveryPersonUserdetails = objdata
                        isfromEditProfileDeliveryPerosn = true
                        self.callGetForMyProfile1()
            
                    }
                }
                
            }else{
                objWebServiceManager.hideIndicator()
                objAppShareData.showAlert(title: kAlertTitle, message: message ?? "", view: self)
            }
        }, failure: { (error) in
            // print(error)
            objWebServiceManager.hideIndicator()
            objAppShareData.showAlert(title: kAlertTitle, message: kErrorMessage, view: self)
        })
    }
    

    
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
    let size = image.size

    let widthRatio = targetSize.width / size.width
    let heightRatio = targetSize.height / size.height

    // Figure out what our orientation is, and use that to form the rectangle
    var newSize: CGSize
    if(widthRatio > heightRatio) {
   // newSize = CGSize(size.width heightRatio, size.height heightRatio)
        newSize = CGSize(width: 200.0, height: 200.0)

    } else {
        newSize = CGSize(width: 200.0, height: 200.0)

    }

    // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

    // Actually do the resizing to the rect using the ImageContext stuff
    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

        return newImage!
    }
  
}



 //MARK:- Imagepicker - Functions -
 extension EditProfileDeliPerson : UIImagePickerControllerDelegate,UINavigationControllerDelegate {
     
     func openCamera1()
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
         imgUser.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
         
         imgUser.image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
         imgUser.image = imgUser.image?.fixOrientation()
         isfromimgPicker = true
         SelectedProfileImage = imgUser.image
       
         self.dismiss(animated: true, completion: nil)
         self.btnUpdateProfile.backgroundColor = #colorLiteral(red: 0.879128886, green: 0.1555605951, blue: 0.2124525889, alpha: 1)
     }
     
     func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
         
      
         dismiss(animated: true, completion: nil)
     }
 }


extension EditProfileDeliPerson{
    
       func callGetForMyProfile1(){
                if !objWebServiceManager.isNetworkAvailable(){
                    objWebServiceManager.hideIndicator()
                    objAppShareData.showNetworkAlert(view:self)
                    return
                }
                
                //objWebServiceManager.showIndicator()
       
                objWebServiceManager.requestGet(strURL: WsUrl.myprofile , params:[:], queryParams: [:], strCustomValidation: "", success: { (response) in
                    print(response)
                    let status = response["status"] as? String ?? ""
                    let message = response["message"] as? String ?? ""
                    
                    if status == "success"{
                        objWebServiceManager.hideIndicator()

                        if let data = response["data"] as? [String:Any]{
                        
                            if let dictExcercise = data["profile_details"] as? [String:Any]{
                                let objExcercise = MyProfileModel.init(dict: dictExcercise)
                                objAppShareData.strDeliveryPersonUserdetails = objExcercise
                                
                    objAppShareData.strDeliveryPersonUserdetails.strmake = objExcercise.strmake
                    objAppShareData.strDeliveryPersonUserdetails.strmodele = objExcercise.strmodele
                    objAppShareData.strDeliveryPersonUserdetails.strcolor = objExcercise.strcolor
                    objAppShareData.strDeliveryPersonUserdetails.strplate_number = objExcercise.strplate_number
                    UserDefaults.standard.set(objExcercise.stris_available, forKey: "DeliveryPersonisAvailable") //Bool
                                print(objExcercise.stris_available)
                                
                    objAlert.showAlertCallBackOk(alertLeftBtn: "Ok", title: kAlertTitle, message:"Profile updated successfully", controller: self, callbackCancel: { () in
                                  self.navigationController?.popViewController(animated: true)
                              })
                                               
                              
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
