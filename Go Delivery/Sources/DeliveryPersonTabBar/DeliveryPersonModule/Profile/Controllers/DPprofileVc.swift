//
//  profileVc.swift
//  Go Delivery
//
//  Created by MACBOOK-SHUBHAM V on 09.11.20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit
import SJSegmentedScrollView
import HCSStarRatingView

var isFromDeliveryPersonProfile = false

class DPprofileVc: UIViewController {
    
    //MARK:- Local Variables -
    var objprofileDetails = MyProfileModel(dict: [:])
    var ProfileData : MyProfileModel?
    var UpdatedProfile = false
    
    //MARK:- IBOutlet -
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var imgGradientHeader: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var viewProfileView: UIView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var userRating: HCSStarRatingView!
   
    //MARK:- View Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.initialUISetup()
        self.fetchDefaultData()
        self.userRating.allowsHalfStars = false
        self.userRating.maximumValue = 5
        self.userRating.minimumValue = 0
        userRating.isUserInteractionEnabled = false
        if UpdatedProfile == true {
            callWSForMyProfile()
            UpdatedProfile = false
        }
    }
     
    //MARK:- UiButtons -
    @IBAction func btnLogout(_ sender: Any) {
        
        objAlert.showAlertCallBackother(alertLeftBtn: "No", alertRightBtn: "Yes", title: kAlertTitle, message: "Do you want to Logout?", controller: self, callback: {_ in
                 self.callWebForLogout()
             }, callbackCancel: { () in
        })
    }
    
    @IBAction func btnSetting(_ sender: Any) {
         let vc = UIStoryboard.init(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "SettingsVc") as! SettingsVc
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnReviewList(_ sender: Any) {
           let vc = self.storyboard?.instantiateViewController(withIdentifier: "reviewListVc") as! reviewListVc
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btneditProfile(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileDeliPerson") as! EditProfileDeliPerson
               vc.Mydata = ProfileData
               isFromDeliveryPersonProfile = true
               vc.closerUpdate = {
                   Updateprofile in
                   self.UpdatedProfile = Updateprofile
               }
               self.navigationController?.pushViewController(vc, animated: true)
      }
    
    //MARK:- Local Methods -
    func initialUISetup(){
        
        self.viewHeader.setViewRadiusbottom()
             self.imgGradientHeader.setimgRadiusbottom()
             self.imgProfile.setImgCirclered()
             self.viewProfileView.setviewCircle()
    }
    func fetchDefaultData(){
        self.lblUserName.text = "\(objAppShareData.strDeliveryPersonUserdetails.strUserFirstName) \(objAppShareData.strDeliveryPersonUserdetails.strUserMiddleName) \(objAppShareData.strDeliveryPersonUserdetails.strUserlastName)"
              let img = objAppShareData.strDeliveryPersonUserdetails.strProfile_picture
              let urlImg = URL(string: img)
              self.imgProfile.sd_setImage(with: urlImg, placeholderImage:UIImage(named: "user_placeholder_img"))
              let revrating = objAppShareData.strDeliveryPersonUserdetails.strrating
              self.userRating.value = CGFloat(Int(revrating) ?? 0)
    }
}

//MARK:- Webservice Calling  -
    extension DPprofileVc {
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
}

extension DPprofileVc {
    
    func callWSForMyProfile(){
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAppShareData.showNetworkAlert(view:self)
            return
        }
        
        print("Api calling in DPProfileVc")
        objWebServiceManager.showIndicator()
        objWebServiceManager.requestGet(strURL: WsUrl.myprofile , params:[:], queryParams: [:], strCustomValidation: "", success: { (response) in
            print(response)
            let status = response["status"] as? String ?? ""
            let message = response["message"] as? String ?? ""
            
            if status == "success"{
                if let data = response["data"] as? [String:Any]{
                
                    if let dictExcercise = data["profile_details"] as? [String:Any]{
                        let objExcercise = MyProfileModel.init(dict: dictExcercise)
                     self.tabBarController?.tabBar.isHidden = false
        
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
