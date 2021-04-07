//
//  DocumentVc.swift
//  Go Delivery
//
//  Created by MACBOOK-SHUBHAM V on 23.11.20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit
import SJSegmentedScrollView


var isfromdocumnetImgViewController = false
class DocumentVc: UIViewController {
    
    @IBOutlet var Uiview: UIView!
    //MARK:- IBOutlet-
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var viewPassportShadow: UIView!
    @IBOutlet weak var viewNicShadow: UIView!
    @IBOutlet weak var viewDriverShadow: UIView!
    @IBOutlet weak var viewVehicleShadow: UIView!
    @IBOutlet weak var viewCertificateShadow: UIView!

    @IBOutlet weak var viewNoPasswordShadow: UIView!
    @IBOutlet weak var viewNoNicShadow: UIView!
    @IBOutlet weak var viewNoDriverShadow: UIView!
    @IBOutlet weak var viewNoVehicleShadow: UIView!
    @IBOutlet weak var viewNoCertificateShadow: UIView!

    @IBOutlet weak var viewVehicleInsuranceShadow: UIView!
    @IBOutlet weak var viewCharacterShadow: UIView!
    
    @IBOutlet weak var viewNoPassportUploded: UIView!
    @IBOutlet weak var viewPassportAvailable: UIView!
    
    @IBOutlet weak var viewNoNicUploded: UIView!
    @IBOutlet weak var viewNicAvailable: UIView!
    
    @IBOutlet weak var viewNoDriverLUploded: UIView!
    @IBOutlet weak var viewDricerLAvailable: UIView!
    
    @IBOutlet weak var viewNoVehicleLUploded: UIView!
    @IBOutlet weak var viewVehicleLAvailable: UIView!
   
    @IBOutlet weak var viewNoCharacterUploaded: UIView!
    @IBOutlet weak var viewCharacterUploaded: UIView!
    
    @IBOutlet weak var imgPassport: UIImageView!
    @IBOutlet weak var imgNic: UIImageView!
    @IBOutlet weak var imgDriverLicence: UIImageView!
    @IBOutlet weak var imgvehicleInsurance: UIImageView!
    @IBOutlet weak var imgCharacterCertificate: UIImageView!

    @IBOutlet weak var btnUploadPassport: UIButton!
    @IBOutlet weak var btnUploadNic: UIButton!
    @IBOutlet weak var btnUploadDriverLicence: UIButton!
    @IBOutlet weak var btnUploadVehicleInsurance: UIButton!
    @IBOutlet weak var btnUploadCharacterCertificate: UIButton!
    
    
    //MARK:- Local Variablse-

    var objDocprofileDetails = MyProfileModel(dict: [:])
    let imagePicker = UIImagePickerController()
    var uploadDocs = ""
    var strType = ""
    var selectedDocs = UIImageView()
    var isfromImagePicker = false
   
    //MARK:- View Life Cycle -

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        imagePicker.delegate = self
        isfromAllTab = false
        self.initailUISetup()
      
        self.viewNoPassportUploded.isHidden = false
        self.viewNoNicUploded.isHidden = false
        self.viewNoDriverLUploded.isHidden = false
        self.viewNoVehicleLUploded.isHidden = false
        self.viewNoCharacterUploaded.isHidden = false
        
        self.viewPassportAvailable.isHidden = true
        self.viewNicAvailable.isHidden = true
        self.viewDricerLAvailable.isHidden = true
        self.viewVehicleLAvailable.isHidden = true
        self.viewCharacterUploaded.isHidden = true
  
        self.checkDocumentIsavailbleorNOt()

    }
    
    //MARK:- UIButton Action -

    @IBAction func btnUploadPassport(_ sender: Any) {
    self.isfromImagePicker = true

         uploadDocs = "1"
         self.setImage()
    }
    
    @IBAction func btnUploadNic(_ sender: Any) {
       self.isfromImagePicker = true

              uploadDocs = "2"
              self.setImage()
       }
    
    @IBAction func btnUploadDriverLicence(_ sender: Any) {
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
    
    //MARK:- Local Methods  -

    func initailUISetup(){
        self.viewPassportShadow.setShadowAllView10()
        self.viewNicShadow.setShadowAllView10()
        self.viewDriverShadow.setShadowAllView10()
        self.viewVehicleShadow.setShadowAllView10()
        self.viewCertificateShadow.setShadowAllView10()
        
        self.viewNoPasswordShadow.setShadowAllView5()
        self.viewNoNicShadow.setShadowAllView5()
        self.viewNoDriverShadow.setShadowAllView5()
        self.viewNoVehicleShadow.setShadowAllView5()
        self.viewNoCertificateShadow.setShadowAllView5()
        
        self.imgPassport.setImgeRadius()
        self.imgDriverLicence.setImgeRadius()
        self.imgNic.setImgeRadius()
        self.imgvehicleInsurance.setImgeRadius()
        self.imgCharacterCertificate.setImgeRadius()
        
    }
 
    func checkDocumentIsavailbleorNOt(){
           
        if objAppShareData.strDeliveryPersonUserdetails.strcharacter_certificate_file == ""{
            self.viewNoCharacterUploaded.isHidden = false
            self.viewCharacterUploaded.isHidden = true

        }else{
            self.viewNoCharacterUploaded.isHidden = true
            self.viewCharacterUploaded.isHidden = false
            let img = objAppShareData.strDeliveryPersonUserdetails.strcharacter_certificate_file
            let urlImg = URL(string: img)
            self.imgCharacterCertificate.sd_setImage(with: urlImg, placeholderImage:UIImage(named: "document_placeholder_img"))
        }
        
        if objAppShareData.strDeliveryPersonUserdetails.strnational_insurance_file == ""{
            self.viewNoNicUploded.isHidden = false
            self.viewNicAvailable.isHidden = true

        }else{
            self.viewNoNicUploded.isHidden = true
            self.viewNicAvailable.isHidden = false
            let img = objAppShareData.strDeliveryPersonUserdetails.strnational_insurance_file
            let urlImg = URL(string: img)
            self.imgNic.sd_setImage(with: urlImg, placeholderImage:UIImage(named: "document_placeholder_img"))
        }
        
        if objAppShareData.strDeliveryPersonUserdetails.strpassport_file == ""{
            self.viewNoPassportUploded.isHidden = false
            self.viewPassportAvailable.isHidden = true
            
        }else{
            self.viewNoPassportUploded.isHidden = true
            self.viewPassportAvailable.isHidden = false
            let img = objAppShareData.strDeliveryPersonUserdetails.strpassport_file
            let urlImg = URL(string: img)
            self.imgPassport.sd_setImage(with: urlImg, placeholderImage:UIImage(named: "document_placeholder_img"))
        }
        
        if objAppShareData.strDeliveryPersonUserdetails.strvehicle_insurance_file == ""{
            self.viewNoVehicleLUploded.isHidden = false
            self.viewVehicleLAvailable.isHidden = true
            
        }else{
            self.viewNoVehicleLUploded.isHidden = true
            self.viewVehicleLAvailable.isHidden = false
            let img = objAppShareData.strDeliveryPersonUserdetails.strvehicle_insurance_file
            let urlImg = URL(string: img)
            self.imgvehicleInsurance.sd_setImage(with: urlImg, placeholderImage:UIImage(named: "document_placeholder_img"))
        }
        
        if objAppShareData.strDeliveryPersonUserdetails.strdriver_license_file == ""{
            self.viewNoDriverLUploded.isHidden = false
            self.viewDricerLAvailable.isHidden = true
            
        }else{
            self.viewNoDriverLUploded.isHidden = true
            self.viewDricerLAvailable.isHidden = false
            let img = objAppShareData.strDeliveryPersonUserdetails.strdriver_license_file
            let urlImg = URL(string: img)
            self.imgDriverLicence.sd_setImage(with: urlImg, placeholderImage:UIImage(named: "document_placeholder_img"))
        }
        
        
    }
      func setImage(){
             isfromdocumnetImgViewController = true

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
                    
                    if self.imgPassport.image != nil{
                        self.viewNoPassportUploded.isHidden = true
                        self.viewPassportAvailable.isHidden = false
                        
                    }else{
                      self.viewNoPassportUploded.isHidden = false
                      self.viewPassportAvailable.isHidden = true
                    }
                    
                }else if self.uploadDocs == "2"{
                    self.strType = "national_insurance"
                    
                    
                    if self.imgNic.image !=  nil{
                      self.viewNoNicUploded.isHidden = true
                     self.viewNicAvailable.isHidden = false
                    }else{
                        
                       self.viewNoNicUploded.isHidden = false
                        self.viewNicAvailable.isHidden = true

                    }
                    
                }else if self.uploadDocs == "3"{
                    
                    self.strType = "driver_license"
                    if self.imgDriverLicence.image !=  nil{
                        self.viewNoDriverLUploded.isHidden = true
                        self.viewDricerLAvailable.isHidden = false
                        
                    }else{
                       self.viewNoDriverLUploded.isHidden = false
                       self.viewDricerLAvailable.isHidden = true

                    }
                    
                }else if self.uploadDocs == "4"{
                    self.strType = "vehicle_insurance"
                  
                    if self.imgvehicleInsurance.image !=  nil{
                        self.viewNoVehicleLUploded.isHidden = true
                        self.viewVehicleLAvailable.isHidden = false
                    }else{
                        self.viewNoVehicleLUploded.isHidden = false
                        self.viewVehicleLAvailable.isHidden = true

                    }
                    
                }else if self.uploadDocs == "5"{
                    self.strType = "character_certificate"
                    if self.imgCharacterCertificate.image !=  nil{
                          self.viewNoCharacterUploaded.isHidden = true
                          self.viewCharacterUploaded.isHidden = false
                        
                    }else{
                     self.viewNoCharacterUploaded.isHidden = false
                     self.viewCharacterUploaded.isHidden = true

                    }
                }
                
            }))
            
                    switch UIDevice.current.userInterfaceIdiom {
                    case .pad:
                        alert.popoverPresentationController?.permittedArrowDirections = .up
                    default:
                        break
                    }
            
            self.present(alert, animated: true, completion: nil)
            
        }
}


//MARK:- Webservice calling  -

extension DocumentVc {
       
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
                   
                   print(type)
                   if type == "passport"{
                    self.imgPassport.image = nil
                    self.viewNoPassportUploded.isHidden = false
                    self.viewPassportAvailable.isHidden = true
                   }else if type == "national_insurance"{
                       self.imgNic.image = nil
                       self.viewNoNicUploded.isHidden = false
                       self.viewNicAvailable.isHidden = true
                       
                   }else if type == "driver_license"{
                       self.imgDriverLicence.image = nil
                       self.viewNoDriverLUploded.isHidden = false
                       self.viewDricerLAvailable.isHidden = true

                       
                   }else if type == "vehicle_insurance"{
                       self.imgvehicleInsurance.image = nil
                       self.viewNoVehicleLUploded.isHidden = false
                       self.viewVehicleLAvailable.isHidden = true

                   }else if type == "character_certificate"{
                       self.imgCharacterCertificate.image = nil
                       self.viewNoCharacterUploaded.isHidden = false
                       self.viewCharacterUploaded.isHidden = true
                   }
                   self.callGetForMyProfile1()

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
//MARK:- Imagepicker - Functions -
extension DocumentVc : UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
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
    
    
    // MARK: - UIImagePickerControllerDelegate Methods
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        

        selectedDocs.image = nil
        selectedDocs.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        selectedDocs.image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        selectedDocs.image = selectedDocs.image?.fixOrientation()
        // isfromimgPicker = true
        // SelectedProfileImage = imgProfileImg.image
        if self.uploadDocs == ""{
            
        }else if self.uploadDocs == "1"{
            
            self.strType = "passport"
            self.imgPassport.image = selectedDocs.image
            self.callWebForUploadDocs()

           
        }else if self.uploadDocs == "2"{
            
            self.strType = "national_insurance"
            self.imgNic.image = selectedDocs.image
            self.callWebForUploadDocs()

            if self.imgNic.image != nil {
                 self.viewNoNicUploded.isHidden = true
                 self.viewNicAvailable.isHidden = false
            }else{
                 self.viewNoNicUploded.isHidden = false
                self.viewNicAvailable.isHidden = true

            }
     
        }else if self.uploadDocs == "3"{
            self.strType = "driver_license"
            self.imgDriverLicence.image = selectedDocs.image
            self.callWebForUploadDocs()

            if  self.imgDriverLicence.image != nil {
                  self.viewNoDriverLUploded.isHidden = true
                  self.viewDricerLAvailable.isHidden = false
            }
            else {
                 self.viewNoDriverLUploded.isHidden = false
                 self.viewDricerLAvailable.isHidden = true

            }
            
        }else if self.uploadDocs == "4"{
            self.strType = "vehicle_insurance"
            
            self.imgvehicleInsurance.image = selectedDocs.image
            self.callWebForUploadDocs()

            if  self.imgvehicleInsurance.image != nil {
                self.viewNoVehicleLUploded.isHidden = true
                self.viewVehicleLAvailable.isHidden = false
            }
            else {
             self.viewNoVehicleLUploded.isHidden = true
             self.viewVehicleLAvailable.isHidden = false

            }
            
        }else if self.uploadDocs == "5"{
            self.strType = "character_certificate"
            self.imgCharacterCertificate.image = selectedDocs.image
            self.callWebForUploadDocs()

            if  self.imgCharacterCertificate.image != nil {
                
                self.viewNoCharacterUploaded.isHidden = true
                self.viewCharacterUploaded.isHidden = false
            }
            else {
              self.viewNoCharacterUploaded.isHidden = true
            self.viewCharacterUploaded.isHidden = false

            }
        }else{
            
            
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
       self.checkDocumentIsavailbleorNOt()
        dismiss(animated: true, completion: nil)
    }
}


extension DocumentVc {
    
    func callWebForUploadDocs(){
        
        isfromAllTab = false // for stop myprofile  calling api in profile base 

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
        
        let param = [WsParam.type:self.strType
            ] as [String : Any]
        
        let imageParam = [WsParam.file] as [String]
        var arrImageData = [Data]()
       
        
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
                objWebServiceManager.hideIndicator()
                if let data = response["data"]as? [String:Any]{
                    if (data["biz_document"] as? [String:Any]) != nil{
                     
                        self.callGetForMyProfile1()
                        
                    }
                }
                
            }else{
                objWebServiceManager.hideIndicator()
                objAppShareData.showAlert(title: kAlertTitle, message: message , view: self)
            }
        }, failure: { (error) in
            // print(error)
            objWebServiceManager.hideIndicator()
            objAppShareData.showAlert(title: kAlertTitle, message: kErrorMessage, view: self)
        })
    }
    
       func callGetForMyProfile1(){
            if !objWebServiceManager.isNetworkAvailable(){
                objWebServiceManager.hideIndicator()
                objAppShareData.showNetworkAlert(view:self)
                return
            }
    
            objWebServiceManager.requestGet(strURL: WsUrl.myprofile , params:[:], queryParams: [:], strCustomValidation: "", success: { (response) in
                print(response)
                let status = response["status"] as? String ?? ""
                let message = response["message"] as? String ?? ""
                
                if status == "success"{
                    if let data = response["data"] as? [String:Any]{
                    
                        if let dictExcercise = data["profile_details"] as? [String:Any]{
                            let objExcercise = MyProfileModel.init(dict: dictExcercise)
                            objAppShareData.strDeliveryPersonUserdetails = objExcercise
                            
                            objAppShareData.strDpFirstName = objExcercise.strUserFirstName
                            objAppShareData.strDpMiddleName = objExcercise.strUserMiddleName
                            objAppShareData.strDpLastName = objExcercise.strUserlastName
                            objAppShareData.strDpRating = objExcercise.strrating
                            objAppShareData.strDpprofile = objExcercise.strProfile_picture
                            UserDefaults.standard.set(objExcercise.stris_available, forKey: "DeliveryPersonisAvailable") //Bool
                            print(objExcercise.stris_available)
                            self.checkDocumentIsavailbleorNOt()
                            
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


extension DocumentVc: SJSegmentedViewControllerViewSource {
func viewForSegmentControllerToObserveContentOffsetChange() -> UIView {
  return scrollview
  }
}
