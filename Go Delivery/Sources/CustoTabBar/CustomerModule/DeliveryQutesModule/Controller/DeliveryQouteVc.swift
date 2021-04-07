//
//  DeliveryQouteVc.swift
//  Go Delivery
//
//  Created by MACBOOK-SHUBHAM V on 23/07/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit

class DeliveryQouteVc: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    //MARK:- IBOutlet-
    
    @IBOutlet weak var viewUnderDevelopment: UIView!
    @IBOutlet weak var tblDeliveryQuates: UITableView!
    
    //MARK:- Local Variables -
    
    var isDataLoading:Bool=false
    var limit:Int=20
    var offset:Int=0
    var totalRecords = Int()
    var arrDeliveryQuoteList = [DeliveryQouteListModel]()
    var Next = ""
    
    //MARK:- View Life Cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if objAppShareData.isFromNotification{
            if objAppShareData.strNotificationType == "new_quote" {
                
                let vc = UIStoryboard.init(name: "DeliveryQuotes", bundle: Bundle.main).instantiateViewController(withIdentifier: "DeliveryDetailVC") as? DeliveryDetailVC
                var property_id = 0
                if let id = objAppShareData.notificationDict["reference_id"] as? Int{
                    property_id = id
                }else if let id = objAppShareData.notificationDict["reference_id"] as? String{
                    property_id = Int(id)!
                }
                vc?.deliveryId = String(property_id)
                isfromTrackDelivery = false
                self.navigationController?.pushViewController(vc!, animated: false)
            }
        }else{
            if   objAppShareData.isFromFirebaseDynamicLink == true
                   {
                       objAppShareData.isFromFirebaseDynamicLink = false
                     let vc = UIStoryboard.init(name: "DeliveryQuotes", bundle: Bundle.main).instantiateViewController(withIdentifier: "DeliveryDetailVC") as? DeliveryDetailVC
                    print(String(objAppShareData.strDeeplinkDeliveryId))
                    vc?.deliveryId = String(objAppShareData.strDeeplinkDeliveryId)
                                  isfromTrackDelivery = false
                    self.navigationController?.pushViewController(vc!, animated: false)
                   }
            }
        self.tblDeliveryQuates.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isFromAlertList = false
        self.viewUnderDevelopment.isHidden = true
        isfromTrackDelivery = false
        self.arrDeliveryQuoteList.removeAll()
        self.limit = 20
        self.offset = 0
        self.callWSForDeliveryList()
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
        //dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
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
 
    
    
    //MARK:- TableView Datasource/Delegate   -
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrDeliveryQuoteList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeliveryQuotesCell", for: indexPath) as! DeliveryQuotesCell
        if arrDeliveryQuoteList.count > 0 {
            let obj1 = self.arrDeliveryQuoteList[indexPath.row]
            let objdate = obj1.strdelivery_date
            let objTime = obj1.strdelivery_time
            
            let Date = self.changeDateFormatter(date: objdate)
            let time = self.changeDateForTime(date: objTime)
            cell.lblDateTime.text = "\(Date) \(time )"
            cell.lblTolocation.text = obj1.strto_location
            
            let str = obj1.strdelivery_type_name
            
            let arr = str.components(separatedBy: ",")
            print(arr.count)
            
            if arr.count >= 2 {
                cell.lblDeliveryType.text = "Multiple delivery"
                
            }else {
                cell.lblDeliveryType.text = obj1.strdelivery_type_name
            }
            cell.lblFromLocation.text = obj1.strfrom_location
            cell.lblDeliveryCount.text = obj1.strquote_count
            let strQuoteCount = obj1.strquote_count
            if strQuoteCount == "0" {
                
                cell.viewCountView.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
            }else{
                cell.viewCountView.backgroundColor = #colorLiteral(red: 0.879128886, green: 0.1555605951, blue: 0.2124525889, alpha: 1)
            }
            let strimage = obj1.strphoto
            let urlImg = URL(string: strimage)
            cell.imgDelivery.sd_setImage(with: urlImg, placeholderImage:#imageLiteral(resourceName: "placeholder_img"))
            
        }else{
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        _ = tableView.cellForRow(at: indexPath) as? DeliveryQuotesCell
        
        if arrDeliveryQuoteList.count > 0 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "DeliveryDetailVC") as! DeliveryDetailVC
            let obj = arrDeliveryQuoteList[indexPath.row]
            print(obj.strDelvieryId)
            vc.deliveryId = obj.strDelvieryId
            
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            
        }
    }
}

//MARK:- Webservices    -

extension DeliveryQouteVc{
    func callWSForDeliveryList(){
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAppShareData.showNetworkAlert(view:self)
            return
        }
        objWebServiceManager.showIndicator()
        objWebServiceManager.requestGet(strURL: WsUrl.GetListDelivery+"offset="+String(self.offset)+"&limit="+String(self.limit) , params:[:], queryParams: [:], strCustomValidation: "", success: { (response) in
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
                    
                    if let arrTenantList = data["delivery_list"]as? [[String:Any]]{
                        for dic in arrTenantList{
                            let obj = DeliveryQouteListModel.init(dict: dic)
                            self.arrDeliveryQuoteList.append(obj)
                            print(obj)
                        }
                    }
                    print(self.arrDeliveryQuoteList.count)
                    if Nodata == 0{
                        if self.arrDeliveryQuoteList.count == 0{
                            self.viewUnderDevelopment.isHidden = false
                            
                        }else{
                            self.viewUnderDevelopment.isHidden = true
                        }
                    }else{
                        self.viewUnderDevelopment.isHidden = true
                    }
                }
                self.tblDeliveryQuates.reloadData()
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
extension DeliveryQouteVc{
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isDataLoading = false
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if velocity.y < 0 {
            print("up")
        }else{
            if ((tblDeliveryQuates.contentOffset.y + tblDeliveryQuates.frame.size.height) >= tblDeliveryQuates.contentSize.height)
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
