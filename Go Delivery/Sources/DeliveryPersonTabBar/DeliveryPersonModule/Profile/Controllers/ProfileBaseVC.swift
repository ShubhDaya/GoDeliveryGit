//
//  ProfileBaseVC.swift
//  Go Delivery
//  Created by MACBOOK-SHUBHAM V on 23.11.20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.

import UIKit
import SJSegmentedScrollView
var isfromAllTab = false

class ProfileBaseVC: UIViewController{
    
    //MARK:- Local Variables -
    var segmentController : SJSegmentedViewController = SJSegmentedViewController()
    var selectedSegment : SJSegmentTab?
    var objBasicInfoVc : BasicInfoVc?
    var objDocumentVc : DocumentVc?
    var objDPprofileVc : DPprofileVc?
    var objContractVc : ContractVc?
    var objVehicleVC : VehicleVC?
    var currentSegmentIndex : Int = 0
    var isnotificationread = ""
    var strAlertId = ""
    var deliveryId = ""
    
    
    //MARK:- View Life cycles -

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = false

    }
    
    override func viewWillAppear(_ animated: Bool) {
        if isfromAllTab == true || objAppShareData.isFromNotification{
            if objAppShareData.strNotificationType == "new_contract_upload" {
                self.callWSForMyProfile()
            }else{
                self.callWSForMyProfile()
            }
        }
        if isfromEditProfileDeliveryPerosn ==  true{
            self.callWSForMyProfile()
            
        }
        self.tabBarController?.tabBar.isHidden = false

    }
}


//MARK:- inititalSegmentSetup -

extension ProfileBaseVC {
    
    func inititalSegmentSetUpWith(selectedIndex : Int){
        
        self.objBasicInfoVc = UIStoryboard.init(name: "ProfileDP", bundle: nil) .instantiateViewController(withIdentifier: "BasicInfoVc")as? BasicInfoVc
        self.objBasicInfoVc?.title = "Basic Info"
        self.objBasicInfoVc?.objprofileDetails = objAppShareData.strDeliveryPersonUserdetails
        
        self.objDocumentVc = UIStoryboard.init(name: "ProfileDP", bundle: nil) .instantiateViewController(withIdentifier: "DocumentVc")as? DocumentVc
        self.objDocumentVc?.objDocprofileDetails = objAppShareData.strDeliveryPersonUserdetails
        
        self.objDocumentVc?.title = "Document"
        
        self.objContractVc = self.storyboard?
            .instantiateViewController(withIdentifier: "ContractVc") as? ContractVc
        self.objContractVc?.title = "Contract"
        self.objContractVc?.objprofileDetails = objAppShareData.strDeliveryPersonUserdetails
        
        self.objVehicleVC = self.storyboard?
            .instantiateViewController(withIdentifier: "VehicleVC") as? VehicleVC
        self.objVehicleVC?.title = "Vehicle Info"
        self.objVehicleVC?.objprofileDetails = objAppShareData.strDeliveryPersonUserdetails
        segmentController.headerViewController = UIViewController()
        
        let objDPprofileVc = UIStoryboard.init(name: "ProfileDP", bundle: nil) .instantiateViewController(withIdentifier: "DPprofileVc")as! DPprofileVc
        self.objDPprofileVc?.objprofileDetails = objAppShareData.strDeliveryPersonUserdetails
        
        segmentController.headerViewController = objDPprofileVc
        
        if UIScreen.main.bounds.size.height >= 800
        {
            segmentController.headerViewOffsetHeight = 35.0
        }
        else
        {
            segmentController.headerViewOffsetHeight = 35.0
        }
 
        if UIDevice().userInterfaceIdiom == .phone {
                switch UIScreen.main.nativeBounds.height {
                case 1136:
                    segmentController.headerViewHeight = 280

                case 1334:
                    segmentController.headerViewHeight = 290

                case 1920, 2208:
                    segmentController.headerViewHeight = 320

                case 2436:
                    segmentController.headerViewHeight = 320

                case 2688:
                    segmentController.headerViewHeight = 330

                case 1792:
                    segmentController.headerViewHeight = 320
                
                case 2532:
                    segmentController.headerViewHeight = 320
                
                case 2340:
                    segmentController.headerViewHeight = 320
                                                     
               case 2778:
                    segmentController.headerViewHeight = 330
                                   
                default:
                    print("Unknown")
                }
            }
        
        segmentController.segmentBackgroundColor = .white
        segmentController.segmentSelectedTitleColor = #colorLiteral(red: 0.8941176471, green: 0.03137254902, blue: 0.1921568627, alpha: 1)
        segmentController.segmentTitleColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        segmentController.segmentShadow = SJShadow.lightto()
        segmentController.segmentBounces = true
        
        segmentController.selectedSegmentViewColor = #colorLiteral(red: 0.8941176471, green: 0.03137254902, blue: 0.1921568627, alpha: 1)
        segmentController.selectedSegmentViewHeight = 2
        
        var controller = [UIViewController]()
        controller = [self.objBasicInfoVc!,
                      self.objDocumentVc!,
                      self.objContractVc! ,self.objVehicleVC!]
        
        segmentController.segmentControllers = controller
        segmentController.segmentViewHeight = 44.0
        
        segmentController.segmentTitleFont = UIFont(name: "Nunito-SemiBold", size: 16.0)!
        segmentController.segmentBounces = false
        
        segmentController.delegate = self
        
        addChild(segmentController)
        
        self.view.addSubview(segmentController.view)
        segmentController.didMove(toParent: self)
        
        if isfromNewContractAlert == true {
            segmentController.setSelectedSegmentAt(2, animated: true)
        }
        else if objAppShareData.isFromNotification{
                self.segmentController.setSelectedSegmentAt(2, animated: true)
        }
        else{
            segmentController.setSelectedSegmentAt(selectedIndex, animated: false)
        }
    }
}

//MARK:- extension for segmentedDelegate method-

extension ProfileBaseVC : SJSegmentedViewControllerDelegate{
    func didMoveToPage(_ controller: UIViewController, segment: SJSegmentTab?, index: Int) {
        self.currentSegmentIndex = index
        if selectedSegment != nil {
            selectedSegment?.titleColor(#colorLiteral(red: 0.2711373731, green: 0.2711373731, blue: 0.2711373731, alpha: 1))
            //selectedSegment?.titleFont(sds)
        }
        
        if segmentController.segments.count > 0 {
            selectedSegment = segmentController.segments[index]
            selectedSegment?.titleColor(.white)
        }
    }
}


//MARK:- Webservice Calling -

extension ProfileBaseVC {
    
    func callWSForMyProfile(){
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAppShareData.showNetworkAlert(view:self)
            return
        }
                
        objWebServiceManager.showIndicator()
     
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
                        objAppShareData.strDpprofile = objExcercise.strProfile_picture
                        objAppShareData.strNewContractFormUploaded = objExcercise.stris_contract_updated
                        UserDefaults.standard.set(objExcercise.stris_available, forKey: "DeliveryPersonisAvailable") //Bool
                        print(objExcercise.stris_available)
                        
                        isfromEditProfileDeliveryPerosn = false
                        
                        self.objBasicInfoVc?.alertStaus = objExcercise.stris_available
                        print( self.objBasicInfoVc?.alertStaus ?? "")
                        self.inititalSegmentSetUpWith(selectedIndex: 0)
                        self.tabBarController?.tabBar.isHidden = false

                    }
                    objWebServiceManager.hideIndicator()
                    
                    if objAppShareData.isFromNotification == true  {
                        self.callWebforReadNotification()
                    }
                    if isFromAlertList == true{
                        
                        if isfromNewContractAlert == true {
                        self.isnotificationread = objAppShareData.isreadStatus
                        isfromNewContractAlert = false

                        print(self.isnotificationread)
                        if  self.isnotificationread == "0"{
                                self.callWebforReadNotification()
                            }
                        }
                        
                    }
                }
                
                self.tabBarController?.tabBar.isHidden = false

                
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
        
       func callWebforReadNotification(){
           
           strAlertId = objAppShareData.strNotificationAlertId
           
           objWebServiceManager.requestPatch(strURL: WsUrl.ReadNotification+String(strAlertId), params:[:] , queryParams: [:], strCustomValidation: "", success: { (response) in
               print(response)
               
               let status = response["status"] as? String
               let message = response["message"] as? String ?? ""
               if status == "success"{
                   let dic = response["data"] as? [String:Any] ?? [:]
                self.tabBarController?.tabBar.isHidden = false

                   objAppShareData.isFromNotification = false
                   objAppShareData.strNotificationType = ""
                   objAppShareData.notificationDict = [:]
                   objAppShareData.isreadStatus = ""
                   isFromAlertList = false
                   
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
