//
//  CompleteOrderTracking.swift
//  Go Delivery
//
//  Created by MACBOOK-SHUBHAM V on 07.12.20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit
import SDWebImage

class CompleteOrderTracking: UIViewController {
    
    
    // MARK:- IBOutlet -
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var imgBarCode: UIImageView!
    @IBOutlet weak var lblbarcodeDigit: UILabel!
    @IBOutlet weak var viewDownloadForshadow: UIView!
    @IBOutlet weak var viewPrintForShadow: UIView!
    @IBOutlet weak var viewDownloadImgCorner: UIView!
    @IBOutlet weak var viewPrintimgForCorner: UIView!
    @IBOutlet weak var lblDeliveryPickUpDate: UILabel!
    @IBOutlet weak var lblInProgress: UILabel!
    @IBOutlet weak var lblDelivered: UILabel!
    
    // MARK:- local Variables  -

    var DeliveryId = ""
    var barcode_image = ""
    var imageurl : URL?
    var image : UIImage?
    var isfromPriterButton = false
    
    // MARK:- View Life Cycles  -

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewDownloadForshadow.setShadowAllView35()
        self.viewPrintForShadow.setShadowAllView35()
        self.initialUISetup()
        self.callTrackOrder()
    }
    
    // MARK:- UIButton Action  -

    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
        @IBAction func btnDownloadBarcode(_ sender: Any) {
            self.isfromPriterButton = false

        if self.barcode_image != ""  && self.image != nil{
            self.writeImage(image: image!)

                 guard let url = URL(string: barcode_image) else { return }
                 
                 let urlSession = URLSession(configuration: .default, delegate: self as! URLSessionDelegate, delegateQueue: OperationQueue())
                 
                 let downloadTask = urlSession.downloadTask(with: url)
                 downloadTask.resume()
        }
    }
    
    @IBAction func btnPrint(_ sender: Any) {
          
        self.isfromPriterButton = true
        if self.barcode_image != "" && self.image != nil{
             self.writeImage(image: image!)
             guard let url = URL(string: barcode_image) else { return }
             let urlSession = URLSession(configuration: .default, delegate: self as! URLSessionDelegate, delegateQueue: OperationQueue())
             let downloadTask = urlSession.downloadTask(with: url)
             downloadTask.resume()
         }
      }
    
    func initialUISetup(){
        
            viewDownloadImgCorner.clipsToBounds = true
            viewDownloadImgCorner.layer.cornerRadius = 17.5
            viewDownloadImgCorner.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
            
            viewPrintimgForCorner.clipsToBounds = true
            viewPrintimgForCorner.layer.cornerRadius = 17.5
            viewPrintimgForCorner.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
            
            viewHeader.layer.shadowColor = UIColor.lightGray.cgColor
            viewHeader.layer.masksToBounds = false
            viewHeader.layer.shadowOffset = CGSize(width: 0.0 , height: 5.0)
            viewHeader.layer.shadowOpacity = 0.3
            viewHeader.layer.shadowRadius = 3
   
    }
    
    func changeDateFormatter(date:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        //dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let dt = dateFormatter.date(from: date) //{
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "d MMM, yyyy, hh:mm a"
        return dateFormatter.string(from: dt ?? Date())
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
}
//MARK:- Webservice Calling -
extension CompleteOrderTracking{
    
    func callTrackOrder(){
        self.view.endEditing(true)
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAppShareData.showNetworkAlert(view:self)
            return
        }
        objWebServiceManager.showIndicator()
        
        objWebServiceManager.requestGet(strURL: WsUrl.TrackOrder+String(DeliveryId) , params: [:], queryParams: [:], strCustomValidation: "", success: { (response) in
            print(response)
            let status = response["status"] as? String ?? ""
            let message = response["message"] as? String ?? ""
            
            if status == "success"{
                objWebServiceManager.hideIndicator()
                
                if let dataS = response["data"] as? [String:Any]{
                    if let trackDetails = dataS["delivery_detail"] as? [String:Any]{
                        
                        self.barcode_image = trackDetails["barcode_image"]as? String ?? ""
                        let order_id = trackDetails["order_id"]as? String ?? ""
                        
                        if let status_updated_at = trackDetails["status_updated_at"] as? [String:Any]{
                            let PickUpDate = status_updated_at["3"]as? String ?? ""
                            let InProgressDate = status_updated_at["4"]as? String ?? ""
                            let InDeliveredDate = status_updated_at["5"]as? String ?? ""
                            
                            self.lblDeliveryPickUpDate.text = self.changeDateFormatter(date: PickUpDate)
                            self.lblInProgress.text = self.changeDateFormatter(date: InProgressDate)
                            self.lblDelivered.text = self.changeDateFormatter(date: InDeliveredDate)
                        }
                        
                        if self.barcode_image == "" {
                            
                        }else{
                            print(self.barcode_image)
                            DispatchQueue.main.async {
                                let strimage = self.barcode_image
                                let urlImg = URL(string: strimage)
                                self.imgBarCode.sd_setImage(with: urlImg, placeholderImage:nil)
                            }
                        
                            self.lblbarcodeDigit.text = order_id
                            
                            let urlImg2 = URL(string: self.barcode_image)
                            let data = try? Data(contentsOf: urlImg2!)
                            
                            if let imageData = data {
                                self.image = UIImage(data: imageData)
                            }
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
    
}

//MARK:-  URLSessionDownloadDelegate -

extension CompleteOrderTracking:  URLSessionDownloadDelegate {
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

extension CompleteOrderTracking {
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
