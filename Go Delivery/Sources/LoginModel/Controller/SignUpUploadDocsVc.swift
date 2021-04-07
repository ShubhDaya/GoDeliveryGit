//
//  SignUpUploadDocsVc.swift
//  Go Delivery
//
//  Created by MACBOOK-SHUBHAM V on 05.11.20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit
import SDWebImage

class SignUpUploadDocsVc: UIViewController {
    
    //MARK:- IBOutlet-
    @IBOutlet weak var btnSkip: UIButton!
    @IBOutlet weak var imgPassword: UIImageView!
    @IBOutlet weak var imgUploadpasswordPlaceholder: UIImageView!
    @IBOutlet weak var imgDeletePass: UIImageView!
    @IBOutlet weak var btnDeletepassword: UIButton!
    @IBOutlet weak var btnUploadPassword: UIButton!
    
    @IBOutlet weak var imgNic: UIImageView!
    @IBOutlet weak var imgPlaceHnic: UIImageView!
    @IBOutlet weak var imgDeleteNic: UIImageView!
    @IBOutlet weak var btnDeleteNIc: UIButton!
    @IBOutlet weak var btnUplaodNIc: UIButton!
    
    @IBOutlet weak var imgDriverLicence: UIImageView!
    @IBOutlet weak var imgPlaceHolDriLicence: UIImageView!
    @IBOutlet weak var imgDeleteDrivLicence: UIImageView!
    @IBOutlet weak var btnDeleteDriceLicence: UIButton!
    @IBOutlet weak var btnUploadDriverLicence: UIButton!
    
    @IBOutlet weak var imgVehicleInsurance: UIImageView!
    @IBOutlet weak var imgPlaceHolDVehicleInsurance: UIImageView!
    @IBOutlet weak var imgDeleteVehicleInsurance: UIImageView!
    @IBOutlet weak var btnDeleteVehicleInsurance: UIButton!
    @IBOutlet weak var btnUploadVehicleInsurance: UIButton!
    
    @IBOutlet weak var imgCharacterC: UIImageView!
    @IBOutlet weak var imgPlaceHolCharacter: UIImageView!
    @IBOutlet weak var imgDeleteCharacterC: UIImageView!
    @IBOutlet weak var btnDeleteCharacterC: UIButton!
    @IBOutlet weak var btnUploadCharactercertificte: UIButton!
    @IBOutlet weak var btnContinue: UIButton!
    
    @IBOutlet weak var viewPassportShadow: customView!
    @IBOutlet weak var viewNICShadow: customView!
    @IBOutlet weak var viewDriveShadow: customView!
    @IBOutlet weak var viewVehicleInsShadow: customView!
    @IBOutlet weak var viewCharacterShadow: customView!
    
    //MARK:- local variables-

    var uploadDocs = ""
    var strType = ""
    var selectedDocs = UIImageView()
    let imagePicker = UIImagePickerController()
    var isfromImagePicker = false
    var isImagePicked = false // for double api calling loader manage .
    
    //MARK:- View Life cycle-

    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.initialUiSetup()
        if self.isfromImagePicker == true{
                   self.isfromImagePicker = false
               }else{
                   self.callGetForMyProfile()
        }
    }
    
    //MARK:- Buttons-

    @IBAction func btnSkip(_ sender: Any) {

        self.callWSForSkipOnboarding()
    }
    
    @IBAction func btnBack(_ sender: Any) {
        
        for controller in self.navigationController!.viewControllers as Array {
                   if controller.isKind(of: MainInitial_VC.self) {
                   _ = self.navigationController!.popToViewController(controller, animated: true)
                   break
                   }
                 }
    }
 
    @IBAction func btnUploadPassword(_ sender: Any) {
        self.isfromImagePicker = true

        uploadDocs = "1"
        self.setImage()
    }
    
    @IBAction func btnUploadNIC(_ sender: Any) {
        self.isfromImagePicker = true

        uploadDocs = "2"
        self.setImage()
    }
    
    @IBAction func btnUploadDriveLicence(_ sender: Any) {
        self.isfromImagePicker = true

        uploadDocs = "3"
        self.setImage()
        
    }
    
    @IBAction func btnUploadVehicleInsurance(_ sender: Any) {
        self.isfromImagePicker = true

        uploadDocs = "4"
        self.setImage()
        
    }
    
    @IBAction func btnUploadCharacterCertificate(_ sender: Any) {
        self.isfromImagePicker = true

        uploadDocs = "5"
        self.setImage()
        
    }
    
    @IBAction func btnDeletePasseword(_ sender: Any) {
        
        objAlert.showAlertCallBackother(alertLeftBtn: "No", alertRightBtn: "Yes", title: kAlertTitle, message: "Do you want to delete passport?", controller: self, callback: {_ in
            self.callWSForDeleteDoc(type: "passport")

        }, callbackCancel: { () in
            
        })
    }
    
    @IBAction func btnDeleteNIC(_ sender: Any) {
        
               objAlert.showAlertCallBackother(alertLeftBtn: "No", alertRightBtn: "Yes", title: kAlertTitle, message: "Do you want to delete national insurance?", controller: self, callback: {_ in
                self.callWSForDeleteDoc(type: "national_insurance")
               }, callbackCancel: { () in
        })
    }
    
    @IBAction func btnDeleteDriverLicence(_ sender: Any) {
        
        objAlert.showAlertCallBackother(alertLeftBtn: "No", alertRightBtn: "Yes", title: kAlertTitle, message: "Do you want to delete driver license?", controller: self, callback: {_ in
            self.callWSForDeleteDoc(type: "driver_license")

                     }, callbackCancel: { () in
                
                     })
    }
    
    @IBAction func btnDeleteVehicleInsurance(_ sender: Any) {
        objAlert.showAlertCallBackother(alertLeftBtn: "No", alertRightBtn: "Yes", title: kAlertTitle, message: "Do you want to delete vehicle insurance?", controller: self, callback: {_ in
            self.callWSForDeleteDoc(type: "vehicle_insurance")

                            }, callbackCancel: { () in
                                
                            })
        
        
    }
    @IBAction func btnDeleteCharacterC(_ sender: Any) {
        objAlert.showAlertCallBackother(alertLeftBtn: "No", alertRightBtn: "Yes", title: kAlertTitle, message: "Do you want to delete character certificate?", controller: self, callback: {_ in
            self.callWSForDeleteDoc(type: "character_certificate")

                        }, callbackCancel: { () in
                        })
    }
    
    @IBAction func btnContinue(_ sender: Any) {
        
        self.callWSForSkipOnboarding()
    }
    
    
    
    //MARK:- Local Methods-
    
    func initialUiSetup(){
        self.viewNICShadow.setShadowAllView10()
        self.viewPassportShadow.setShadowAllView10()
        self.viewDriveShadow.setShadowAllView10()
        self.viewVehicleInsShadow.setShadowAllView10()
        self.viewCharacterShadow.setShadowAllView10()
        self.btnContinue.btnRadNonCol22()
        self.btnContinue.setbtnshadow()
             
        self.imgPassword.setImgRadiTopBottomLeft()
        self.imgNic.setImgRadiTopBottomLeft()
        self.imgDriverLicence.setImgRadiTopBottomLeft()
        self.imgVehicleInsurance.setImgRadiTopBottomLeft()
        self.imgCharacterC.setImgRadiTopBottomLeft()
        
    }

    func setImage(){
        
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera1()
        }))
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: { _ in
            
            if self.uploadDocs == ""{
                
            }else if self.uploadDocs == "1"{
                
                self.strType = "passport"
                
                if self.imgPassword.image != nil{
                    
                    self.imgUploadpasswordPlaceholder.isHidden = true
                    self.imgDeletePass.isHidden = false
                    self.btnDeletepassword.isHidden = false
                    self.imgDeletePass.isHidden = false
                    
                }else{
                    self.imgUploadpasswordPlaceholder.isHidden = false
                    self.imgDeletePass.isHidden = true
                    self.btnDeletepassword.isHidden = true
                }
                
            }else if self.uploadDocs == "2"{
                self.strType = "national_insurance"
                
                if self.imgNic.image !=  nil{
                    self.imgPlaceHnic.isHidden = true
                    self.imgDeleteNic.isHidden = false
                    self.btnDeleteNIc.isHidden = false
                }else{
                    
                    self.imgPlaceHnic.isHidden = false
                    self.imgDeleteNic.isHidden = true
                    self.btnDeleteNIc.isHidden = true

                }
                
            }else if self.uploadDocs == "3"{
                
                self.strType = "driver_license"
                if self.imgDriverLicence.image !=  nil{
                    self.imgPlaceHolDriLicence.isHidden = true
                    self.imgDeleteDrivLicence.isHidden = false
                    self.btnDeleteDriceLicence.isHidden = false
                }else{
                    self.imgPlaceHolDriLicence.isHidden = false
                    self.imgDeleteDrivLicence.isHidden = true
                    self.btnDeleteDriceLicence.isHidden = true
                }
                
            }else if self.uploadDocs == "4"{
                self.strType = "vehicle_insurance"
                if self.imgVehicleInsurance.image !=  nil{
                    self.imgPlaceHolDVehicleInsurance.isHidden = true
                    self.imgDeleteVehicleInsurance.isHidden = false
                    self.btnDeleteVehicleInsurance.isHidden = false
                }else{
                    self.imgPlaceHolDVehicleInsurance.isHidden = false
                    self.imgDeleteVehicleInsurance.isHidden = true
                    self.btnDeleteVehicleInsurance.isHidden = true
                }
                
            }else if self.uploadDocs == "5"{
                self.strType = "character_certificate"
                if self.imgCharacterC.image !=  nil{
                    self.imgPlaceHolCharacter.isHidden = true
                    self.imgDeleteCharacterC.isHidden = false
                    self.btnDeleteCharacterC.isHidden = false
                }else{
                    self.imgPlaceHolCharacter.isHidden = false
                    self.imgDeleteCharacterC.isHidden = true
                    self.btnDeleteCharacterC.isHidden = true
                }
            }
            
        }))
        
                switch UIDevice.current.userInterfaceIdiom {
                case .pad:
//                    alert.popoverPresentationController?.sourceView = sender as? UIView
//                    alert.popoverPresentationController?.sourceRect = (sender as AnyObject).bounds
                    alert.popoverPresentationController?.permittedArrowDirections = .up
                default:
                    break
                }
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func checkDocsUploaded (){

        if self.imgPassword.image != nil{
            self.imgUploadpasswordPlaceholder.isHidden = true
            self.imgDeletePass.isHidden = false
            self.btnDeletepassword.isHidden = false
            self.imgDeletePass.isHidden = false
            
        }else{
            self.imgUploadpasswordPlaceholder.isHidden = false
            self.imgDeletePass.isHidden = true
            self.btnDeletepassword.isHidden = true
        }
        
        if self.imgNic.image != nil {
            self.imgPlaceHnic.isHidden = true
            self.imgDeleteNic.isHidden = false
            self.btnDeleteNIc.isHidden = false
        }else{
            self.imgPlaceHnic.isHidden = false
            self.imgDeleteNic.isHidden = true
            self.btnDeleteNIc.isHidden = true

        }
        
        if self.imgDriverLicence.image != nil {
            self.imgPlaceHolDriLicence.isHidden = true
            self.imgDeleteDrivLicence.isHidden = false
            self.btnDeleteDriceLicence.isHidden = false
            
        }else{
            self.imgPlaceHolDriLicence.isHidden = false
            self.imgDeleteDrivLicence.isHidden = true
            self.btnDeleteDriceLicence.isHidden = true
        }
        
        if self.imgVehicleInsurance.image != nil {
            self.imgPlaceHolDVehicleInsurance.isHidden = true
            self.imgDeleteVehicleInsurance.isHidden = false
            self.btnDeleteVehicleInsurance.isHidden = false
        }else{
            self.imgPlaceHolDVehicleInsurance.isHidden = false
            self.imgDeleteVehicleInsurance.isHidden = true
            self.btnDeleteVehicleInsurance.isHidden = true
        }
        
        if self.imgCharacterC.image != nil {
            self.imgPlaceHolCharacter.isHidden = true
            self.imgDeleteCharacterC.isHidden = false
            self.btnDeleteCharacterC.isHidden = false
        }else{
            self.imgPlaceHolCharacter.isHidden = false
            self.imgDeleteCharacterC.isHidden = true
            self.btnDeleteCharacterC.isHidden = true
        }
    }
    
}


//MARK:- Webservices Calling -

extension SignUpUploadDocsVc {
    
    func callWebForUploadDocs(){
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAppShareData.showNetworkAlert(view:self)
            return
        }
        objWebServiceManager.showIndicator()
        self.view.endEditing(true)
     
        let param = [WsParam.type:self.strType
            ] as [String : Any]
        
        let imageParam = [WsParam.file] as [String]
        print(param)
        var imageDataCustomer : Data?
        imageDataCustomer = self.selectedDocs.image?.pngData()
        let imageUploadData = [imageDataCustomer] as! [Data]
        print(imageUploadData)
        
        objWebServiceManager.uploadMultipartMultipleImagesData(strURL: WsUrl.UploadDocs, params: param, showIndicator: false, imageData: nil, imageToUpload: imageUploadData, imagesParam: imageParam, fileName: nil, mimeType:  "image/*", success: { (response) in
            let status = (response["status"] as? String)
            let message = response["message"] as? String ?? ""
            print(param)
            
            if status == "success"{
             //   objWebServiceManager.hideIndicator()
                if let data = response["data"]as? [String:Any]{
                    if let biz_document = data["biz_document"] as? [String:Any]{
                        // self.Mydata = MyProfileModel.init(dict: dictExcercise)
                        objAppShareData.showAlert(title: kAlertTitle, message: message , view: self)
                        self.callGetForMyProfile()
                    }
                }
            }else{
                objWebServiceManager.hideIndicator()
                objAppShareData.showAlert(title: kAlertTitle, message: message , view: self)
            }
        }, failure: { (error) in
           // objWebServiceManager.hideIndicator()
            objAppShareData.showAlert(title: kAlertTitle, message: kErrorMessage, view: self)
        })
    }
    
}

//MARK:- Imagepicker Delegate -
extension SignUpUploadDocsVc : UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
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
        
        selectedDocs.image = nil
        selectedDocs.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        selectedDocs.image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        selectedDocs.image = selectedDocs.image?.fixOrientation()
       //var isImagePicked = false // for double api calling loader manage .

        if self.uploadDocs == ""{
            
        }else if self.uploadDocs == "1"{
            isImagePicked = true
            self.strType = "passport"
            self.imgPassword.image = selectedDocs.image
            self.callWebForUploadDocs()

            if  self.imgPassword.image != nil {
                self.imgUploadpasswordPlaceholder.isHidden = true
                self.imgDeletePass.isHidden = false
                self.btnDeletepassword.isHidden = false
            }
            else {
                self.imgUploadpasswordPlaceholder.isHidden = false
                self.imgDeletePass.isHidden = true
                self.btnDeletepassword.isHidden = true

            }
        }else if self.uploadDocs == "2"{
            isImagePicked = true

            self.strType = "national_insurance"
            self.imgNic.image = selectedDocs.image
            self.callWebForUploadDocs()

            if self.imgNic.image != nil {
                self.imgPlaceHnic.isHidden = true
                self.imgDeleteNic.isHidden = false
                self.btnDeleteNIc.isHidden = false
            }else{
                self.imgPlaceHnic.isHidden = false
                self.imgDeleteNic.isHidden = true
                self.btnDeleteNIc.isHidden = true
            }

        }else if self.uploadDocs == "3"{
            isImagePicked = true

            self.strType = "driver_license"
            self.imgDriverLicence.image = selectedDocs.image
            self.callWebForUploadDocs()

            if  self.imgDriverLicence.image != nil {
                self.imgPlaceHolDriLicence.isHidden = true
                self.imgDeleteDrivLicence.isHidden = false
                self.btnDeleteDriceLicence.isHidden = false
            }
            else {
                self.imgPlaceHolDriLicence.isHidden = false
                self.imgDeleteDrivLicence.isHidden = true
                self.btnDeleteDriceLicence.isHidden = true
            }
            
        }else if self.uploadDocs == "4"{
            self.strType = "vehicle_insurance"
            isImagePicked = true

            
            self.imgVehicleInsurance.image = selectedDocs.image
            self.callWebForUploadDocs()

            if  self.imgVehicleInsurance.image != nil {
                self.imgPlaceHolDVehicleInsurance.isHidden = true
                self.imgDeleteVehicleInsurance.isHidden = false
                self.btnDeleteVehicleInsurance.isHidden = false
            }
            else {
                self.imgPlaceHolDVehicleInsurance.isHidden = false
                self.imgDeleteVehicleInsurance.isHidden = true
                self.btnDeleteVehicleInsurance.isHidden = true
            }
            
        }else if self.uploadDocs == "5"{
            isImagePicked = true

            self.strType = "character_certificate"
            self.imgCharacterC.image = selectedDocs.image
            self.callWebForUploadDocs()

            if  self.imgCharacterC.image != nil {
                
                self.imgPlaceHolCharacter.isHidden = true
                self.imgDeleteCharacterC.isHidden = false
                self.btnDeleteCharacterC.isHidden = false
            }
            else {
                self.imgPlaceHolCharacter.isHidden = false
                self.imgDeleteCharacterC.isHidden = true
                self.btnDeleteCharacterC.isHidden = true
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        self.checkDocsUploaded()
        dismiss(animated: true, completion: nil)
    }
}


//MARK:- Webservice Methods -

extension SignUpUploadDocsVc{
    
    func callWSForSkipOnboarding(){
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAppShareData.showNetworkAlert(view:self)
            return
        }
        objWebServiceManager.showIndicator()
        
        objWebServiceManager.requestPatch(strURL: WsUrl.SkipOnboarding+String("2"), params: [:], queryParams: [:], strCustomValidation: "", success: { (response) in
            print(response)
            objWebServiceManager.hideIndicator()
            
            let status = response["status"] as? String
            let message = response["message"] as? String ?? ""
            if status == "success"{
                let data = response["data"] as? [String:Any] ?? [:]
           
                let objVc = UIStoryboard.init(name: "Main", bundle: nil) .instantiateViewController(withIdentifier: "SignUpContractVc")as! SignUpContractVc
                self.navigationController?.pushViewController(objVc, animated: true)
                
                objWebServiceManager.hideIndicator()
            }else{
                objWebServiceManager.hideIndicator()
                objAlert.showAlert(message: message, title: "Alert", controller: self)
            }
        }) { (error) in
            objWebServiceManager.hideIndicator()
            objAppShareData.showAlert(title: kAlertTitle, message: kErrorMessage, view: self)          }
    }
    
    
    func callWSForDeleteDoc(type:String){
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAppShareData.showNetworkAlert(view:self)
            return
        }
        objWebServiceManager.showIndicator()

        
        objWebServiceManager.requestDelete(strURL: WsUrl.DeleteBizDoc+String(type), params: [:], queryParams: [:], strCustomValidation: "",  success: { (response) in
            print(response)
            objWebServiceManager.hideIndicator()

            
            let status = response["status"] as? String
            
            let message = response["message"] as? String ?? ""
            if status == "success"{
                _ = response["data"] as? [String:Any] ?? [:]
                
                
                print(type)
                if type == "passport"{
                    self.imgPassword.image = nil
                    self.imgUploadpasswordPlaceholder.isHidden = false
                    self.imgDeletePass.isHidden = true
                    self.btnDeletepassword.isHidden = true
                    
                    
                }else if type == "national_insurance"{
                    self.imgNic.image = nil
                    self.imgPlaceHnic.isHidden = false
                    self.imgDeleteNic.isHidden = true
                    self.btnDeleteNIc.isHidden = true
                    
                }else if type == "driver_license"{
                    self.imgDriverLicence.image = nil
                    self.imgPlaceHolDriLicence.isHidden = false
                    self.imgDeleteDrivLicence.isHidden = true
                    self.btnDeleteDriceLicence.isHidden = true
                    
                }else if type == "vehicle_insurance"{
                    self.imgVehicleInsurance.image = nil
                    self.imgPlaceHolDVehicleInsurance.isHidden = false
                    self.imgDeleteVehicleInsurance.isHidden = true
                    self.btnDeleteVehicleInsurance.isHidden = true

                }else if type == "character_certificate"{
                    self.imgCharacterC.image = nil

                    self.imgPlaceHolCharacter.isHidden = false
                    self.imgDeleteCharacterC.isHidden = true
                    self.btnDeleteCharacterC.isHidden = true
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
extension SignUpUploadDocsVc {
    
    func callGetForMyProfile(){
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAppShareData.showNetworkAlert(view:self)
            return
        }
        if isImagePicked ==  true{
           // objWebServiceManager.showIndicator()

        }else if isImagePicked ==  false{
            objWebServiceManager.showIndicator()
        }

        let   param = [
            WsParam.user_id: objAppShareData.userDetail.strUserID,
            ] as [String : Any]
        
        print(param)
        objWebServiceManager.requestGet(strURL: WsUrl.myprofile , params: param, queryParams: [:], strCustomValidation: "", success: { (response) in
            print(response)
            let status = response["status"] as? String ?? ""
            let message = response["message"] as? String ?? ""
      
            
            if status == "success"{
                if let data = response["data"] as? [String:Any]{
                    objWebServiceManager.hideIndicator()

                    if let dictExcercise = data["profile_details"] as? [String:Any]{
                        let objExcercise = MyProfileModel.init(dict: dictExcercise)
                      
                        print(objExcercise.strpassport_file)
                        print(objExcercise.strnational_insurance_file)
                        print(objExcercise.strvehicle_insurance_file)
                        print(objExcercise.strcharacter_certificate_file)
                        self.isImagePicked ==  false
                        if objExcercise.strpassport_file != ""{
                            let urlImg = URL(string: objExcercise.strpassport_file)
                            self.imgPassword.sd_setImage(with: urlImg, placeholderImage:nil)
                            print("strpassport_file")
                            self.imgUploadpasswordPlaceholder.isHidden = true
                            self.imgDeletePass.isHidden = false
                            self.btnDeletepassword.isHidden = false
                            
                        }else{
                            self.imgUploadpasswordPlaceholder.isHidden = false
                            self.imgDeletePass.isHidden = true
                            self.btnDeletepassword.isHidden = true
                        }
                        
                        if objExcercise.strdriver_license_file !=  ""{
                            let strimage = objExcercise.strdriver_license_file
                            let urlImg = URL(string: strimage)
                            self.imgDriverLicence.sd_setImage(with: urlImg, placeholderImage:nil)
                            
                            self.imgPlaceHolDriLicence.isHidden = true
                            self.imgDeleteDrivLicence.isHidden = false
                            self.btnDeleteDriceLicence.isHidden = false
                        }else{
                            self.imgPlaceHolDriLicence.isHidden = false
                            self.imgDeleteDrivLicence.isHidden = true
                            self.btnDeleteDriceLicence.isHidden = true
                        }
                        
                        if objExcercise.strnational_insurance_file !=  ""{
                            let strimage = objExcercise.strnational_insurance_file
                            let urlImg = URL(string: strimage)
                            self.imgNic.sd_setImage(with: urlImg, placeholderImage:nil)
                            print("national_insurance")
                            self.imgPlaceHnic.isHidden = true
                            self.imgDeleteNic.isHidden = false
                            self.btnDeleteNIc.isHidden = false
                        }else{
                            self.imgPlaceHnic.isHidden = false
                            self.imgDeleteNic.isHidden = true
                            self.btnDeleteNIc.isHidden = true
                        }
                        
                        if objExcercise.strvehicle_insurance_file !=  ""{
                            let strimage = objExcercise.strvehicle_insurance_file
                            let urlImg = URL(string: strimage)
                            self.imgVehicleInsurance.sd_setImage(with: urlImg, placeholderImage:nil)
                            print("insurance_file")
                            
                            self.imgPlaceHolDVehicleInsurance.isHidden = true
                            self.imgDeleteVehicleInsurance.isHidden = false
                            self.btnDeleteVehicleInsurance.isHidden = false

                        }else{
                            self.imgPlaceHolDVehicleInsurance.isHidden = false
                            self.imgDeleteVehicleInsurance.isHidden = true
                            self.btnDeleteVehicleInsurance.isHidden = true

                        }
                        
                        if objExcercise.strcharacter_certificate_file !=  ""{
                            let strimage = objExcercise.strcharacter_certificate_file
                            let urlImg = URL(string: strimage)
                            self.imgCharacterC.sd_setImage(with: urlImg, placeholderImage:nil)
                            print("strcharacter_certificate_file")
                            
                            self.imgPlaceHolCharacter.isHidden = true
                            self.imgDeleteCharacterC.isHidden = false
                            self.btnDeleteCharacterC.isHidden = false

                        }else{
                            self.imgPlaceHolCharacter.isHidden = false
                            self.imgDeleteCharacterC.isHidden = true
                            self.btnDeleteCharacterC.isHidden = true

                        }
                        
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
