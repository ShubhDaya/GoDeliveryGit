//
//  VehicleVC.swift
//  Go Delivery
//
//  Created by MACBOOK-SHUBHAM V on 23.11.20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit
import SJSegmentedScrollView

class VehicleVC: UIViewController {

    //MARK:- Local Variables -
    var objprofileDetails = MyProfileModel(dict: [:])

    //MARK:- IBOutlet -

    @IBOutlet weak var lblVehicleMakeName: UILabel!
    @IBOutlet weak var lblVehicleModelName: UILabel!
   
    @IBOutlet weak var lblVehicleNumberPlateName: UILabel!
    @IBOutlet weak var lblVehicleColorName: UILabel!
    @IBOutlet weak var btnEditVehicle: UIButton!
    
   //MARK:- View Life Cycle -

    override func viewDidLoad() {
        super.viewDidLoad()
  
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.btnEditVehicle.setbtnshadow()
        self.btnEditVehicle.btnRadNonCol22()
        self.checkVehicleDetails()
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    //MARK:- Button Action -

    @IBAction func btnEditVehicle(_ sender: Any) {
       let vc = self.storyboard?.instantiateViewController(withIdentifier: "UpdateVehicelInfo") as! UpdateVehicelInfo
       self.navigationController?.pushViewController(vc, animated: true)
   }
    
    
    //MARK:- Local Methods -

    func checkVehicleDetails(){
        
        
        if objAppShareData.strDeliveryPersonUserdetails.strmake == ""{
               self.lblVehicleMakeName.text = "NA"
           }else{
               self.lblVehicleMakeName.text = objAppShareData.strDeliveryPersonUserdetails.strmake

           }
           if objAppShareData.strDeliveryPersonUserdetails.strmodele == "" {
                      self.lblVehicleModelName.text = "NA"
                  }else{
               self.lblVehicleModelName.text = objAppShareData.strDeliveryPersonUserdetails.strmodele
                  }
           
           if objAppShareData.strDeliveryPersonUserdetails.strplate_number == ""{
                      self.lblVehicleNumberPlateName.text = "NA"
                  }else{
                      self.lblVehicleNumberPlateName.text = objAppShareData.strDeliveryPersonUserdetails.strplate_number

                  }
           if objAppShareData.strDeliveryPersonUserdetails.strcolor == ""{
                             self.lblVehicleColorName.text = "NA"
                         }else{
                             self.lblVehicleColorName.text = objAppShareData.strDeliveryPersonUserdetails.strcolor
                         }
    }

}

//MARK:- SJSegmentedViewControllerViewSource -

extension VehicleVC: SJSegmentedViewControllerViewSource {
func viewForSegmentControllerToObserveContentOffsetChange() -> UIView {
    return self.view
}
}


//MARK:- Webservice Calling  -

extension VehicleVC {
    
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
                     
                        self.lblVehicleMakeName.text = objExcercise.strmake
                        self.lblVehicleModelName.text = objExcercise.strmodele
                        self.lblVehicleNumberPlateName.text = objExcercise.strplate_number
                        self.lblVehicleColorName.text = objExcercise.strcolor
        
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
