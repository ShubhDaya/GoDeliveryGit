//
//  DeliveryPersonTabBar.swift
//  Go Delivery
//  Created by MACBOOK-SHUBHAM V on 02.11.20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.

import UIKit

class DeliveryPersonTabBar: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set(objAppShareData.userDetail.strUserID, forKey: UserDefaults.KeysDefault.kUserId)
    }
    
    override func viewDidAppear(_ animated: Bool) {
          super.viewDidAppear(animated)
          for vc in self.viewControllers! {
              if #available(iOS 13.0, *) {
                  vc.tabBarItem.imageInsets = UIEdgeInsets(top: 1, left: 0, bottom:2, right: -2)
              }else{
                  vc.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom:-5, right: 0)
              }
          }
        
        // Notification Type
              if objAppShareData.isFromNotification == true
              {
                  
                  let tabHome = tabBar.items![2]
                  tabHome.badgeValue = "●"
              tabHome.setBadgeTextAttributes([NSAttributedString.Key.foregroundColor.self:UIColor.red], for: .normal)
         
              //new_contract_upload
                
                if objAppShareData.strNotificationType == "new_order" || objAppShareData.strNotificationType == "profile_approved"
                  {
                      self.selectedIndex = 0
                  }
                  else if objAppShareData.strNotificationType == "new_contract_upload"
                  {
                    self.tabBarController?.tabBar.isHidden = false 
                    self.selectedIndex = 3
                  }
                else if objAppShareData.strNotificationType == "delivery_review"
                {
                    self.selectedIndex = 1
                }
              } else
                  {
                    if objAppShareData.isFromFirebaseDynamicLink == true
                    {
                        // There is no dymanic link in delivery person side 
                    }
                  }
      }
    
  
    //Overriding this to get callback whenever its value is changes
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if let items = tabBar.items {
            items.enumerated().forEach { if $1 == item { print("your index is: \($0)") } }
        }
        if item == (tabBar.items)![3] {
        }
    }
    
    func selectItem(withIndex index: Int) {
        
        if  let controller = tabBarController,
            let tabBar = tabBarController?.tabBar,
            let items = tabBarController?.tabBar.items
        {
            guard index < items.count else { return }
            controller.selectedIndex = index
            controller.tabBar(tabBar, didSelect: items[index])
        }
     }
}
