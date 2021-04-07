//
//  SignUpContractVc.swift
//  Go Delivery
//
//  Created by MACBOOK-SHUBHAM V on 05.11.20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit
import MobileCoreServices
var isfromContractApprovedcheck = false

class SignUpContractVc: UIViewController,UIDocumentMenuDelegate,UIDocumentPickerDelegate,UINavigationControllerDelegate {

    
    //MARK:- IBOutlet-
    @IBOutlet weak var viewDownloadContract: customView!
    @IBOutlet weak var viewRedForradius: UIView!
    @IBOutlet weak var viewuploadContract: customView!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var imgUploadContracForm: UIImageView!
    @IBOutlet weak var imgUploadPlacholder: UIImageView!
    
    //MARK:- local Variables-

    var pdfUrl : URL?
    var mimetype = ""
    let imagePicker = UIImagePickerController()

    var selectedImage : UIImage!

    //MARK:- View Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewDownloadContract.setShadowAllView10()
        self.viewuploadContract.setShadowAllView10()
        viewRedForradius.layer.masksToBounds = false
        viewRedForradius.layer.cornerRadius = 10
        viewRedForradius.layer.maskedCorners = [ .layerMinXMinYCorner,.layerMinXMaxYCorner]
        self.btnContinue.btnRadNonCol22()
               self.btnContinue.setbtnshadow()
        self.imgUploadContracForm.setImgRadiTopBottomLeft()
        
        if self.imgUploadContracForm.image == nil {
            self.imgUploadPlacholder.isHidden = false
        }else{
            self.imgUploadPlacholder.isHidden = true
        }
    }
    
    //MARK:- Buttons -

    @IBAction func btnback(_ sender: Any) {
        for controller in self.navigationController!.viewControllers as Array {
                   if controller.isKind(of: MainInitial_VC.self) {
                   _ = self.navigationController!.popToViewController(controller, animated: true)
                   break
                   }
            }
    }
    
    @IBAction func btnSubmit(_ sender: Any) {
        callWSForSkipOnboarding()
    }
    
    
    @IBAction func btnskip(_ sender: Any) {
        callWSForSkipOnboarding()
    }
    
    @IBAction func btnDownloadContract(_ sender: Any) {
     guard let url = URL(string: "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf") else { return }
        
        let urlSession = URLSession(configuration: .default, delegate: self as URLSessionDelegate, delegateQueue: OperationQueue())
        
        let downloadTask = urlSession.downloadTask(with: url)
        downloadTask.resume()
        
    }
    
    @IBAction func btnUploadContract(_ sender: Any) {
        
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
               alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
                   self.openCamera1()
               }))
               alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
                   self.openGallary()
               }))
               alert.addAction(UIAlertAction(title: "Document", style: .default, handler: { _ in
                         self.openiCloudDocuments()
                     }))
              
               alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: { _ in
                if self.imgUploadContracForm.image == nil {
                    
                    self.imgUploadPlacholder.isHidden = false

                }else{
                    
                    self.imgUploadPlacholder.isHidden = true

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
}

//MARK:- Webservices -

extension SignUpContractVc{

    func callWSForSkipOnboarding(){
           if !objWebServiceManager.isNetworkAvailable(){
               objWebServiceManager.hideIndicator()
               objAppShareData.showNetworkAlert(view:self)
               return
           }
           objWebServiceManager.showIndicator()
       
           
           objWebServiceManager.requestPatch(strURL: WsUrl.SkipOnboarding+String("3"), params: [:], queryParams: [:], strCustomValidation: "", success: { (response) in
               print(response)
               objWebServiceManager.hideIndicator()
               
               let status = response["status"] as? String
               
               let message = response["message"] as? String ?? ""
               if status == "success"{
                   let data = response["data"] as? [String:Any] ?? [:]
                   
                   let isonboardingCompleted = data["onboarding_details"] as? Int ?? 0000
                   let onboarding_step = data["onboarding_step"] as? Int ?? 000
                   
                   print(isonboardingCompleted)
                   print(onboarding_step)
                
                   let objVc = UIStoryboard.init(name: "Main", bundle: nil) .instantiateViewController(withIdentifier: "AddVehicleInfoVc")as! AddVehicleInfoVc
                   self.navigationController?.pushViewController(objVc, animated: true)
                 

                   objWebServiceManager.hideIndicator()
               }else{
                   objWebServiceManager.hideIndicator()
                   objAlert.showAlert(message: message, title: "Alert", controller: self)
               }
           }) { (error) in
               objWebServiceManager.hideIndicator()
               objAppShareData.showAlert(title: kAlertTitle, message: kErrorMessage, view: self)
        }
       }
}


extension SignUpContractVc {
        
    func callWebForUploadContractform(){
      if !objWebServiceManager.isNetworkAvailable(){
          objWebServiceManager.hideIndicator()
          objAppShareData.showNetworkAlert(view:self)
          return
      }
      objWebServiceManager.showIndicator()
      self.view.endEditing(true)
   
      
      let param = [WsParam.is_onboarding:"true",
    
          ] as [String : Any]
      
       let imageParam = [WsParam.file] as [String]
        var imageUploadData = [Data]()
        
        if self.selectedImage != nil {
            
                        print(param)
                      var imageDataCustomer : Data?
            imageDataCustomer = self.selectedImage.pngData()
                       imageUploadData = [imageDataCustomer] as! [Data]
                      print(imageUploadData)
                  mimetype = "image/*"
            
        }else if pdfUrl != nil {
            
                            print(pdfUrl as Any)
                            var imageDataCustomer : Data?
                            imageDataCustomer = NSData(contentsOf: pdfUrl!) as Data?
                            imageUploadData = [imageDataCustomer] as! [Data]
                            print(imageUploadData)
            mimetype =  "application/pdf"
        }
 
        objWebServiceManager.uploadMultipartDataPdf(strURL: WsUrl.uploadContract, strCustomValidation: mimetype, params: param, showIndicator: false, imageData: nil, imageToUpload: imageUploadData, imagesParam: imageParam, fileName: nil, mimeType: mimetype, success: { (response) in

          let status = (response["status"] as? String)
          let message = (response["message"] as? String)
          print(param)
          
          if status == k_success{
              objWebServiceManager.hideIndicator()
              if let data = response["data"]as? [String:Any]{
                
                let is_onboarding_completed = data["is_onboarding_completed"] as? String ?? ""

                print(is_onboarding_completed)
                
                objAppShareData.userDetail.strisOnboardingComplete = is_onboarding_completed

                  if let contract_document = data["contract_document"] as? [String:Any]{
                   
                    
                    objAlert.showAlert(message:message ?? "" , title:kAlertTitle, controller: self)

                  }
              }
          }else{
            
            self.imgUploadContracForm.image = nil
            self.pdfUrl = nil
            self.imgUploadPlacholder.isHidden = false
              objWebServiceManager.hideIndicator()
              objAppShareData.showAlert(title: kAlertTitle, message: message ?? "", view: self)
          }
      }, failure: { (error) in
          // print(error)
          objWebServiceManager.hideIndicator()
          objAppShareData.showAlert(title: kAlertTitle, message: kErrorMessage, view: self)
})
    }}


//MARK:- URLSessionDownloadDelegate -

extension SignUpContractVc:  URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("downloadLocation:", location)
                
        // create destination URL with the original pdf name
        guard let url = downloadTask.originalRequest?.url else { return }
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let destinationURL = documentsPath.appendingPathComponent(url.lastPathComponent)
        // delete original copy
        try? FileManager.default.removeItem(at: destinationURL)
        // copy from temp to Document
        do {
            try FileManager.default.copyItem(at: location, to: destinationURL)
            self.pdfUrl = destinationURL
            print(pdfUrl)
            DispatchQueue.main.async {
                objAlert.showAlert(message: "Download Successfully", title: kAlertTitle, controller: self)
            }
            
          } catch let error {
            print("Copy Error: \(error.localizedDescription)")
        }
    }
}

//MARK: Imagepicker - Functions -
extension SignUpContractVc : UIImagePickerControllerDelegate {
    
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
    
    
    // MARK: - UIImagePickerControllerDelegate Methods-
    
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//
//        imgUploadContracForm.image = nil
//        imgUploadContracForm.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
//        imgUploadContracForm.image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
//        imgUploadContracForm.image = imgUploadContracForm.image?.fixOrientation()
//        self.imgUploadContracForm.image = imgUploadContracForm.image
//        self.imgUploadPlacholder.isHidden = true
//        self.dismiss(animated: true, completion: nil)
//
//
//        if objAppShareData.userDetail.strisOnboardingComplete == "0"{
//
//            self.callWebForUploadContractform()
//
//        }else{
//            objAlert.showAlert(message: "Contract form already uploaded.", title: kAlertTitle, controller: self)
//            self.imgUploadContracForm.image = nil
//        }
//
//    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    if let editedImage = info[.editedImage] as? UIImage {
    self.selectedImage = editedImage
   // self.imgProfile.image = self.pickedImage
    imagePicker.dismiss(animated: true, completion: nil)
        //self.callWebForUploadContractform()

    } else if let originalImage = info[.originalImage] as? UIImage {
    self.selectedImage = originalImage
   // self.imgProfile.image = pickedImage

        imagePicker.dismiss(animated: true, completion: nil)
      //  self.callWebForUploadContractform()
    }
        
        if objAppShareData.userDetail.strisOnboardingComplete == "0"{
            
            self.callWebForUploadContractform()

        }else{
            objAlert.showAlert(message: "Contract form already uploaded.", title: kAlertTitle, controller: self)
            self.imgUploadContracForm.image = nil
        }

    }
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
       
        //        uploadImage(image: pickedImage)
        dismiss(animated: true, completion: nil)
    }
}

extension SignUpContractVc {
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
                   pdfUrl = url as URL
                  print("import result : \(pdfUrl)")
        self.imgUploadPlacholder.isHidden = false

        if objAppShareData.userDetail.strisOnboardingComplete == "0"{
                  
                  self.callWebForUploadContractform()

              }else{
                  objAlert.showAlert(message: "Contract form already uploaded.", title: kAlertTitle, controller: self)
              }
    
        }

    func documentMenu(_ documentMenu:UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
            documentPicker.delegate = self
            present(documentPicker, animated: true, completion: nil)
        }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
                print("view was cancelled")
                dismiss(animated: true, completion: nil)
        }
    
    func openiCloudDocuments(){
        let types: [String] = [kUTTypePDF as String]

        let importMenu = UIDocumentPickerViewController(documentTypes: types, in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        self.present(importMenu, animated: true, completion: nil)
    }
}
