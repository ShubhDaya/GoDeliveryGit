//
//  TrackOrderVC.swift
//  Go Delivery
//  Created by MACBOOK-SHUBHAM V on 19.11.20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit
import SDWebImage


class TrackOrderVC: UIViewController {
    
    //MARK: - IBOutlet-
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var imgBarCode: UIImageView!
    @IBOutlet weak var lblBarCodeDigit: UILabel!
    @IBOutlet weak var viewDownloadForshadow: UIView!
    @IBOutlet weak var viewPrintForShadow: UIView!
    
    @IBOutlet weak var viewDownloadImgCorner: UIView!
    @IBOutlet weak var viewPrintimgForCorner: UIView!
    
    @IBOutlet weak var viewDeliveryPickCompletebtn: UIView!
    @IBOutlet weak var viewInProgressCompleteBtn: UIView!
    @IBOutlet weak var viewDeliverdCompleteBtn: UIView!
    
    @IBOutlet weak var btnDeleveryPickCom: UIButton!
    @IBOutlet weak var bntDeliveryInComplete: UIButton!
    @IBOutlet weak var btnDeliverd: UIButton!
    
    @IBOutlet weak var imgOrderTracking: UIImageView!
    
    @IBOutlet weak var lblPickUpDate: UILabel!
    @IBOutlet weak var lblInProgressDate: UILabel!
    @IBOutlet weak var lblDeliverdDate: UILabel!
    
    //MARK: - Local Variables-

    var barcode_image = ""
    var DeliveryId = ""
    var DeliveryStatus = ""
    var image : UIImage?
    var imageurl : URL?
    var isfromChangButtonStatus = false
    var isfromPriterButton = false
    
    //MARK: - View Life Cycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewInProgressCompleteBtn.isHidden = true
        self.viewDeliverdCompleteBtn.isHidden = true
        self.lblInProgressDate.isHidden = true
        self.lblDeliverdDate.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(DeliveryId)
        self.initialUISetup()
        if isfromChangButtonStatus == false{
            self.callTrackOrder()
        }
    }
    
    //MARK: - UiButtons Action -

    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnDowload(_ sender: Any) {
        isfromPriterButton = false

        if self.barcode_image != "" && self.image != nil{
            self.writeImage(image: image!)
            guard let url = URL(string: barcode_image) else { return }
            let urlSession = URLSession(configuration: .default, delegate: self as! URLSessionDelegate, delegateQueue: OperationQueue())
            let downloadTask = urlSession.downloadTask(with: url)
            downloadTask.resume()
        }
    }
    
    @IBAction func btnPrint(_ sender: Any) {
        isfromPriterButton = true
        if self.barcode_image != "" && self.image != nil{
           self.writeImage(image: image!)
           guard let url = URL(string: barcode_image) else { return }
            let urlSession = URLSession(configuration: .default, delegate: self as? URLSessionDelegate, delegateQueue: OperationQueue())
           let downloadTask = urlSession.downloadTask(with: url)
           downloadTask.resume()
       }
    }
    
    @IBAction func btnDeliveryPickComplete(_ sender: Any) {
        isfromChangButtonStatus = true
        self.DeliveryStatus = "3"
        self.callChangeDeliveryStatus()
        
    }
    
    
    @IBAction func btnDeliveryInprogressComplete(_ sender: Any) {
        isfromChangButtonStatus = true

        self.DeliveryStatus = "4"
        self.callChangeDeliveryStatus()
    }
    
    @IBAction func btnDeliveryDeliverComplete(_ sender: Any) {
        isfromChangButtonStatus = true

        self.DeliveryStatus = "5"
        self.callChangeDeliveryStatus()
        
    }
    
    func PrinterFuncToPrint(){
        self.isfromPriterButton = false
        if UIPrintInteractionController.canPrint(imageurl!) {
                              let printInfo = UIPrintInfo(dictionary: nil)
                           printInfo.jobName = imageurl!.lastPathComponent
                           printInfo.outputType = .photo

                           let printController = UIPrintInteractionController.shared
                              printController.printInfo = printInfo
                              printController.showsNumberOfCopies = false
                              printController.printingItem = imageurl
                           printController.present(animated: true, completionHandler: nil)
                          }
    }
    
    func initialUISetup(){
        
        viewHeader.layer.shadowColor = UIColor.lightGray.cgColor
        viewHeader.layer.masksToBounds = false
        viewHeader.layer.shadowOffset = CGSize(width: 0.0 , height: 5.0)
        viewHeader.layer.shadowOpacity = 0.3
        viewHeader.layer.shadowRadius = 3
            
        self.viewDeliveryPickCompletebtn.setShadowAllView12()
        self.viewInProgressCompleteBtn.setShadowAllView12()
        self.viewDeliverdCompleteBtn.setShadowAllView12()
            
        self.viewDownloadForshadow.setShadowAllView35()
        self.viewPrintForShadow.setShadowAllView35()
        viewDownloadImgCorner.clipsToBounds = true
        viewDownloadImgCorner.layer.cornerRadius = 17.5
        viewDownloadImgCorner.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
              
        viewPrintimgForCorner.clipsToBounds = true
        viewPrintimgForCorner.layer.cornerRadius = 17.5
        viewPrintimgForCorner.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
    }
    
    func changeDateFormatter(date:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dt = dateFormatter.date(from: date) //{
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "d MMM, yyyy, hh:mm a"
        return dateFormatter.string(from: dt ?? Date())
    }
}


//MARK:- Webservice Calling -
extension TrackOrderVC{
    
    func callTrackOrder(){
        self.view.endEditing(true)
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAppShareData.showNetworkAlert(view:self)
            return
        }
        if  self.isfromChangButtonStatus == false{
            objWebServiceManager.showIndicator()

        }else{
            //objWebServiceManager.showIndicator()
        }

        
        objWebServiceManager.requestGet(strURL: WsUrl.TrackOrder+String(DeliveryId) , params: [:], queryParams: [:], strCustomValidation: "", success: { (response) in
            print(response)
            let status = response["status"] as? String ?? ""
            let message = response["message"] as? String ?? ""
            
            if status == "success"{
                if  self.isfromChangButtonStatus == true{
                             objWebServiceManager.hideIndicator()

                              }else{
                                  objWebServiceManager.hideIndicator()

                              }
                if  self.isfromChangButtonStatus == false{
                           objWebServiceManager.hideIndicator()

                       }else{
                    
                       }
                self.isfromChangButtonStatus = false
                if let dataS = response["data"] as? [String:Any]{
                    if let trackDetails = dataS["delivery_detail"] as? [String:Any]{
                        
                        self.barcode_image = trackDetails["barcode_image"]as? String ?? ""
                        let deliveryID = trackDetails["deliveryID"]as? String ?? ""
                        let order_id = trackDetails["order_id"]as? String ?? ""
                        let Status = trackDetails["status"]as? String ?? ""
                        
                        self.DeliveryStatus = Status
                        
                        
                        if let status_updated_at = trackDetails["status_updated_at"] as? [String:Any]{
                            let PickUpDate = status_updated_at["3"]as? String ?? ""
                            let InProgressDate = status_updated_at["4"]as? String ?? ""
                            
                            self.lblPickUpDate.text = self.changeDateFormatter(date: PickUpDate)
                            self.lblInProgressDate.text = self.changeDateFormatter(date: InProgressDate)
                            
                        }
    
                        DispatchQueue.main.async {
                                         let urlImg = URL(string: self.barcode_image)
                                                            self.imgBarCode.sd_setImage(with: urlImg, placeholderImage:nil)                                  }
                   
                        
                        let urlImg2 = URL(string: self.barcode_image)
                        let data = try? Data(contentsOf: urlImg2!)
                        
                        if let imageData = data {
                            self.image = UIImage(data: imageData)
                        }
                        
                        self.lblBarCodeDigit.text = order_id
                        
                        
                        if Status == "2"{
                            self.imgOrderTracking.image = #imageLiteral(resourceName: "step_img1")
                            self.lblPickUpDate.isHidden = true
                            
                            self.lblInProgressDate.isHidden = true
                            self.lblDeliverdDate.isHidden = true
                            
                            self.viewDeliveryPickCompletebtn.isHidden = false
                            self.viewInProgressCompleteBtn.isHidden = true
                            self.viewDeliverdCompleteBtn.isHidden = true
                            self.btnDeleveryPickCom.isHidden = false
                            
                            self.bntDeliveryInComplete.isHidden = true
                            self.btnDeliverd.isHidden = true
                            
                        }else  if Status == "3"{
                            //Pickup
                            self.imgOrderTracking.image = #imageLiteral(resourceName: "step_img2")
                            self.lblPickUpDate.isHidden = false
                            self.lblInProgressDate.isHidden = true
                            self.lblDeliverdDate.isHidden = true
                            
                            self.viewDeliveryPickCompletebtn.isHidden = true
                            self.viewInProgressCompleteBtn.isHidden = false
                            self.viewDeliverdCompleteBtn.isHidden = true
                            
                            self.btnDeleveryPickCom.isHidden = true
                            self.bntDeliveryInComplete.isHidden = false
                            self.btnDeliverd.isHidden = true
                            
                        }else if Status == "4"{
                            // InProgress
                            self.imgOrderTracking.image = #imageLiteral(resourceName: "step_img3")
                            self.lblPickUpDate.isHidden = false
                            self.lblInProgressDate.isHidden = false
                            self.lblDeliverdDate.isHidden = true
                            
                            self.viewDeliveryPickCompletebtn.isHidden = true
                            self.viewInProgressCompleteBtn.isHidden = true
                            self.viewDeliverdCompleteBtn.isHidden = false
                            
                            self.bntDeliveryInComplete.isHidden = true
                            self.btnDeleveryPickCom.isHidden = true
                            self.btnDeliverd.isHidden = false
                            
                        }else if Status == "5"{
                            objAlert.showAlertCallBackOk(alertLeftBtn: "Ok", title: kAlertTitle, message:"Order has been delivered successfully", controller: self, callbackCancel: { () in
                                self.navigationController?.popViewController(animated: true)
                            })
                        }
                    }
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
    
    func callChangeDeliveryStatus(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAppShareData.showNetworkAlert(view:self)
            return
        }
        if  self.isfromChangButtonStatus == true{
                        objWebServiceManager.showIndicator()

                    }
        self.view.endEditing(true)
        var strUdidi = ""
        if let MyUniqueId = UserDefaults.standard.string(forKey:UserDefaults.Keys.strVenderId) {
            print("defaults VenderID: \(MyUniqueId)")
            strUdidi = MyUniqueId
        }
        
        let param = [WsParam.delivery_id:self.DeliveryId,
                     WsParam.status:self.DeliveryStatus,
                     
            ] as [String : Any]
        
        print(param)
        
        objWebServiceManager.requestPost(strURL:WsUrl.deliveryAction, queryParams: [:], params: param, strCustomValidation: "", showIndicator: true, success: {response in
            
            let status = (response["status"] as? String)
            let message = (response["message"] as? String)
            print(response)
            
            if status == k_success{
                if  self.isfromChangButtonStatus == true{

                }else{
                    objWebServiceManager.hideIndicator()
                }
                
                if let data = response["data"]as? [String:Any]{
                    let status = data["status"] as? String ?? ""
                    print(status)
                    self.callTrackOrder()
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

//MARK:-URLSessionDownloadDelegate -

extension TrackOrderVC:  URLSessionDownloadDelegate {
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
            self.imageurl = destinationURL
            print(imageurl)
            if  isfromPriterButton == true{
                DispatchQueue.main.async {

                self.PrinterFuncToPrint()
                }
            }else{
                DispatchQueue.main.async {
                    objAlert.showAlert(message: "Download Successfully", title: kAlertTitle, controller: self)
                }
            }
        } catch let error {
            print("Copy Error: \(error.localizedDescription)")
        }
    }
}
extension TrackOrderVC {
    //MARK:- for save downloaded img url to Photos -
    func writeImage(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.finishWriteImage), nil)
    }
    
    @objc private func finishWriteImage(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if (error != nil) {
            // Something wrong happened.
            print("error occurred: \(String(describing: error))")
        } else {
            // Everything is alright.
            print("saved success!")
        }
    }
}
