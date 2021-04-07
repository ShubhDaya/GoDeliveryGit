//
//  CompleteOrderDetailVc.swift
//  Go Delivery
//
//  Created by MACBOOK-SHUBHAM V on 07.12.20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit
import HCSStarRatingView

class CompleteOrderDetailVc: UIViewController {
    
    //MARK:- IBOutlet-
    @IBOutlet weak var viewAskForReview: UIView!
   
    @IBOutlet weak var lblPickupLocation: UILabel!
    @IBOutlet weak var lblDeliveryLocation: UILabel!
    @IBOutlet weak var imgDeliveryTypeImg: customImage!
    
    @IBOutlet weak var lblDeliveryDateTime: UILabel!
    @IBOutlet weak var lblDeliveryType: UILabel!
    
    @IBOutlet weak var lblWidth: UILabel!
    @IBOutlet weak var lblHeight: UILabel!
    @IBOutlet weak var lbllenght: UILabel!
    
    @IBOutlet weak var lblWeight: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblCustomerName: UILabel!
    @IBOutlet weak var lblCustomerMobileNumber: UILabel!
    @IBOutlet weak var lblReview: UILabel!
    
    @IBOutlet weak var viewReviewRating: HCSStarRatingView!
    
    @IBOutlet weak var lblReviewGivenData: UILabel!
    
    @IBOutlet weak var viewLocationForShadow: UIView!
    @IBOutlet weak var imgCustomerImg: UIImageView!
    
    @IBOutlet weak var viewNoReviewGiven: UIView!
    
    @IBOutlet weak var viewReviewGiven: UIView!
    
    
    @IBOutlet weak var viewOrderTracking: UIView!
    
    @IBOutlet weak var viewBtnOrdertracking: UIView!
    
    @IBOutlet weak var viewLocationBtnOrderTrackingLeftSideRadiues: UIView!
    
    
    //MARK:- Local Variables-

    var deliveryId = ""
    var isnotificationread = ""
    var strAlertId = ""

    //MARK:- View Life Cycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.InicialUISetup()
        self.calOrderdetails()
    }
    
    //MARK:- Local Variables -

    func InicialUISetup(){
        self.viewLocationForShadow.setShadowAllView10()
        self.imgCustomerImg.setImageFream()
    self.viewLocationBtnOrderTrackingLeftSideRadiues.setViewRadiusRightSide()
        self.viewBtnOrdertracking.setShadowAllView()
    }
    
    
    //MARK:- UIButton Action -

    @IBAction func btnViewOrderTracking(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CompleteOrderTracking") as! CompleteOrderTracking
        vc.DeliveryId = deliveryId
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func btnBack(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func btnAskForReview(_ sender: Any) {
        
        self.callWebforAskforReview()
        
    }
    
    //MARK:- Local Methods  -

    func changeDateFormatter(date:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let dt = dateFormatter.date(from: date) //{
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "d MMM, yyyy,"
        return dateFormatter.string(from: dt ?? Date())
    }
    func changeTimeFormatter(date:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
        dateFormatter.dateFormat = "HH:mm:ss"
        // dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let dt = dateFormatter.date(from: date) //{
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: dt ?? Date())
    }
    
    
    func changeDateForReviewFormate(date:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let dt = dateFormatter.date(from: date) //{
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "d MMM yyyy"
        return dateFormatter.string(from: dt ?? Date())
    }
}

//MARK:- Webservice Calling   -

extension CompleteOrderDetailVc {
    
    func calOrderdetails(){
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAppShareData.showNetworkAlert(view:self)
            return
        }
        objWebServiceManager.showIndicator()
        
        
        objWebServiceManager.requestGet(strURL: WsUrl.CompleteOrderDetail+String(deliveryId) , params: [:], queryParams: [:], strCustomValidation: "", success: { (response) in
            print(response)
            let status = response["status"] as? String ?? ""
            let message = response["message"] as? String ?? ""
            
            if status == "success"{
                if let dataS = response["data"] as? [String:Any]{
                    
                    let datafound = dataS["data_found"] as? Int ?? 9
                    
                    print(datafound)
                    
                    objWebServiceManager.hideIndicator()
                    
                    let obj = DeliveryDetailsModel.init(dict: dataS)
                    
                    if datafound == 1{
                        
                        self.lblCustomerName.text = "\(obj.strfirst_name) \(obj.strlast_name)"
                        self.lblPickupLocation.text = obj.strfrom_location
                        self.lblDeliveryLocation.text = obj.strto_location
                        
                        let strimage = obj.strprofile_picture
                        let urlImg = URL(string: strimage)
                        self.imgCustomerImg.sd_setImage(with: urlImg, placeholderImage:#imageLiteral(resourceName: "placeholder_img"))
                        
//                        if obj.strphone_dial_code == "" && obj.strphone_number == "" {
//
//                            self.lblCustomerMobileNumber.text = "NA"
//                        }else{
//                            self.lblCustomerMobileNumber.text = "\(obj.strphone_dial_code)-\(obj.strphone_number)"
//                        }
//
                        
                                              if obj.strphone_number == "" {
                        
                                                    self.lblCustomerMobileNumber.text = "NA"
                                                }else{
                                                    self.lblCustomerMobileNumber.text = "\(obj.strphone_dial_code)-\(obj.strphone_number)"
                                                }
                        
                        
                        let str = obj.strdelivery_type_name
                        print(str.count)
                        let arr = str.components(separatedBy: ",")
                        print(arr.count)
                        
                        if arr.count >= 2 {
                            self.lblDeliveryType.text = "Multiple delivery"
                            
                        }else {
                            self.lblDeliveryType.text = obj.strdelivery_type_name
                            
                        }
                        
                        // delivery type img
                        let strimg = obj.strPhoto
                        let urImg = URL(string: strimg)
                        self.imgDeliveryTypeImg.sd_setImage(with: urImg, placeholderImage:#imageLiteral(resourceName: "placeholder_img"))
                        
                        // delivery date
                        let objdate = obj.strdelivery_date
                        let objTime = obj.strdelivery_time
                        let Date = self.changeDateFormatter(date: objdate)
                        let time = self.changeTimeFormatter(date: objTime)
                        
                        self.lblDeliveryDateTime.text = "\(Date) \(time)"
                        
                        // description
                        let desc = obj.strdescription
                        let trimDescription = desc.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines).filter{!$0.isEmpty}.joined(separator: "\n")
                        
                        if trimDescription != ""{
                            self.lblDescription.text = trimDescription
                            
                        }else
                        {
                            self.lblDescription.text = "NA"
                        }
                        
                        // dimesion units -
                        if obj.strLength_unit == "1"{
                            
                            let lenght = obj.strLength
                            
                            if lenght == ""{
                                
                                self.lbllenght.text = "NA"
                            }else{
                                self.lbllenght.text = "\(obj.strLength) cm"
                                
                            }
                            
                        }else if  obj.strLength_unit == "2"{
                            
                            let lenght = obj.strLength
                            
                            if lenght == ""{
                                self.lbllenght.text = "NA"
                            }else{
                                self.lbllenght.text = "\(obj.strLength) feet"
                            }
                        }
                        
                        if obj.strhight_unit == "1"{
                            
                            let height = obj.strHeight
                            if height == ""{
                                self.lblHeight.text = "NA"
                            }else{
                                self.lblHeight.text = "\(obj.strHeight) cm"
                            }
                            
                        }else if  obj.strhight_unit == "2"{
                            let height = obj.strHeight
                            if height == ""{
                                self.lblHeight.text = "NA"
                            }else{
                                self.lblHeight.text = "\(obj.strHeight) feet"
                            }
                            
                        }
                        if obj.strweight_unit == "1"{
                            let weight = obj.strweight
                            if weight == ""{
                                self.lblWeight.text = "NA"
                            }else{
                                self.lblWeight.text = "\(obj.strweight) kg"
                            }
                            
                        }else if obj.strweight_unit == "2"{
                            let weight = obj.strweight
                            if weight == ""{
                                self.lblWeight.text = "NA"
                            }else{
                                self.lblWeight.text = "\(obj.strweight) lbs"
                            }
                        }
                        
                        if obj.strwidth_unit == "1"{
                            
                            let width = obj.strwidth
                            if width == ""{
                                
                                self.lblWidth.text = "NA"
                            }else{
                                self.lblWidth.text = "\(obj.strwidth) cm"
                            }
                        }else if obj.strwidth_unit == "2"{
                            
                            let width = obj.strwidth
                            if width == ""{
                                
                                self.lblWidth.text = "NA"
                            }else{
                                self.lblWidth.text = "\(obj.strwidth) feet"
                            }
                        }
                        
                        
                        let reviewGiven = obj.strReviewGiven
                        if reviewGiven == "1"{
                            
                            self.viewReviewGiven.isHidden = false
                            self.viewNoReviewGiven.isHidden = true
                            self.lblReview.text =  obj.strRevReview
                            let ProfileRating = Int(obj.strRevRating) ?? 0
                            self.viewReviewRating.value = CGFloat(ProfileRating)
                            
                            self.lblReviewGivenData.text = self.changeDateForReviewFormate(date: obj.strRevCreated_at)
                            
                        }else if reviewGiven == "0"{
                            self.viewReviewGiven.isHidden = true
                            self.viewNoReviewGiven.isHidden = false
                            
                        }
                        
                        if obj.strisReviewRequested == "1"{
                            self.viewAskForReview.isHidden = true
                        }else if obj.strisReviewRequested == "0"{
                            
                            self.viewAskForReview.isHidden = false

                        }
                        
                        if objAppShareData.isFromNotification == true  {
                            self.callWebforReadNotification()
                        }else
                        {
                            
                        }
                        
                        if isFromAlertList == true{
                            print(self.isnotificationread)
                            if  self.isnotificationread == "0"{
                                    self.callWebforReadNotification()
                            }
                                              
                            }
                    }
                    
                }
            }
      
        }
        ) { (error) in
            print(error)
            objWebServiceManager.hideIndicator()
            
            objAlert.showAlert(message: kErrorMessage , title: kAlertTitle, controller: self)
            
        }
    }
    
    func callWebforReadNotification(){
          if !objWebServiceManager.isNetworkAvailable(){
                    objWebServiceManager.hideIndicator()
                    objAppShareData.showNetworkAlert(view:self)
                    return
                }
          strAlertId = objAppShareData.strNotificationAlertId
          
          
          objWebServiceManager.showIndicator()
          
          objWebServiceManager.requestPatch(strURL: WsUrl.ReadNotification+String(strAlertId), params:[:] , queryParams: [:], strCustomValidation: "", success: { (response) in
              print(response)
              objWebServiceManager.hideIndicator()
              
              
              let status = response["status"] as? String
              let message = response["message"] as? String ?? ""
              if status == "success"{
                  let dic = response["data"] as? [String:Any] ?? [:]
                  objAppShareData.isFromNotification = false
                  objAppShareData.strNotificationType = ""
                  objAppShareData.notificationDict = [:]
                  
              }  else{
                  objWebServiceManager.hideIndicator()
                  if message == "k_sessionExpire"{
                      objAlert.showAlert(message: k_sessionExpire, title: kAlertTitle, controller: self)
                      ObjAppdelegate.loginNavigation()
                  }  else{
                      objWebServiceManager.hideIndicator()
                      
                      objAlert.showAlert(message:message, title: kAlertTitle, controller: self)
                  }
              }
              
          }) { (error) in
              print(error)
              objWebServiceManager.hideIndicator()
              objAppShareData.showAlert(title: kAlertTitle, message: kErrorMessage, view: self)
          }
      }
    
    
    
    func callWebforAskforReview(){
            if !objWebServiceManager.isNetworkAvailable(){
                      objWebServiceManager.hideIndicator()
                      objAppShareData.showNetworkAlert(view:self)
                      return
                  }
       
           // objWebServiceManager.showIndicator()
            
            objWebServiceManager.requestPatch(strURL: WsUrl.AskForReview+String(deliveryId), params:[:] , queryParams: [:], strCustomValidation: "", success: { (response) in
                print(response)
                objWebServiceManager.hideIndicator()
                
                
                let status = response["status"] as? String
                let message = response["message"] as? String ?? ""
                if status == "success"{
                    let dic = response["data"] as? [String:Any] ?? [:]

                    self.calOrderdetails()
                    
                }  else{
                    objWebServiceManager.hideIndicator()
                    if message == "k_sessionExpire"{
                        objAlert.showAlert(message: k_sessionExpire, title: kAlertTitle, controller: self)
                        ObjAppdelegate.loginNavigation()
                    }  else{
                        objWebServiceManager.hideIndicator()
                        
                        objAlert.showAlert(message:message, title: kAlertTitle, controller: self)
                    }
                }
                
            }) { (error) in
                print(error)
                objWebServiceManager.hideIndicator()
                objAppShareData.showAlert(title: kAlertTitle, message: kErrorMessage, view: self)
            }
        }
}
