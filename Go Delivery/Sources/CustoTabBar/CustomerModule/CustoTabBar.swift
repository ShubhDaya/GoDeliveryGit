//
//  CustoTabBar.swift
//  Go Delivery
//
//  Created by MACBOOK-SHUBHAM V on 22/07/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit

class CustoTabBar: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set(objAppShareData.userDetail.strUserID, forKey: UserDefaults.KeysDefault.kUserId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -4)
    
        let SelectedIndex = tabBarController?.selectedIndex

        self.view.endEditing(true)
        
        // Notification Type
        if objAppShareData.isFromNotification == true
        {
            
            let tabHome = tabBar.items![3]
            tabHome.badgeValue = "●"
        tabHome.setBadgeTextAttributes([NSAttributedString.Key.foregroundColor.self:UIColor.red], for: .normal)
   
            if objAppShareData.strNotificationType == "new_quote"
            {
                self.selectedIndex = 0
            }
            else if objAppShareData.strNotificationType == "driver_assigned" || objAppShareData.strNotificationType == "ask_for_review" || objAppShareData.strNotificationType == "delivery_pickup" || objAppShareData.strNotificationType == "delivery_inprogress" ||
                objAppShareData.strNotificationType == "delivery_delivered"
                
            {
                self.selectedIndex = 1
            }
        } else
            {
              if   objAppShareData.isFromFirebaseDynamicLink == true
                   {
                         self.selectedIndex = 0
                   }
            }
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
    }
    //Overriding this to get callback whenever its value is changes
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if let items = tabBar.items {
            items.enumerated().forEach { if $1 == item { print("your index is: \($0)") } }
        }
        print(tabBarController?.tabBar.items)

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
