//
//  AddVehicleInfoVc.swift
//  Go Delivery
//  Created by MACBOOK-SHUBHAM V on 24.11.20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit

class AddVehicleInfoVc: UIViewController {

    
    //MARK:- IBOutlet  -

    @IBOutlet weak var txtVehicleMake: UITextField!
    @IBOutlet weak var txtVehicleModel: UITextField!
    @IBOutlet weak var txtVehicleColor: UITextField!
    @IBOutlet weak var txtVehicleNumber: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
 
    //MARK:- View Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewWillAppear(_ animated: Bool) {
        self.view.endEditing(true)
        self.txtVehicleMake.delegate = self
        self.txtVehicleModel.delegate = self
        self.txtVehicleColor.delegate = self
        self.txtVehicleNumber.delegate = self
        self.btnSubmit.btnRadNonCol22()
    }
    
    
    //MARK:- UIButtons -

    @IBAction func btnback(_ sender: Any) {
        self.view.endEditing(true)

          for controller in self.navigationController!.viewControllers as Array {
                     if controller.isKind(of: MainInitial_VC.self) {
                     _ = self.navigationController!.popToViewController(controller, animated: true)
                     break
                     }
              }
      }
    
    @IBAction func btnSubmit(_ sender: Any) {
        self.view.endEditing(true)
        self.validation()
    }
    
    //MARK:- Local Methods -

    func validation(){
        
        self.txtVehicleMake.text = self.txtVehicleMake.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        self.txtVehicleNumber.text = self.txtVehicleNumber.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        self.txtVehicleModel.text = self.txtVehicleModel.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        self.txtVehicleColor.text = self.txtVehicleColor.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if (txtVehicleMake.text?.isEmpty)!{
            objAppShareData.showAlert(title: kAlertTitle, message: "The Make field is required.", view: self)
            
        }else if (txtVehicleModel.text?.isEmpty)! {
            objAppShareData.showAlert(title: kAlertTitle, message: "The  Model field is required.", view: self)
            
        }else if (txtVehicleColor.text?.isEmpty)! {
            objAppShareData.showAlert(title: kAlertTitle, message: "The Color field is required.", view: self)
            
        } else if (txtVehicleNumber.text?.isEmpty)! {
            objAppShareData.showAlert(title: kAlertTitle, message: "The Plate Number field is required." , view: self)
            
        }     else{
            self.view.endEditing(true)

            self.callWebForUpLoadVehicleINfo()
            print("validation without phone and dial code success")
            
        }
    }

}


//MARK:- UITextFieldDelegate -

extension AddVehicleInfoVc:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.txtVehicleMake{
            self.txtVehicleModel.becomeFirstResponder()
        }
        else if textField == self.txtVehicleModel{
            self.txtVehicleColor.becomeFirstResponder()
            
        }else if textField == self.txtVehicleColor{
            self.txtVehicleNumber.becomeFirstResponder()
            
        }else if textField == self.txtVehicleNumber{
            self.txtVehicleNumber.resignFirstResponder()
        }
        return true
    }
}


//MARK:- Webservice Calling -

extension AddVehicleInfoVc {
    
    func callWebForUpLoadVehicleINfo(){
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAppShareData.showNetworkAlert(view:self)
            return
        }
        objWebServiceManager.showIndicator()
        
       self.view.endEditing(true)
       
        let param = ["is_onboarding":"true",
                            WsParam.make:self.txtVehicleMake.text ?? "",
                            WsParam.model:self.txtVehicleModel.text ?? "",
                            WsParam.plate_number:self.txtVehicleNumber.text ?? "",
                            WsParam.color:self.txtVehicleColor.text ?? ""] as [String : Any]

        objWebServiceManager.requestPost(strURL: WsUrl.UpdateVehicleInfo, queryParams: [:], params: param, strCustomValidation: "", showIndicator: false, success: { (response) in
        let status = response["status"] as? String ?? ""
        let message = response["message"] as? String ?? ""
        print(param)
      
            if status == "success"{
                objWebServiceManager.hideIndicator()
                if let data = response["data"]as? [String:Any]{

                }
                isfromContractApprovedcheck = true

            let objVc = UIStoryboard.init(name: "Main", bundle: nil) .instantiateViewController(withIdentifier: "ApplicationApprovedStatusVC")as! ApplicationApprovedStatusVC
                             self.navigationController?.pushViewController(objVc, animated: true)


            }else{
                objWebServiceManager.hideIndicator()
                objAppShareData.showAlert(title: kAlertTitle, message: message , view: self)
            }
        }, failure: { (error) in
            // print(error)
            objWebServiceManager.hideIndicator()
            objAppShareData.showAlert(title: kAlertTitle, message: kErrorMessage, view: self)
        })
    }

}
