//
//  BasicInfoVc.swift
//  Go Delivery
//
//  Created by MACBOOK-SHUBHAM V on 23.11.20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit
import SJSegmentedScrollView

class BasicInfoVc: UIViewController {

    //MARK:- IBOutlet-
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblMobile: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblContry: UILabel!
    @IBOutlet weak var imgIsAvaliblity: UIImageView!
    
    //MARK:- Local Variables-

    var objprofileDetails = MyProfileModel(dict: [:])
    var AvailableStatus = -1
    var alertStaus = ""
    var check = true
   
    
    //MARK:- View Life Cycle -

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.SetDefaultData()
        self.alertStaus = UserDefaults.standard.string(forKey: "DeliveryPersonisAvailable") ?? ""
        self.checkNotificationStatus()
   
    }
    

    //MARK:- UIButton Action -

    @IBAction func btnToggleOnOff(_ sender: Any) {
  
    check = !check
                     if alertStaus == "0"{
                        
                        imgIsAvaliblity.image = #imageLiteral(resourceName: "ON_TOGGLE_ICO")
                         AvailableStatus = 1
                         print(" for on \(AvailableStatus)")
                         self.view.endEditing(true)
                         
                     } else if alertStaus == "1"
                     {
                         imgIsAvaliblity.image = #imageLiteral(resourceName: "OFF_TOGGLE_ICO")
                         AvailableStatus = 0
                         print(" for off \(AvailableStatus)")

                     }
        
        self.callWebforchangeAvailablestatus()
    }
    
    //MARK:- Local Methods -

      func checkNotificationStatus(){
               
               if alertStaus == "1"{
                   imgIsAvaliblity.image = #imageLiteral(resourceName: "ON_TOGGLE_ICO")
               }else if alertStaus == "0" {
                   imgIsAvaliblity.image = #imageLiteral(resourceName: "OFF_TOGGLE_ICO")
        }
    }
    
    func SetDefaultData(){
        
        if objAppShareData.strDeliveryPersonUserdetails.strEmail == ""{
                   self.lblEmail.text = "NA"
               }else{
                   self.lblEmail.text = objAppShareData.strDeliveryPersonUserdetails.strEmail
               }
               if objAppShareData.strDeliveryPersonUserdetails.strCountry_code == "" && objAppShareData.strDeliveryPersonUserdetails.strPhone_number == ""{
                          self.lblMobile.text = "NA"
                      }else{
                   self.lblMobile.text = "\(objAppShareData.strDeliveryPersonUserdetails.strCountry_code) - \(objAppShareData.strDeliveryPersonUserdetails.strPhone_number)"

                      }
               
               if objAppShareData.strDeliveryPersonUserdetails.strcountry == ""{
                          self.lblContry.text = "NA"
                      }else{
                          self.lblContry.text = objAppShareData.strDeliveryPersonUserdetails.strcountry

                      }
               if objAppShareData.strDeliveryPersonUserdetails.strlocation == ""{
                                 self.lblCity.text = "NA"
                             }else{
                                 self.lblCity.text = objAppShareData.strDeliveryPersonUserdetails.strlocation
                             }
        
    }
}

//MARK:- SJSegmentedViewControllerViewSource -

extension BasicInfoVc: SJSegmentedViewControllerViewSource {
func viewForSegmentControllerToObserveContentOffsetChange() -> UIView {
    return self.view
}
}


//MARK:- Webservice Calling  -

extension BasicInfoVc {
    
    func callWSForMyProfile(){
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAppShareData.showNetworkAlert(view:self)
            return
        }
        objWebServiceManager.showIndicator()
        objWebServiceManager.requestGet(strURL: WsUrl.myprofile , params:[:], queryParams: [:], strCustomValidation: "", success: { (response) in
            print(response)
            //let data_found = response["data_found"] as? Int
            let status = response["status"] as? String ?? ""
            let message = response["message"] as? String ?? ""
            
            if status == "success"{
                if let data = response["data"] as? [String:Any]{
                
                    if let dictExcercise = data["profile_details"] as? [String:Any]{
                        let objExcercise = MyProfileModel.init(dict: dictExcercise)
                     
                        self.lblEmail.text = objExcercise.strEmail
                        self.lblMobile.text = objExcercise.strphone_number
                        self.lblContry.text = objExcercise.strcountry
     
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
                               
                self.alertStaus = UserDefaults.standard.string(forKey: "DeliveryPersonisAvailable") ?? ""
                               print(self.alertStaus)
                
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
    
}
