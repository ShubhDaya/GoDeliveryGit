//
//  ContractVc.swift
//  Go Delivery
//
//  Created by MACBOOK-SHUBHAM V on 23.11.20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit
import SJSegmentedScrollView
import MobileCoreServices


class ContractVc: UIViewController,UIDocumentMenuDelegate,UIDocumentPickerDelegate,UINavigationControllerDelegate {
    
    
    //MARK: - Local Variablse-
    
    var objprofileDetails = MyProfileModel(dict: [:])
    let imagePicker = UIImagePickerController()
    var pdfUrl : URL?
    var mimetype = ""
    var selectedImage : UIImage!

    
    //MARK: - IBOutlet-

    @IBOutlet weak var viewIfNewContractUpload: customView!
    @IBOutlet weak var viewDownloadContract: customView!
    @IBOutlet weak var viewRedForradius: UIView!
    @IBOutlet weak var viewuploadContract: customView!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var
        imgUploadContracForm: UIImageView!
    @IBOutlet weak var imgUploadPlacholder: UIImageView!
    
    var iscontractUploaded = ""
    
    //MARK: - View Life Cycles-

    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        isfromAllTab = false
        self.InitialUISetup()
        self.tabBarController?.tabBar.isHidden = false
        
        if objAppShareData.strDeliveryPersonUserdetails.strsigned_contract_form_file == ""{
            self.iscontractUploaded = "0"
            print(self.iscontractUploaded)
        }else{
            print(self.iscontractUploaded)
            self.iscontractUploaded = "1"
        }
        if objAppShareData.strDeliveryPersonUserdetails.stris_contract_updated == "0"{
            self.viewIfNewContractUpload.isHidden = false
        }else{
            self.viewIfNewContractUpload.isHidden = true
        }
    }
    
    
    //MARK: - UIButton Action-

    @IBAction func btnSignedContractForm(_ sender: Any) {
        if iscontractUploaded == "1"{
            guard let url = URL(string: objAppShareData.strDeliveryPersonUserdetails.strsigned_contract_form_file) else { return }
            
            let urlSession = URLSession(configuration: .default, delegate: self as! URLSessionDelegate, delegateQueue: OperationQueue())
            let downloadTask = urlSession.downloadTask(with: url)
            downloadTask.resume()
            
            
        }else if iscontractUploaded == "0"{
            objAlert.showAlert(message: "You did not upload any contract form yet please upload it.", title: kAlertTitle, controller: self)
        }
    }
    
    
    @IBAction func btnDownloadContract(_ sender: Any) {
        guard let url = URL(string: "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf") else { return }
        
        let urlSession = URLSession(configuration: .default, delegate: self as! URLSessionDelegate, delegateQueue: OperationQueue())
        
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
    
    func InitialUISetup(){
        
        self.viewDownloadContract.setShadowAllViewlight10()
              self.viewuploadContract.setShadowAllViewlight10()
              viewRedForradius.layer.masksToBounds = false
              viewRedForradius.layer.cornerRadius = 10
              viewRedForradius.layer.maskedCorners = [ .layerMinXMinYCorner,.layerMinXMaxYCorner]
              self.imgUploadContracForm.setImgRadiTopBottomLeft()
    }
}

//MARK: - SJSegmentedViewControllerViewSource-

extension ContractVc: SJSegmentedViewControllerViewSource {
    func viewForSegmentControllerToObserveContentOffsetChange() -> UIView {
        return self.view
    }
}


//MARK: - Download File and save Methods-

extension ContractVc:  URLSessionDownloadDelegate {
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


//MARK: - Webservice Calling -

extension ContractVc {
    
    func callWebForUploadContractform(){
        isfromAllTab = false // for stop myprofile  calling api in profile base
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAppShareData.showNetworkAlert(view:self)
            return
        }
        objWebServiceManager.showIndicator()
        self.view.endEditing(true)
    
        let param = [WsParam.is_onboarding:"false",
                     
            ] as [String : Any]
        
        let imageParam = [WsParam.file] as [String]
        var imageUploadData = [Data]()
        
       
        
        if selectedImage != nil {
            
            print(param)
            var imageDataCustomer : Data?
            //imageDataCustomer = self.imgUploadContracForm.image?.pngData()
            imageDataCustomer = self.selectedImage?.pngData()

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
                        let contractform = contract_document["signed_contract_form_file"]as? String ?? ""
                        print(contractform)
                        self.iscontractUploaded = "1"
                        objAppShareData.strDeliveryPersonUserdetails.strsigned_contract_form_file = contractform
                        self.callGetForMyProfile1()
                    }
                }
            }else{
                objWebServiceManager.hideIndicator()
                self.imgUploadContracForm.image = nil
                self.pdfUrl = nil
                self.imgUploadPlacholder.isHidden = false
                objAppShareData.showAlert(title: kAlertTitle, message: message ?? "", view: self)
            }
        }, failure: { (error) in
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
                    objWebServiceManager.hideIndicator()

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
                        
                        objAppShareData.strNewContractFormUploaded = objExcercise.stris_contract_updated
                        if objAppShareData.strDeliveryPersonUserdetails.stris_contract_updated == "0"{
                            self.viewIfNewContractUpload.isHidden = false
                        }else{
                            self.viewIfNewContractUpload.isHidden = true
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

//MARK: - UIImagePickerControllerDelegate -

extension ContractVc : UIImagePickerControllerDelegate {
    
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
    
    
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//
//        imgUploadContracForm.image = nil
//        imgUploadContracForm.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
//        imgUploadContracForm.image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
////imgUploadContracForm.image = imgUploadContracForm.image?.fixOrientation()
////self.imgUploadContracForm.image = imgUploadContracForm.image
//
//        selectedImage = imgUploadContracForm.image
//        self.imgUploadPlacholder.isHidden = true
//
//        self.dismiss(animated: true, completion: nil)
//
//        self.callWebForUploadContractform()
//
//
//    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    if let editedImage = info[.editedImage] as? UIImage {
    self.selectedImage = editedImage
   // self.imgProfile.image = self.pickedImage
    imagePicker.dismiss(animated: true, completion: nil)
        self.callWebForUploadContractform()

    } else if let originalImage = info[.originalImage] as? UIImage {
    self.selectedImage = originalImage
   // self.imgProfile.image = pickedImage

        imagePicker.dismiss(animated: true, completion: nil)
        self.callWebForUploadContractform()
    }

    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
    }
}

//MARK: - UIDocumentPickerView Delegate -

extension ContractVc {
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        pdfUrl = url as URL
        print("import result : \(String(describing: pdfUrl))")
        self.imgUploadContracForm.image = nil
        self.imgUploadPlacholder.isHidden = false

        self.callWebForUploadContractform()
   
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
