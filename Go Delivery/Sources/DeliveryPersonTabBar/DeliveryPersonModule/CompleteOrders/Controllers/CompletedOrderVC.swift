//
//  CompletedOrderVC.swift
//  Go Delivery
//
//  Created by MACBOOK-SHUBHAM V on 09.11.20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit

class CompletedOrderVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    //MARK:- IBOutlet-
    
    @IBOutlet weak var viewUnderDevelopment: UIView!
    @IBOutlet weak var viewNodataFound: UIView!
    @IBOutlet weak var viewHeader: UIView!

    @IBOutlet weak var viewShowDeliveryTypeImage: UIView!
    
    @IBOutlet weak var imgDeliveryTypeView: UIImageView!
  
    @IBOutlet weak var tblCompleteOrder: UITableView!
    
    //MARK:- Local Variables -
    
    var isDataLoading:Bool=false
    var limit:Int=20
    var offset:Int=0
    var totalRecords = Int()
    var arrCompleteOrderList = [CompletOrderModel]()
    var Next = ""
    
    //MARK:- View Life Cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if objAppShareData.isFromNotification{
            if objAppShareData.strNotificationType == "delivery_review" {
                
                let vc = UIStoryboard.init(name: "CompleteOrder", bundle: Bundle.main).instantiateViewController(withIdentifier: "CompleteOrderDetailVc") as? CompleteOrderDetailVc
                var property_id = 0
                if let id = objAppShareData.notificationDict["reference_id"] as? Int{
                    property_id = id
                }else if let id = objAppShareData.notificationDict["reference_id"] as? String{
                    property_id = Int(id)!
                }
                vc?.deliveryId = String(property_id)
                self.navigationController?.pushViewController(vc!, animated: false)
            }
        }else{
            if  objAppShareData.isFromFirebaseDynamicLink == true
                   {
                    // Pending
                   }
            }
        self.tblCompleteOrder.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.initialUISetup()
        isFromAlertList = false
        self.viewNodataFound.isHidden = false
        self.viewShowDeliveryTypeImage.isHidden = true
        isfromTrackDelivery = false
        self.arrCompleteOrderList.removeAll()
        self.limit = 20
        self.offset = 0
        self.callWSForDeliveryList()
        
    }
    
    //MARK:-Buttons -

    @IBAction func btnCloseShowDeliveryTypeView(_ sender: Any) {
    self.viewShowDeliveryTypeImage.isHidden = true
    self.tabBarController?.tabBar.isHidden = false
    }
    
    
    //MARK:- Local Methods -
    
    
    func changeDateFormatter(date:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let dt = dateFormatter.date(from: date) //{
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "d MMM, yyyy,"
        return dateFormatter.string(from: dt ?? Date())
    }
    
    func changeDateForTime(date:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
        dateFormatter.dateFormat = "HH:mm:ss"
        let dt = dateFormatter.date(from: date) //{
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: dt ?? Date())
    }
    
    func utcToLocal(dateStr: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
        dateFormatter.dateFormat = "HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        if let date = dateFormatter.date(from: dateStr) {
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = "hh:mm a"
            return dateFormatter.string(from: date)
        }
        return nil
    }

    
    func initialUISetup(){
        viewHeader.layer.shadowColor = UIColor.lightGray.cgColor
        viewHeader.layer.masksToBounds = false
        viewHeader.layer.shadowOffset = CGSize(width: 0.0 , height: 5.0)
        viewHeader.layer.shadowOpacity = 0.3
        viewHeader.layer.shadowRadius = 3
       }
    
    
    //MARK:- TableView Datasource/Delegate   -
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCompleteOrderList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompleteOrderCell", for: indexPath) as! CompleteOrderCell
        if arrCompleteOrderList.count > 0 {
            let obj1 = self.arrCompleteOrderList[indexPath.row]
            let objdate = obj1.strdelivery_date
            let objTime = obj1.strdelivery_time
            
            let Date = self.changeDateFormatter(date: objdate)
            let time = self.changeDateForTime(date: objTime)
            cell.lblDeliveryCreatedDate.text = "\(Date) \(time )"
            cell.lblToLocation.text = obj1.strTo_Location
            
            let str = obj1.StrTitle
            
            let arr = str.components(separatedBy: ",")
            print(arr.count)
            
            if arr.count >= 2 {
                cell.lblDeliveryTypeName.text = "Multiple delivery"
                
            }else {
                cell.lblDeliveryTypeName.text = obj1.StrTitle
            }
            cell.lblFromLocation.text = obj1.strfrom_Location
            let ProfileRating = Int(obj1.strRating) ?? 0
            cell.viewRating.value = CGFloat(ProfileRating)
        
            let strimage = obj1.strPhoto
            let urlImg = URL(string: strimage)
            cell.imgDeliverdType.sd_setImage(with: urlImg, placeholderImage:#imageLiteral(resourceName: "placeholder_img"))
            cell.btnShowImg.tag = indexPath.row
            cell.btnShowImg.addTarget(self,action:#selector(onClicked(sender:)), for: .touchUpInside)

          }
        return cell
    }
    
    @objc func onClicked(sender: UIButton){
        let obj = self.arrCompleteOrderList[sender.tag]
        let url = obj.strPhoto
        let urlImg = URL(string: url)
        self.imgDeliveryTypeView.sd_setImage(with: urlImg, placeholderImage:#imageLiteral(resourceName: "placeholder_img"))
    
        self.viewShowDeliveryTypeImage.isHidden = false
        self.tabBarController?.tabBar.isHidden = true
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        _ = tableView.cellForRow(at: indexPath) as? CompleteOrderCell
        
        if arrCompleteOrderList.count > 0 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CompleteOrderDetailVc") as! CompleteOrderDetailVc
            let obj = arrCompleteOrderList[indexPath.row]
            print(obj.strDelvieryId)
            vc.deliveryId = obj.strDelvieryId

            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            
        }
    }
}

//MARK:- Webservices  -

extension CompletedOrderVC{
    
    func callWSForDeliveryList(){
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAppShareData.showNetworkAlert(view:self)
            return
        }
        objWebServiceManager.showIndicator()
        objWebServiceManager.requestGet(strURL: WsUrl.CompleteOrder+"offset="+String(self.offset)+"&limit="+String(self.limit) , params:[:], queryParams: [:], strCustomValidation: "", success: { (response) in
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
                    
                    if let arrTenantList = data["completed_orders_list"]as? [[String:Any]]{
                        for dic in arrTenantList{
                            let obj = CompletOrderModel.init(dict: dic)
                            self.arrCompleteOrderList.append(obj)
                            print(obj)
                            self.viewShowDeliveryTypeImage.isHidden = true

                        }
                    }
                    print(self.arrCompleteOrderList.count)
                    if Nodata == 0{
                        if self.arrCompleteOrderList.count == 0{
                            self.viewNodataFound.isHidden = false
                            
                        }else{
                            self.viewNodataFound.isHidden = true
                        }
                    }else{
                        self.viewNodataFound.isHidden = true
                        
                    }
                }
                
                self.tblCompleteOrder.reloadData()
                
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

//MARK:- Paggination Logic -
extension CompletedOrderVC{
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isDataLoading = false
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if velocity.y < 0 {
            print("up")
        }else{
            if ((tblCompleteOrder.contentOffset.y + tblCompleteOrder.frame.size.height) >= tblCompleteOrder.contentSize.height)
            {
                if !isDataLoading{
                    isDataLoading = true
                    
                    self.offset = self.offset+self.limit
                    print(totalRecords)
                    print(Next)
                    
                    if Next != ""  {
                        self.callWSForDeliveryList()
                    }else {
                        print("All records fetched")
                    }
                    
                }
            }
        }
    }
}

 
