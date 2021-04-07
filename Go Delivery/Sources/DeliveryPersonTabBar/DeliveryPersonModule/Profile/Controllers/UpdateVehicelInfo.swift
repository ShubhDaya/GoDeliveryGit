//
//  UpdateVehicelInfo.swift
//  Go Delivery
//
//  Created by MACBOOK-SHUBHAM V on 27.11.20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit

class UpdateVehicelInfo: UIViewController {

    //MARK:- IBOutlet  -

    @IBOutlet weak var txtVehicleMake: UITextField!
    @IBOutlet weak var txtVehicleModel: UITextField!
    @IBOutlet weak var txtVehicleColor: UITextField!
    @IBOutlet weak var txtVehiclePlateNumber: UITextField!
    @IBOutlet weak var viewHeaderForShadoe: UIView!
    @IBOutlet weak var btnUpdateVehicle: UIButton!

    //MARK:- View Life Cycles  -

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewWillAppear(_ animated: Bool) {
        self.view.endEditing(true)
        self.initialUISetup()
            
        self.txtVehicleMake.delegate = self
        self.txtVehicleModel.delegate = self
        self.txtVehicleColor.delegate = self
        self.txtVehiclePlateNumber.delegate = self
        self.checkVehicleDetails()
    }
    
    //MARK:- UiButtons Action  -

    @IBAction func btnback(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
              }
      
    
    @IBAction func btnSubmit(_ sender: Any) {
        self.validation()
    
    }
    
    
    //MARK:- Local Methods  -
    
    
    func initialUISetup(){
        
        self.btnUpdateVehicle.btnRadNonCol22()
               self.btnUpdateVehicle.setbtnshadow()
               self.viewHeaderForShadoe.layer.shadowColor = UIColor.lightGray.cgColor
               self.viewHeaderForShadoe.layer.masksToBounds = false
               self.viewHeaderForShadoe.layer.shadowOffset = CGSize(width: 0.0 , height: 5.0)
               self.viewHeaderForShadoe.layer.shadowOpacity = 0.3
               self.viewHeaderForShadoe.layer.shadowRadius = 3
        
    }

    func validation(){
        
        self.txtVehicleMake.text = self.txtVehicleMake.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        self.txtVehiclePlateNumber.text = self.txtVehiclePlateNumber.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        self.txtVehicleModel.text = self.txtVehicleModel.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        self.txtVehicleColor.text = self.txtVehicleColor.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if (txtVehicleMake.text?.isEmpty)!{
            objAppShareData.showAlert(title: kAlertTitle, message: "The Make field is required.", view: self)
            
        }else if (txtVehicleModel.text?.isEmpty)! {
            objAppShareData.showAlert(title: kAlertTitle, message: "The Model field is required.", view: self)
            
        }else if (txtVehicleColor.text?.isEmpty)! {
            objAppShareData.showAlert(title: kAlertTitle, message: "The Color field is required.", view: self)
            
        } else if (txtVehiclePlateNumber.text?.isEmpty)! {
            objAppShareData.showAlert(title: kAlertTitle, message: "The Plate Number field is required." , view: self)
            
        }     else{
            self.callwebUpdateVehicelInfo()
            print("validation without phone and dial code success")
            
        }
    }
    
    
    func checkVehicleDetails(){
          
          
          if objAppShareData.strDeliveryPersonUserdetails.strmake == ""{
                 self.txtVehicleMake.text = "NA"
             }else{
                 self.txtVehicleMake.text = objAppShareData.strDeliveryPersonUserdetails.strmake

             }
             if objAppShareData.strDeliveryPersonUserdetails.strmodele == "" {
                        self.txtVehicleModel.text = "NA"
                    }else{
                 self.txtVehicleModel.text = objAppShareData.strDeliveryPersonUserdetails.strmodele
                    }
             
             if objAppShareData.strDeliveryPersonUserdetails.strplate_number == ""{
                        self.txtVehiclePlateNumber.text = "NA"
                    }else{
                        self.txtVehiclePlateNumber.text = objAppShareData.strDeliveryPersonUserdetails.strplate_number

                    }
             if objAppShareData.strDeliveryPersonUserdetails.strcolor == ""{
                               self.txtVehicleColor.text = "NA"
                           }else{
                               self.txtVehicleColor.text = objAppShareData.strDeliveryPersonUserdetails.strcolor
                           }
      }

}

//MARK:- UITextFieldDelegate  -

extension UpdateVehicelInfo:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.txtVehicleMake{
            self.txtVehicleModel.becomeFirstResponder()
        }
        else if textField == self.txtVehicleModel{
            self.txtVehicleColor.becomeFirstResponder()
            
        }else if textField == self.txtVehicleColor{
            self.txtVehiclePlateNumber.becomeFirstResponder()
            
        }else if textField == self.txtVehiclePlateNumber{
            self.txtVehiclePlateNumber.resignFirstResponder()
        }
        return true
    }
}


//MARK:- Webservice Calling  -

extension UpdateVehicelInfo {

    func callwebUpdateVehicelInfo(){
       if !objWebServiceManager.isNetworkAvailable(){
                objWebServiceManager.hideIndicator()
                objAppShareData.showNetworkAlert(view:self)
                return
            }
            objWebServiceManager.showIndicator()
            
           self.view.endEditing(true)
      
          let   param = [
                   "is_onboarding":"false",
                    WsParam.make:self.txtVehicleMake.text ?? "",
                    WsParam.model:self.txtVehicleModel.text ?? "",
                    WsParam.plate_number:self.txtVehiclePlateNumber.text ?? "",
                    WsParam.color:self.txtVehicleColor.text ?? ""]
     
        objWebServiceManager.requestPost(strURL: WsUrl.UpdateVehicleInfo, queryParams: [:], params: param, strCustomValidation: "", showIndicator: false,  success: { (response) in
                let status = response["status"] as? String ?? ""
                let message = response["message"] as? String ?? ""
                print(param)
              
                    if status == "success"{
                        if let data = response["data"]as? [String:Any]{

                        }
                        self.callGetForMyProfile1()
        
                    }else{
                        objWebServiceManager.hideIndicator()
                        objAppShareData.showAlert(title: kAlertTitle, message: message , view: self)
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
                              
                  objAppShareData.strDeliveryPersonUserdetails.strmake = objExcercise.strmake
                  objAppShareData.strDeliveryPersonUserdetails.strmodele = objExcercise.strmodele
                  objAppShareData.strDeliveryPersonUserdetails.strcolor = objExcercise.strcolor
                  objAppShareData.strDeliveryPersonUserdetails.strplate_number = objExcercise.strplate_number

                             self.checkVehicleDetails()

                              UserDefaults.standard.set(objExcercise.stris_available, forKey: "DeliveryPersonisAvailable") //Bool
                              print(objExcercise.stris_available)
                              
                            objAlert.showAlertCallBackOk(alertLeftBtn: "Ok", title: kAlertTitle, message:"Vehicle information updated successfully", controller: self, callbackCancel: { () in
                                self.navigationController?.popViewController(animated: true)
                            })
                                             
                            
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
