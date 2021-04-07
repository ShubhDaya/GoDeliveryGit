//
//  TrackDetailVc.swift
//  Go Delivery
//
//  Created by MACBOOK-SHUBHAM V on 15/08/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit

class TrackDetailVc: UIViewController {

    //MARK:- IBOutlet-
    
    @IBOutlet weak var imgDelvieryPerson: UIImageView!
    @IBOutlet weak var btnGiveReview: UIButton!
    
    
    //MARK:- View Life Cycle-

    override func viewDidLoad() {
        super.viewDidLoad()
        self.imgDelvieryPerson.setImgCircle()
        self.btnGiveReview.btnRadNonCol22()
        self.btnGiveReview.setbtnshadow()
        // Do any additional setup after loading the view.
    }
    
    
    //MARK:- UiButtons-

    @IBAction func btnGiveReview(_ sender: Any) {
        
        objAlert.showAlert(message: k_UnderDevlope, title: kAlertTitle, controller: self)
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }


}
