//
//  MainInitial_VC.swift
//  Breath
//
//  Created by Narendra-macbook on 06/05/20.
//  Copyright © 2020 MINDIII. All rights reserved.
//

import UIKit
import UserNotificationsUI
import NotificationCenter
import UserNotifications

class MainInitial_VC: UIViewController {
    
    //MARK:- IBOutlet-
    
    @IBOutlet weak var btnSignIn: UIButton!
    @IBOutlet weak var btnSignup: UIButton!
    @IBOutlet weak var btnContinue: customButton!
    @IBOutlet weak var vwUsers: UIView!
    @IBOutlet weak var ViewactiveDelivery: UIView!
    @IBOutlet weak var viewActiveCustomer: UIView!
    
    //MARK:- View lifecycle methods-
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ViewactiveDelivery.isHidden = true
        viewActiveCustomer.isHidden = true
        self.initalUISetup()
        vwUsers.setViewShadowMoreCornerRadius()
        viewActiveCustomer.setViewCornerRadius()
        ViewactiveDelivery.setViewCornerRadius()
        btnContinue.setbtnshadow()
        objAppShareData.strUserType = "delivery_person"
        ViewactiveDelivery.isHidden = false
        viewActiveCustomer.isHidden = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
 
    //MARK:- Custom Functions-
    
    func initalUISetup(){
    }
      
    //MARK:- Button Actions-
    
    @IBAction func btnContiue(_ sender: Any) {
        self.view.endEditing(true)
                
        if objAppShareData.strUserType == ""{
            objAlert.showAlert(message: "Please select user type.", title: kAlertTitle, controller: self)
            
        }else{
            let objVc = UIStoryboard.init(name: "Main", bundle: nil) .instantiateViewController(withIdentifier: "Login_VC")as! Login_VC
                self.navigationController?.pushViewController(objVc, animated: true)
        }
    }
    
    @IBAction func btnDeliveryPerson(_ sender: Any) {
        self.view.endEditing(true)
        ViewactiveDelivery.isHidden = false
        viewActiveCustomer.isHidden = true
        objAppShareData.strUserType = "delivery_person"
    }
    
    @IBAction func btnCustomer(_ sender: Any) {
        self.view.endEditing(true)
        ViewactiveDelivery.isHidden = true
        viewActiveCustomer.isHidden = false
        objAppShareData.strUserType = "customer"

    }
}
