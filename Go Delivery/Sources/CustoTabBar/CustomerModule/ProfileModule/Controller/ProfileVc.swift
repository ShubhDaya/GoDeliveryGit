//
//  ProfileVc.swift
//  Go Delivery
//
//  Created by MACBOOK-SHUBHAM V on 23/07/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit
import SDWebImage
var isFromProfile = false

class ProfileVc: UIViewController {
    
    //MARK:- IBOutlets -
    
    @IBOutlet weak var imgEmail: UIImageView!
    @IBOutlet weak var lblMobileNumber: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblemail: UILabel!
    @IBOutlet weak var imgProfile: customImage!
    @IBOutlet weak var viewProfileimg: UIView!
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var viewPhoneNumber: UIView!
    
    //MARK:- Local Variables -
    
    var ProfileData : MyProfileModel?
    var UpdatedProfile = false
    
    //MARK:- View Life Cycles  -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewProfileimg.setShadowAllView5()
        callWSForMyProfile()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isFromProfile = false
        self.viewProfileimg.setShadowAllView5()
        self.imgEmail.image =  UIImage(named: "mail_ico")
        if UpdatedProfile == true {
            callWSForMyProfile()
            UpdatedProfile = false
        }
    }
    
    //MARK:- Buttons Action -
    
    @IBAction func btnSettings(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SettingsVc") as! SettingsVc
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnEditProfile(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditProfile") as! EditProfile
        vc.Mydata = ProfileData
        isFromProfile = true
        vc.closerUpdate = {
            Updateprofile in
            self.UpdatedProfile = Updateprofile
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK:- Webservice calling  -

extension ProfileVc {
    
    func callWSForMyProfile(){
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
        objWebServiceManager.requestGet(strURL: WsUrl.myprofile , params: param, queryParams: [:], strCustomValidation: "", success: { (response) in
            print(response)
            let status = response["status"] as? String ?? ""
            let message = response["message"] as? String ?? ""
           
            if status == "success"{
                if let data = response["data"] as? [String:Any]{
                
                    self.UpdatedProfile = false
                    if let dictExcercise = data["profile_details"] as? [String:Any]{
                        let objExcercise = MyProfileModel.init(dict: dictExcercise)
                        
                        self.ProfileData = objExcercise
                        self.lblemail.text = objExcercise.strEmail
                        self.lblUserName.text = "\(objExcercise.strUserFirstName) \(objExcercise.strUserlastName)"
                        self.lblMobileNumber.text = "\(objExcercise.strCountry_code) - \(objExcercise.strPhone_number)"
                        
                        let strimage = objExcercise.strProfile_picture
                        let urlImg = URL(string: strimage)
                        self.imgProfile.sd_setImage(with: urlImg, placeholderImage:UIImage(named: "user_placeholder_img"))
                        
                        if objExcercise.strEmail == ""{
                            
                            self.viewEmail.isHidden = true
                        }else{
                            self.viewEmail.isHidden = false
                        }
                        if objExcercise.strPhone_number == ""{
                            
                            self.viewPhoneNumber.isHidden = true
                        }else{
                            self.viewPhoneNumber.isHidden = false
                        }
                        
                    }
                    objWebServiceManager.hideIndicator()
                    //  self.setDefaultdata()
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
