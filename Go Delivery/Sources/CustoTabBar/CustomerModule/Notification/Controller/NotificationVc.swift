//
//  NotificationVc.swift
//  Go Delivery
//  Created by MACBOOK-SHUBHAM V on 23/07/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.

import UIKit

var isFromAlertList:Bool = false
var isfromNewContractAlert : Bool = false

class NotificationVc: UIViewController {
    
    //MARK:- IBOutlet-
    @IBOutlet weak var tblNotification: UITableView!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var viewNoNotification: UIView!
    @IBOutlet weak var viewDeliveryPerson: UIView!
    
    //MARK:- Local Variable-

    var isDataLoading:Bool=false
    var limit:Int=20
    var offset:Int=0
    var totalRecords = Int()
    var arrAlertList = [alertModel]()
    var Next = ""
    
    //MARK:- View Life Cycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.endEditing(true)
        self.viewNoNotification.isHidden = true
        self.tblNotification.dataSource = self
        self.tblNotification.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isfromNewContractAlert = false
        isfromAllTab = true // Api run in profile base class for my profile

        self.view.endEditing(true)
        self.initialUISetup()
        isFromAlertList = false
        tabBarItem.badgeValue = nil
        
        if objAppShareData.userDetail.strUserType == "delivery_person"{
            
            self.viewDeliveryPerson.isHidden = true
            self.arrAlertList.removeAll()
            self.limit = 20
            self.offset = 0
            self.callWSForAlertList()
        }else{
            self.viewDeliveryPerson.isHidden = true
            self.arrAlertList.removeAll()
            self.limit = 20
            self.offset = 0
            self.callWSForAlertList()
         }
       }
    
    //MARK:- Local Methods  -

    func initialUISetup(){
        viewHeader.layer.shadowColor = UIColor.lightGray.cgColor
        viewHeader.layer.masksToBounds = false
        viewHeader.layer.shadowOffset = CGSize(width: 0.0 , height: 5.0)
        viewHeader.layer.shadowOpacity = 0.3
        viewHeader.layer.shadowRadius = 3
    }
    
    func utcToLocal(dateStr: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        if let date = dateFormatter.date(from: dateStr) {
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            return dateFormatter.string(from: date)
        }
        return nil
    }
    
    func timeAgoSinceDate(date:NSDate,CurrentDate:NSDate, numericDates:Bool) -> String {
           // Get time diffrence between two time .weeakOfYear not used
           let calendar = NSCalendar.current
           let now = CurrentDate
           let earliest = now.earlierDate(date as Date)
           let latest = (earliest == now as Date) ? date : now
           
         let unitsSet : Set<Calendar.Component> = [.year,.month,.day, .hour, .minute, .second, .nanosecond]
           
         let components:NSDateComponents = calendar.dateComponents(unitsSet, from: earliest, to: latest as Date) as NSDateComponents
        
         
        if (components.year >= 2) {
               return "\(components.year) years"
           }
           else if (components.year == 1){
               if (numericDates){
                   return "1 year"
               } else {
                   return "Last year"
               }
           }
           else if (components.month >= 2) {
               return "\(components.month) months"
           }
           else if (components.month == 1){
               if (numericDates){
                   return "a month"
               } else {
                   return "Last month"
               }
           }

           else if (components.day >= 2) {
               return "\(components.day) days"
           } else if (components.day == 1){
               if (numericDates){
                   return "1 day"
               } else {
                   return "Yesterday"
               }
           } else if (components.hour >= 2) {
               return "\(components.hour) hours"
           } else if (components.hour == 1){
               if (numericDates){
                   return "1 hour"
               } else {
                   return "hour"
               }
           } else if (components.minute >= 2) {
               return "\(components.minute) minutes"
           } else if (components.minute == 1){
               if (numericDates){
                   return "1 minute"
               } else {
                   return "1 minute"
               }
           } else if (components.second >= 3) {
               return "\(components.second) secs"
           } else {
               return "1 sec"
           }
       }
}

//MARK:- Tableview delegate methods-

extension NotificationVc: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return  arrAlertList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cellIdentifier = "NotificationCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! NotificationCell?
        if arrAlertList.count > 0 {
            
           let obj1 = self.arrAlertList[indexPath.row]

                let createdTime = obj1.strcreated_at
                let currentTime = obj1.strcurrent_time
                                
                                if createdTime != ""{
                                    
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                                    let createdTime = dateFormatter.date(from: createdTime)

                                    let dateFormatter1 = DateFormatter()
                                    dateFormatter1.dateFormat = "yyyy-MM-dd HH:mm:ss"
                                    let currentTime = dateFormatter1.date(from: currentTime)
                                    
                                    
                                    let changeTime = self.timeAgoSinceDate(date: createdTime! as NSDate, CurrentDate: currentTime as! NSDate, numericDates: true)
                                    
                                    print(changeTime)
                                    cell?.lblTimeAgo.text = "\(changeTime) ago"
                                    
                                }else{
                                    
                                }
    
            let isread = obj1.stris_read
            if isread == "1"{
                cell?.viewForBGcolor.backgroundColor = UIColor.clear
                
            }else{
                cell?.viewForBGcolor.backgroundColor = #colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.2783872003)
            }
            let strimage = obj1.strPhoto
            let urlImg = URL(string: strimage)
            cell?.imgView.sd_setImage(with: urlImg, placeholderImage:#imageLiteral(resourceName: "notification_ico"))
            
            let notificationType = obj1.strtype
            switch ( notificationType ) {
                
            case "new_quote":
                
                cell?.lblTitle.text = "Admin sent a \(obj1.strdeliverytype) quote for your delivery request.";
                break;
                
            case "driver_assigned":
                
                cell?.lblTitle.text = "Admin has assigned delivery person \(obj1.strdelivery_person_first_name) \(obj1.strdelivery_person_last_name) having vehicle info \(obj1.strplate_number) \(obj1.strmake) \(obj1.strmodel) (\(obj1.strcolor)) for your \(obj1.strdeliverytype).";
                break;
                
            case "delivery_pickup":
                
                cell?.lblTitle.text = "\(obj1.strdelivery_person_first_name) \(obj1.strdelivery_person_last_name) having vehicle info \(obj1.strplate_number) \(obj1.strmake) \(obj1.strmodel) (\(obj1.strcolor)) has picked your \(obj1.strdeliverytype).";
                break;
                
            case "delivery_inprogress":
                
                cell?.lblTitle.text = "Your \(obj1.strdeliverytype) is in progress and will be delivered soon.";
                break;
                
            case "ask_for_review":
                cell?.lblTitle.text = "\(obj1.strdelivery_person_first_name) \(obj1.strdelivery_person_last_name) having vehicle info \(obj1.strplate_number) \(obj1.strmake) \(obj1.strmodel) (\(obj1.strcolor)) requested you to review the \(obj1.strdeliverytype).";
                break;
                
            case "delivery_delivered":
                
                cell?.lblTitle.text = "Your \(obj1.strdeliverytype) has been delivered."
                break;

            // Delivery person side Alert Type  -
              
            case "new_order":
                               
            cell?.lblTitle.text = "You've got a new delivery order."
            break;
                     
            case "new_contract_upload":
                                          
            cell?.lblTitle.text = "Admin has updated the contract document. Please review and upload the new signed contract for the same to keep your account active."
                       break;
                              
            case "delivery_review":
                                          
                cell?.lblTitle.text = "\(obj1.strcustomer_first_name) \(obj1.strcustomer_last_name) gave review for your \(obj1.strdeliverytype)."
                       break;
            
            case "profile_approved":
                                          
                cell?.lblTitle.text = "Your profile has been approved now."
                break;
                
            default:
                print("sdfsdfs")
            }
            
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
        let cellIdentifier = "NotificationCell"
               let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! NotificationCell?
        if arrAlertList.count > 0 {
            let obj1 = self.arrAlertList[indexPath.row]
             
             let NotificationType = obj1.strtype
             if NotificationType == "new_quote" ||  NotificationType == "driver_assigned" ||  NotificationType == "delivery_pickup" ||  NotificationType == "delivery_inprogress" ||  NotificationType == "ask_for_review" || NotificationType == "delivery_delivered" {
                 
                 let vc = UIStoryboard.init(name: "DeliveryQuotes", bundle: nil).instantiateViewController(withIdentifier: "DeliveryDetailVC")as! DeliveryDetailVC
                 
                 isFromAlertList = true
                print(obj1.strreference_id)
                 vc.deliveryId = obj1.strreference_id
                 vc.isFromAlertNewQuoteAdded = obj1.strtype
                 vc.isnotificationread = obj1.stris_read
                 objAppShareData.strNotificationAlertId = obj1.stralertID
                 self.navigationController?.pushViewController(vc, animated: true)
             }
             else if NotificationType == "new_order" || NotificationType == "profile_approved"{
                
                 isFromAlertList = true
                 objAppShareData.strNotificationAlertId = obj1.stralertID
                 objAppShareData.isreadStatus = obj1.stris_read
                 tabBarController?.selectedIndex = 0

             }
             else if NotificationType == "new_contract_upload"{
                     isfromNewContractAlert = true
                     isFromAlertList = true
                     objAppShareData.strNotificationAlertId = obj1.stralertID
                     objAppShareData.isreadStatus = obj1.stris_read
                     tabBarController?.selectedIndex = 3

                 }
             
             else if NotificationType == "delivery_review" {
                 
                 let vc = UIStoryboard.init(name: "CompleteOrder", bundle: nil).instantiateViewController(withIdentifier: "CompleteOrderDetailVc")as! CompleteOrderDetailVc
                            
                            isFromAlertList = true
                            vc.deliveryId = obj1.strreference_id
                            vc.isnotificationread = obj1.stris_read
                            objAppShareData.strNotificationAlertId = obj1.stralertID
                            self.navigationController?.pushViewController(vc, animated: true)
             }
        }
    }
}

//MARK:- Webservices calling   -
extension NotificationVc{
    
    func callWSForAlertList(){
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAppShareData.showNetworkAlert(view:self)
            return
        }
        objWebServiceManager.showIndicator()
        
        objWebServiceManager.requestGet(strURL: WsUrl.AlertList+"offset="+String(self.offset)+"&limit="+String(self.limit) , params:[:], queryParams: [:], strCustomValidation: "", success: { (response) in
            let status = response["status"] as? String ?? ""
            let message = response["message"] as? String ?? ""
            
            if status == "success"{
                objWebServiceManager.hideIndicator()
                if let data = response["data"] as? [String:Any]{
                    let Nodata = data["data_found"] as? Int ?? -1
                    self.totalRecords = data["total_records"] as? Int ?? 0
                    if  let paging = data["paging"] as? [String:Any]{
                        self.Next = paging["next"] as? String ?? ""
                        print(self.Next)
                    }
                    
                    if let arrTenantList = data["alerts_list"]as? [[String:Any]]{
                        for dic in arrTenantList{
                            let obj = alertModel.init(dict: dic)
                            self.arrAlertList.append(obj)
                            print(obj)
                        }
                    }
                    print(self.arrAlertList.count)
                    if Nodata == 0{
                        if self.arrAlertList.count == 0{
                            self.viewNoNotification.isHidden = false
                            
                        }else{
                            self.viewNoNotification.isHidden = true
                        }
                    }else{
                        self.viewNoNotification.isHidden = true
                        
                    }
                }
                
                self.tblNotification.reloadData()
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


//MARK:- Paggination Logic-
extension NotificationVc{
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isDataLoading = false
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if velocity.y < 0 {
            print("up")
        }else{
            if ((tblNotification.contentOffset.y + tblNotification.frame.size.height) >= tblNotification.contentSize.height)
            {
                if !isDataLoading{
                    isDataLoading = true
                    self.offset = self.offset+self.limit
                    print(totalRecords)
                    print(Next)
                    if Next != ""  {
                        self.callWSForAlertList()
                    }else {
                        print("All records fetched")
                    }
                    
                }
            }
        }
    }
}




