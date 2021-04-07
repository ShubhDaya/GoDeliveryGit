//
//  EditProfile.swift
//  Go Delivery
//
//  Created by MACBOOK-SHUBHAM V on 17/08/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit

class EditProfile: UIViewController {
    
    //MARK:- local varibles -
    let imagePicker = UIImagePickerController()
    var SelectedProfileImage:UIImage? = nil
    var isEditProfile = false
    var strCountryCode = ""
    var strDialCode = ""
    var Mydata : MyProfileModel?
    var imageSize: Double = 0.0
    var closerUpdate:((_ Updateprofile:Bool)  ->())?
    var isfromimgPicker = false
    var isCountryCode = true
    
    //MARK:- IBOutlets  -
    
    @IBOutlet weak var txtFullName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!

    @IBOutlet weak var lblCountryCode: UILabel!
    @IBOutlet weak var txtMobileNumber: UITextField!
    @IBOutlet weak var viewProfileImg: UIView!
    @IBOutlet weak var btnUpdateProfile: UIButton!
    @IBOutlet weak var btnUploadPicture: UIButton!
    @IBOutlet weak var lblUploadCamera: UILabel!
    @IBOutlet weak var imgCamera: UIImageView!
    @IBOutlet weak var imgProfileImg: customImage!
    @IBOutlet weak var btnupdateProfileAgain: UIButton!
    
    //MARK:- ViewLifeCycles  -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isCountryCode = true
        imagePicker.delegate = self
        self.txtMobileNumber.delegate = self
        self.txtFullName.delegate = self
        self.txtLastName.delegate = self

        self.btnupdateProfileAgain.isHidden = true
        self.viewProfileImg.setShadowAllView5()
        self.btnUpdateProfile.btnRadNonCol22()
        self.btnUpdateProfile.setbtnshadow()
        // Do any additional setup after loading the view.
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.btnUpdateProfile.backgroundColor = #colorLiteral(red: 0.879128886, green: 0.1555605951, blue: 0.2124525889, alpha: 1)
        if isFromProfile == true && isCountryCode == true{
            
            let countrycode = Mydata?.strCountry_code
            if countrycode == ""{
                self.lblCountryCode.text = "+61"
                self.strCountryCode = "US"
                self.strDialCode = "+61"
            }else{
                self.lblCountryCode.text = Mydata?.strCountry_code
            }
            if Mydata?.strUserlastName == ""{
                
            }else if Mydata?.strUserlastName != ""{
                self.txtLastName.text = Mydata?.strUserlastName ?? ""
            }
            
            if Mydata?.strUserFirstName == ""{
                           
            }else if Mydata?.strUserFirstName != ""{
                self.txtFullName.text = Mydata?.strUserFirstName ?? ""
            }
            
            if Mydata?.strPhone_number == ""{
                                      
            }else if Mydata?.strPhone_number != ""{
               self.txtMobileNumber.text = Mydata?.strPhone_number ?? ""
            }
            
            let strimage = Mydata?.strProfile_picture ?? ""
            let urlImg = URL(string: strimage)
            self.imgProfileImg.sd_setImage(with: urlImg, placeholderImage:UIImage(named: "user_placeholder_img"))
        }
        
        if  isfromimgPicker == true {
            imgProfileImg.image = SelectedProfileImage
        }
        
        if  self.imgProfileImg.image != nil {
            self.lblUploadCamera.isHidden = true
            self.imgCamera.isHidden = true
            self.btnUploadPicture.isHidden = true
            self.btnupdateProfileAgain.isHidden = false
        }else {
            self.lblUploadCamera.isHidden = false
            self.imgCamera.isHidden = false
            self.btnUploadPicture.isHidden = false
        }
    }

    //MARK:- Buttons Actions -
    
    @IBAction func btnBcak(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        isEditProfile = false
    }
    @IBAction func btnSelectCountryCode(_ sender: Any) {
        isEditProfile = true
        isCountryCode = false
        let sb = UIStoryboard.init(name: "CountryPicker", bundle: Bundle.main).instantiateViewController(withIdentifier: "RSCountryPickerController")as! RSCountryPickerController
        sb.RScountryDelegate = self as? RSCountrySelectedDelegate
        self.navigationController?.pushViewController(sb, animated: true)
        
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
            if  self.imgProfileImg.image != nil {
                self.lblUploadCamera.isHidden = true
                self.imgCamera.isHidden = true
            }
            else {
                self.lblUploadCamera.isHidden = false
                self.imgCamera.isHidden = false
            }
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
    
    @IBAction func btnUpdateProfile(_ sender: Any) {
       self.validation()
    }
    
    
    @IBAction func btnUpdateProfileAgain(_ sender: Any) {
        self.view.endEditing(true)

        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera1()
        }))
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: { _ in
            if  self.imgProfileImg.image != nil {
                self.lblUploadCamera.isHidden = true
                self.imgCamera.isHidden = true
            }
            else {
                self.lblUploadCamera.isHidden = false
                self.imgCamera.isHidden = false
            }
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
    
    //MARK:- Local Methods -
    
    func validation(){
        
       let signUpType = objAppShareData.userDetail.strsignup_type
        self.txtLastName.text = self.txtLastName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        self.txtFullName.text = self.txtFullName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        self.txtMobileNumber.text = self.txtMobileNumber.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
      
    
        if signUpType == "1"{
            
            if txtLastName.text?.isEmpty == true {
                objAppShareData.showAlert(title: kAlertTitle, message: BlankLastName, view: self)
            }else{
                if txtMobileNumber.text == "" {
                    strDialCode = ""
                    strCountryCode = ""
                    callWebForUpdateProfile()
                }else {
                    if  (self.txtMobileNumber.text!.count ) > 5{
                      callWebForUpdateProfile()

                    }else
                    {
                        objAppShareData.showAlert(title: kAlertTitle, message: InvalidPhonenumber, view: self)
          
                    }
                }
                
            }
        }else if txtMobileNumber.text == "" {
            strDialCode = ""
            strCountryCode = ""
            callWebForUpdateProfile()
        }else {
            if  (self.txtMobileNumber.text!.count ) > 5{
              callWebForUpdateProfile()

            }else
            {
                objAppShareData.showAlert(title: kAlertTitle, message: InvalidPhonenumber, view: self)
  
            }
        }
    }
}

//MARK: Imagepicker - Functions -
extension EditProfile : UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
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
    
    
    // MARK: - UIImagePickerControllerDelegate Methods -
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        imgProfileImg.image = nil
        imgProfileImg.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        imgProfileImg.image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        imgProfileImg.image = imgProfileImg.image?.fixOrientation()
        isfromimgPicker = true
        SelectedProfileImage = imgProfileImg.image
        self.btnupdateProfileAgain.isHidden = false
        self.lblUploadCamera.isHidden = true
        self.btnUploadPicture.isHidden = true
        self.imgCamera.isHidden = true
        self.dismiss(animated: true, completion: nil)
        self.btnUpdateProfile.backgroundColor = #colorLiteral(red: 0.879128886, green: 0.1555605951, blue: 0.2124525889, alpha: 1)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        if  self.imgProfileImg.image != nil {
            self.lblUploadCamera.isHidden = true
            self.imgCamera.isHidden = true
        }
        else {
            self.lblUploadCamera.isHidden = false
            self.imgCamera.isHidden = false
            self.btnUploadPicture.isHidden = false
            
        }
        dismiss(animated: true, completion: nil)
    }
}


//MARK:- CountryPickerDelegate -
extension EditProfile :RSCountrySelectedDelegate{
    
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

//MARK:- UITextFieldDelegate -

extension EditProfile:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.txtFullName{
            self.txtLastName.becomeFirstResponder()
            
        }else if textField == self.txtLastName{
            self.txtMobileNumber.becomeFirstResponder()
            
        }else if textField == self.txtMobileNumber{
            self.txtMobileNumber.resignFirstResponder()
        }
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool
    {
        if textField == txtMobileNumber {
            let maxLength = 12
            let currentString: NSString = txtMobileNumber.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
            
        }
        return true
    }
}


//MARK:- Webservices calling -

extension EditProfile {
    
    func callWebForUpdateProfile(){
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAppShareData.showNetworkAlert(view:self)
            return
        }
        objWebServiceManager.showIndicator()
        self.view.endEditing(true)
        
        let param = [WsParam.user_firstName:self.txtFullName.text ?? "",
                     WsParam.user_lastName:self.txtLastName.text ?? "",
                     WsParam.phone_dialCode:self.strDialCode,
                     WsParam.country_code:self.strCountryCode,
                     WsParam.phone_number:self.txtMobileNumber.text ?? ""
            ] as [String : Any]
        
        let imageParam = [WsParam.profilepicture] as [String]
        var arrImageData = [Data]()

                if self.imgProfileImg.image ==  nil
                {
                    print("BlankImage")
                }
                else
                {
                    let img = self.resizeImage(image: imgProfileImg.image!, targetSize: CGSize(width: 200,height: 200))
                    print(img)

                    var imgData = Data()
                    imgData = (img.pngData())!
                    arrImageData.append(imgData)

                }

        objWebServiceManager.uploadMultipartMultipleImagesData(strURL: WsUrl.UpdateProfile, params: param, showIndicator: false, imageData: nil, imageToUpload: arrImageData, imagesParam: imageParam, fileName: nil, mimeType:  "image/*", success: { (response) in
            let status = (response["status"] as? String)
            let message = (response["message"] as? String)
            print(param)
            
            if status == k_success{
                objWebServiceManager.hideIndicator()
                if let data = response["data"]as? [String:Any]{
                    if let dictExcercise = data["user_details"] as? [String:Any]{
                        self.Mydata = MyProfileModel.init(dict: dictExcercise)
                        self.closerUpdate?(true)
                        
                        objAlert.showAlertCallBackOk(alertLeftBtn: "Ok", title: kAlertTitle, message: message ?? "", controller: self, callbackCancel: { () in
                            self.navigationController?.popViewController(animated: true)
                        })
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
