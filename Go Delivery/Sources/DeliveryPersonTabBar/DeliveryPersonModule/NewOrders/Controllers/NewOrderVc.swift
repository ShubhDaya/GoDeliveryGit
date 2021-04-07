//  ApplicationApprovedStatusVC.swift
//  Go Delivery
//  Created by MACBOOK-SHUBHAM V on 10.11.20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.

import UIKit
var isapplicationInBackground = false

class NewOrderVc: UIViewController {
    
    //MARK:- IBOutlet-
    
    @IBOutlet weak var viewHeader: UIImageView!
    @IBOutlet weak var btnCross: UIButton!
    @IBOutlet weak var btnOk: UIButton!
    @IBOutlet weak var viewAlertshowAdminDocsUploaded: UIView!
    @IBOutlet weak var viewProfileNotCompleted: UIView!
    @IBOutlet weak var viewGotoProfileshadow: UIView!
    @IBOutlet weak var viewGoProfileBtnShadow: UIView!
    
    @IBOutlet weak var profileNotCompletedFullview: UIView!
    // outlet for new order details -
    
    @IBOutlet weak var viewLocationDetailForShadow: UIView!
    @IBOutlet weak var lblPickupLocation: UILabel!
    @IBOutlet weak var lblDeliveryLocation: UILabel!
    
    @IBOutlet weak var imgDeliveryType: UIImageView!
    @IBOutlet weak var lblDeliveryTypeName: UILabel!
    @IBOutlet weak var lblDeleveryTypeDatw: UILabel!
    
    @IBOutlet weak var lblWidth: UILabel!
    @IBOutlet weak var lblHeight: UILabel!
    @IBOutlet weak var lblLenght: UILabel!
    @IBOutlet weak var lblWeight: UILabel!
    
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var imgCustomer: UIImageView!
    @IBOutlet weak var lblCustomerName: UILabel!
    @IBOutlet weak var lblCustomerPhone: UILabel!
    
    @IBOutlet weak var viewTrackOrderSideRadius: UIView!
    @IBOutlet weak var viewTrackOrderBtnShadow: UIView!
    @IBOutlet weak var viewNewOrderDetailforHideshow: UIView!
    
    @IBOutlet weak var btnToggleAvailabilty: UIButton!
    @IBOutlet weak var viewNotOrderAssigndForShadow: UIView!
    @IBOutlet weak var ViewNotAssignOfflineStatus: UIView!
        
    @IBOutlet weak var lblOfflineNoordertext: UILabel!
    @IBOutlet weak var imgNoOrderOfflineStatus: UIImageView!
    
    //MARK:- variables -
    
    var buttonTittle = ""
    var gradientLayer: CAGradientLayer!
    var AvailableStatus = -1
    var alertStaus = ""
    var check = true
    
    var isavailable = ""
    var isDocumentUploaded = ""
    var isdminAproved = ""
    var DeliveryId = ""
    
    var isnotificationread = ""
    var strAlertId = ""
    var deliveryId = ""
    
    //MARK:- viewAppLifeCycles -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnCross.isHidden = true
        self.ViewNotAssignOfflineStatus.isHidden = true
        self.viewNewOrderDetailforHideshow.isHidden = true
        self.viewAlertshowAdminDocsUploaded.isHidden = true
        self.profileNotCompletedFullview.isHidden = true
        
        let notificationCenter = NotificationCenter.default
        
          NotificationCenter.default.addObserver(
            self,
            selector:#selector(appMovedToForground),
            name: UIApplication.didBecomeActiveNotification,
            object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        isfromAllTab = true // Api run in profile base class for my profile

        self.view.endEditing(true)
        self.InicialUISetup()
        self.ViewNotAssignOfflineStatus.isHidden = true
        viewNewOrderDetailforHideshow.isHidden = true
        self.viewAlertshowAdminDocsUploaded.isHidden = true
        self.profileNotCompletedFullview.isHidden = true
        
        self.callCheckProfileStatus()
    }
    
    @objc func appMovedToForground()
    {

        self.view.layoutIfNeeded()
        print("appMovedToForground")
        print(isapplicationInBackground)

        if isapplicationInBackground == true{
            isapplicationInBackground = false
            callCheckProfileStatus()

        }
    }
    
    @objc func appMovedToBackground() {
        print("applicationwillResignActve")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("did apprear")
    }
    
    //MARK:- Buttons -
    
    @IBAction func btnToggleIsAvailableStatus(_ sender: Any) {
        self.view.endEditing(true)
        
        if self.isDocumentUploaded == "1" && self.isdminAproved == "1"{
            check = !check
            if alertStaus == "0"{
                btnToggleAvailabilty.setImage(#imageLiteral(resourceName: "ON_TOGGLE_ICO"), for: .normal)
                //  check = true
                AvailableStatus = 1
                print(" for on \(AvailableStatus)")
                self.view.endEditing(true)
                self.callWebforchangeAvailablestatus()
                  
            } else if alertStaus == "1"
            {
                btnToggleAvailabilty.setImage(#imageLiteral(resourceName: "OFF_TOGGLE_ICO"), for: .normal)
                
                AvailableStatus = 0
                print(" for off \(AvailableStatus)")
                self.callWebforchangeAvailablestatus()
            }
            self.view.endEditing(true)
            
        }else{
        }
    }
    
    @IBAction func btnOkExit(_ sender: Any) {
        //exit(0);
        self.view.endEditing(true)
        
        if buttonTittle == "OK"{
            testExample()
        }else if buttonTittle == "Exit"{
            self.callWebForLogout()
            self.view.endEditing(true)
        }
    }
    
    @IBAction func btnCross(_ sender: Any) {
        isapplicationInBackground = true
        UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
        self.view.endEditing(true)
        
    }
    
    @IBAction func btnGoToProfile(_ sender: Any) {
        self.view.endEditing(true)
        tabBarController?.selectedIndex = 3
    }
    
    @IBAction func btnTrackOrder(_ sender: Any) {
        self.view.endEditing(true)
            
        let storyBoard = UIStoryboard(name: "NewOrder", bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "TrackOrderVC") as! TrackOrderVC
        
        vc.DeliveryId = DeliveryId
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    //MARK:- Local Methods -
    
    func InicialUISetup(){
        
        btnOk.layer.cornerRadius = 22
        btnOk.layer.masksToBounds = true
        self.btnOk.setbtnshadow()
        self.viewGotoProfileshadow.setShadowAllView45()
        self.viewNotOrderAssigndForShadow.setShadowAllView10()
        self.viewProfileNotCompleted.setShadowAllView10()
        self.viewLocationDetailForShadow.setShadowAllView10()
        self.imgCustomer.setImageFream()
        self.viewTrackOrderSideRadius.setViewRadiusRightSide()
        self.viewTrackOrderBtnShadow.setShadowAllView()
        
        viewGoProfileBtnShadow.clipsToBounds = true
        viewGoProfileBtnShadow.layer.cornerRadius = 22.5
        viewGoProfileBtnShadow.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
    }
    
    func testExample() {
        self.view.endEditing(true)
        isapplicationInBackground = true

        UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
    }
    
    func createGradientLayer() {
        let colorTop =  UIColor(red: 255.0/255.0, green: 1.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 255.0/255.0, green: 94.0/255.0, blue: 58.0/255.0, alpha: 1.0).cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds
        
        self.view.layer.insertSublayer(gradientLayer, at:0)
        self.viewHeader.layer.addSublayer(gradientLayer)
    }
    
    func checkNotificationStatus(){
        
        if alertStaus == "1"{
            btnToggleAvailabilty.setImage(#imageLiteral(resourceName: "ON_TOGGLE_ICO"), for: .normal)
            self.ViewNotAssignOfflineStatus.isHidden = true
            
            
        }else if alertStaus == "0" {
            btnToggleAvailabilty.setImage(#imageLiteral(resourceName: "OFF_TOGGLE_ICO"), for: .normal)
            print(" for off \(AvailableStatus)")
            
            self.ViewNotAssignOfflineStatus.isHidden = false
            self.lblOfflineNoordertext.text = "You are offline now. Keep yourself online to get an order"
            self.imgNoOrderOfflineStatus.image = UIImage(named:"usr_offline_ico")
        }
        self.callNewOrder()
        
    }
    
    
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
        let dt = dateFormatter.date(from: date) //{
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: dt ?? Date())
    }
    
}

//MARK:- Webservice  -

extension NewOrderVc {
    
    func callCheckProfileStatus(){
        
        self.view.endEditing(true)
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAppShareData.showNetworkAlert(view:self)
            return
        }
        objWebServiceManager.showIndicator()
        let   param = [
            WsParam.user_id: objAppShareData.userDetail.strUserID,
            ] as [String : Any]
        
        self.ViewNotAssignOfflineStatus.isHidden = true
        self.viewNewOrderDetailforHideshow.isHidden = true
        self.viewAlertshowAdminDocsUploaded.isHidden = true
        self.profileNotCompletedFullview.isHidden = true
        
        print(param)
        objWebServiceManager.requestGet(strURL: WsUrl.ChecApprovedProfileStatus , params: param, queryParams: [:], strCustomValidation: "", success: { (response) in
            print(response)
            let status = response["status"] as? String ?? ""
            let message = response["message"] as? String ?? ""
            
            if status == "success"{
                if let dataS = response["data"] as? [String:Any]{
                objWebServiceManager.hideIndicator()
                    
                    let isAvailable = dataS["is_available"] as? String ?? ""
                    let is_document_uploaded = dataS["is_document_uploaded"] as? String ?? ""
                    let is_profile_approved = dataS["is_profile_approved"] as? String ?? ""
                    let userID = dataS["userID"] as? String ?? ""
                    
                    self.isavailable = isAvailable
                    self.isDocumentUploaded = is_document_uploaded
                    self.isdminAproved = is_profile_approved
                    
                    UserDefaults.standard.set(isAvailable, forKey: "DeliveryPersonisAvailable") //Bool
                    
                    
                    self.alertStaus = UserDefaults.standard.string(forKey: "DeliveryPersonisAvailable") ?? ""
                 
                    if self.isavailable == "0" || self.alertStaus == "0"{
                        self.viewNewOrderDetailforHideshow.isHidden = true
                        self.viewAlertshowAdminDocsUploaded.isHidden = true
                        self.profileNotCompletedFullview.isHidden = true
                        self.ViewNotAssignOfflineStatus.isHidden = false

                    }else if self.isavailable == "1" || self.alertStaus == "1"{
                        self.viewNewOrderDetailforHideshow.isHidden = false
                        self.viewAlertshowAdminDocsUploaded.isHidden = false
                        self.profileNotCompletedFullview.isHidden = false
                        self.ViewNotAssignOfflineStatus.isHidden = true

                    }
                    
                    if is_document_uploaded == "0" && is_profile_approved == "0"{
                        self.ViewNotAssignOfflineStatus.isHidden = true
                        self.viewNewOrderDetailforHideshow.isHidden = true
                        self.viewAlertshowAdminDocsUploaded.isHidden = true
                        self.tabBarController?.tabBar.isHidden = false
                        self.profileNotCompletedFullview.isHidden = false
                        self.tabBarController?.tabBar.items![1].isEnabled = false
                        self.tabBarController?.tabBar.items![2].isEnabled = false
                        self.tabBarController?.tabBar.isHidden = false

                        
                    }else if is_document_uploaded == "1" && is_profile_approved == "0"{
                        
                        self.viewNewOrderDetailforHideshow.isHidden = true
                        self.ViewNotAssignOfflineStatus.isHidden = true
                        self.profileNotCompletedFullview.isHidden = true
                        
                        self.viewAlertshowAdminDocsUploaded.isHidden = false
                        
                        self.tabBarController?.tabBar.isHidden = true
                        self.btnCross.isHidden = false
                        self.btnOk.setTitle("Exit", for: .normal)
                        self.buttonTittle = "Exit"
                        self.tabBarController?.tabBar.items![1].isEnabled = true
                        self.tabBarController?.tabBar.items![2].isEnabled = true
                        self.tabBarController?.tabBar.items![3].isEnabled = true
                        
                        
                    }else if is_document_uploaded == "1" && is_profile_approved == "1"  {
                        
                        if self.isavailable == "0"  || self.alertStaus == "0"{
                            self.viewNewOrderDetailforHideshow.isHidden = true
                            self.viewAlertshowAdminDocsUploaded.isHidden = true
                            self.profileNotCompletedFullview.isHidden = true
                            self.ViewNotAssignOfflineStatus.isHidden = false
                        }else{
                            self.viewNewOrderDetailforHideshow.isHidden = false
                            self.viewAlertshowAdminDocsUploaded.isHidden = true
                            self.profileNotCompletedFullview.isHidden = true
                            self.ViewNotAssignOfflineStatus.isHidden = true
                        }
                        
                        self.tabBarController?.tabBar.isHidden = false
                        self.tabBarController?.tabBar.items![1].isEnabled = true
                        self.tabBarController?.tabBar.items![2].isEnabled = true
                        self.tabBarController?.tabBar.items![3].isEnabled = true
                        self.checkNotificationStatus()

                    }
                    if objAppShareData.isFromNotification == true  {
                                              if objAppShareData.strNotificationType == "new_order" || objAppShareData.strNotificationType == "profile_approved"
                                              {
                                                  self.callWebforReadNotification()
                                              }
                                          }
                                          
                                          if isFromAlertList == true{
                                              self.isnotificationread = objAppShareData.isreadStatus
                                              
                                              print(self.isnotificationread)
                                              if  self.isnotificationread == "0"{
                                                  self.callWebforReadNotification()
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
    
    
    func callWebForLogout(){
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAppShareData.showNetworkAlert(view:self)
            return
        }
        objWebServiceManager.showIndicator()
        let   param = [
            WsParam.user_id: objAppShareData.userDetail.strUserID,
            ] as [String : Any]
        
        print(param)
        objWebServiceManager.requestGet(strURL: WsUrl.logout, params:param, queryParams: [:], strCustomValidation: "", success: { (response) in
            let status = response["status"] as? String ?? ""
            let message = response["message"] as? String ?? ""
            
            if status == "success"{
                objWebServiceManager.hideIndicator()
                ObjAppdelegate.loginNavigation()
            }else{
                objWebServiceManager.hideIndicator()
                
                objAlert.showAlert(message: message, title: "Alert", controller: self)
            }
        }) { (error) in
            objWebServiceManager.hideIndicator()
            objAppShareData.showAlert(title: kAlertTitle, message: kErrorMessage, view: self)
            print(error)
        }
    }
    
    func callWebforchangeAvailablestatus(){
        objWebServiceManager.showIndicator()
        
        objWebServiceManager.requestPatch(strURL: WsUrl.AvailablityChangeStatus+String(AvailableStatus), params: [:], queryParams: [:], strCustomValidation: "", success: { (response) in
            print(response)
            objWebServiceManager.hideIndicator()
            
            
            let status = response["status"] as? String
            let message = response["message"] as? String ?? ""
            if status == "success"{
                let dic = response["data"] as? [String:Any] ?? [:]
                let is_available = dic["is_available"] as? Int ?? 0
                print(is_available)
                
                UserDefaults.standard.set(String(is_available), forKey: "DeliveryPersonisAvailable") //Bool
                
                self.isavailable = UserDefaults.standard.string(forKey: "DeliveryPersonisAvailable") ?? ""
                self.alertStaus = UserDefaults.standard.string(forKey: "DeliveryPersonisAvailable") ?? ""
                self.checkNotificationStatus()
                
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
    
    
    func callNewOrder(){
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAppShareData.showNetworkAlert(view:self)
            return
        }
        //objWebServiceManager.showIndicator()
        self.ViewNotAssignOfflineStatus.isHidden = true
                           self.viewNewOrderDetailforHideshow.isHidden = true
                           self.viewAlertshowAdminDocsUploaded.isHidden = true
                           self.profileNotCompletedFullview.isHidden = true
        objWebServiceManager.requestGet(strURL: WsUrl.NewOrder , params: [:], queryParams: [:], strCustomValidation: "", success: { (response) in
            let status = response["status"] as? String ?? ""
            let message = response["message"] as? String ?? ""
            
            if status == "success"{
                if let dataS = response["data"] as? [String:Any]{
                    
                    let datafound = dataS["data_found"] as? Int ?? 9
                   
                    print(datafound)
                    
                   // objWebServiceManager.hideIndicator()
                    
                    let obj = DeliveryDetailsModel.init(dict: dataS)
                    
                    self.DeliveryId = obj.strDeliveryID
                    
                    
                    if datafound == 1{
                   
                        if self.isDocumentUploaded == "1" && self.isdminAproved == "1"{
                            if self.isavailable == "1" || self.alertStaus == "1"{
                                
                                self.btnToggleAvailabilty.setImage(#imageLiteral(resourceName: "ON_TOGGLE_ICO"), for: .normal)
                                self.viewNewOrderDetailforHideshow.isHidden = false
                                self.viewAlertshowAdminDocsUploaded.isHidden = true
                                self.profileNotCompletedFullview.isHidden = true
                                self.ViewNotAssignOfflineStatus.isHidden = true
                                
                                self.lblCustomerName.text = "\(obj.strfirst_name) \(obj.strlast_name)"
                                self.lblPickupLocation.text = obj.strfrom_location
                                self.lblDeliveryLocation.text = obj.strto_location
                                
                                let strimage = obj.strprofile_picture
                                let urlImg = URL(string: strimage)
                                self.imgCustomer.sd_setImage(with: urlImg, placeholderImage:#imageLiteral(resourceName: "placeholder_img"))
                                
                                if obj.strphone_dial_code == "" && obj.strphone_number == "" {
                                    
                                    self.lblCustomerPhone.text = "NA"
                                }else{
                                    self.lblCustomerPhone.text = "\(obj.strphone_dial_code)-\(obj.strphone_number)"
                                }
                                
                                
                                let str = obj.strdelivery_type_name
                                print(str.count)
                                let arr = str.components(separatedBy: ",")
                                print(arr.count)
                                
                                if arr.count >= 2 {
                                    self.lblDeliveryTypeName.text = "Multiple delivery"
                                    
                                }else {
                                    self.lblDeliveryTypeName.text = obj.strdelivery_type_name
                                    
                                }
                                
                                // delivery type img
                                
                                let strimg = obj.strPhoto
                                let urImg = URL(string: strimg)
                                self.imgDeliveryType.sd_setImage(with: urImg, placeholderImage:#imageLiteral(resourceName: "placeholder_img"))
                                
                                // delivery date
                                let objdate = obj.strdelivery_date
                                let objTime = obj.strdelivery_time
                                let Date = self.changeDateFormatter(date: objdate)
                                let time = self.changeTimeFormatter(date: objTime)
                                
                                self.lblDeleveryTypeDatw.text = "\(Date) \(time)"
                                
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
                                        
                                        self.lblLenght.text = "NA"
                                    }else{
                                        self.lblLenght.text = "\(obj.strLength) cm"
                                        
                                    }
                                    
                                }else if  obj.strLength_unit == "2"{
                                    
                                    let lenght = obj.strLength
                                    
                                    if lenght == ""{
                                        self.lblLenght.text = "NA"
                                    }else{
                                        self.lblLenght.text = "\(obj.strLength) feet"
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
                                
                            }else if self.isavailable == "0" || self.alertStaus == "0"{
                                
                                self.btnToggleAvailabilty.setImage(#imageLiteral(resourceName: "OFF_TOGGLE_ICO"), for: .normal)
                                    
                                
                                self.viewNewOrderDetailforHideshow.isHidden = true
                                self.viewAlertshowAdminDocsUploaded.isHidden = true
                                self.profileNotCompletedFullview.isHidden = true
                                self.ViewNotAssignOfflineStatus.isHidden = false
                                
                                self.lblOfflineNoordertext.text = "You are offline now. Keep yourself online to get an order"
                                self.imgNoOrderOfflineStatus.image = UIImage(named:"usr_offline_ico")
                            }
                        }
                    }else{
                        
                        if self.isDocumentUploaded == "1" && self.isdminAproved == "1"{
                            
                            if self.alertStaus == "1" || self.isavailable == "1"{
                                
                                self.btnToggleAvailabilty.setImage(#imageLiteral(resourceName: "ON_TOGGLE_ICO"), for: .normal)

                                self.ViewNotAssignOfflineStatus.isHidden = false
                                self.lblOfflineNoordertext.text = "You have not been assigned any order yet. Keep yourself online to get an order"
                                self.imgNoOrderOfflineStatus.image = UIImage(named:"no_order_ico")
                            }else{
                                self.btnToggleAvailabilty.setImage(#imageLiteral(resourceName: "OFF_TOGGLE_ICO"), for: .normal)

                                self.ViewNotAssignOfflineStatus.isHidden = false
                                self.lblOfflineNoordertext.text = "You are offline now. Keep yourself online to get an order"
                                self.imgNoOrderOfflineStatus.image = UIImage(named:"usr_offline_ico")
                            }
                        }
                      
                    }
                }
                
            }else{
              //  objWebServiceManager.hideIndicator()
                objAlert.showAlert(message: message , title: kAlertTitle, controller: self)
            }
        }) { (error) in
            print(error)
          //  objWebServiceManager.hideIndicator()
            
            objAlert.showAlert(message: kErrorMessage , title: kAlertTitle, controller: self)
            
        }
    }
    
    func callWebforReadNotification(){
        
        strAlertId = objAppShareData.strNotificationAlertId
        // objWebServiceManager.showIndicator()
        
        objWebServiceManager.requestPatch(strURL: WsUrl.ReadNotification+String(strAlertId), params:[:] , queryParams: [:], strCustomValidation: "", success: { (response) in
            print(response)
            //objWebServiceManager.hideIndicator()
            
            let status = response["status"] as? String
            let message = response["message"] as? String ?? ""
            if status == "success"{
                let dic = response["data"] as? [String:Any] ?? [:]
                objAppShareData.isFromNotification = false
                objAppShareData.strNotificationType = ""
                objAppShareData.notificationDict = [:]
                objAppShareData.isreadStatus = ""
                isFromAlertList = false
                
            }  else{
              //  objWebServiceManager.hideIndicator()
                if message == "k_sessionExpire"{
                    objAlert.showAlert(message: k_sessionExpire, title: kAlertTitle, controller: self)
                    ObjAppdelegate.loginNavigation()
                }  else{
                //    objWebServiceManager.hideIndicator()
                    objAlert.showAlert(message:message, title: kAlertTitle, controller: self)
                }
            }
            
        }) { (error) in
            print(error)
           // objWebServiceManager.hideIndicator()
            objAppShareData.showAlert(title: kAlertTitle, message: kErrorMessage, view: self)
        }
    }
}
