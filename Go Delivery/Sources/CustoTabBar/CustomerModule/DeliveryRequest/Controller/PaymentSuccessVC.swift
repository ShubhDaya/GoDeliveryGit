//
//  PaymentSuccessVC.swift
//  Go Delivery
//
//  Created by IOS-Lokendra on 26/09/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit
import Foundation

class PaymentSuccessVC: UIViewController {

    var closerAcceptPayment:((_ isPaymentSuccess:Bool)  ->())?

    //MARK:- View Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
    }
 
    //MARK:- UiButtons -

    @IBAction func btnback(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
      @IBAction func btnBackAction(_ sender: Any) {
         self.view.endEditing(true)
        
         self.closerAcceptPayment?(true)
         self.navigationController?.popViewController(animated: true)
     }
     
}
