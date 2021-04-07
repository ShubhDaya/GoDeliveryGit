//
//  TrackVc.swift
//  Go Delivery
//
//  Created by MACBOOK-SHUBHAM V on 23/07/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit

var isfromTrackDelivery = false
var isforRefreshTrackDD = false

class TrackVc: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    //MARK:- IBOutlets -
    
    @IBOutlet weak var viewUnderDevelopment: UIView!
    @IBOutlet weak var tblDeliveryQuates: UITableView!
    @IBOutlet weak var viewFilter: UIView!
    @IBOutlet weak var viewFilterForRadius: UIView!
    @IBOutlet weak var imgDeliveryPick: UIImageView!
    @IBOutlet weak var imgInProgessSelection: UIImageView!
    @IBOutlet weak var imgDeliveredSelection: UIImageView!
    @IBOutlet weak var viewNoDataFound: UIView!
    
    //MARK:- Local variables -
    
    var isDataLoading:Bool=false
    var limit:Int=3
    var offset:Int=0
    var totalRecords = Int()
    var status = ""
    var FilterStatus = 0
    var arrDeliveryTrackList = [TrackListModel]()
    var Next = ""
    var Nodata = 11
    var idforTDRefresh = ""
    
    //MARK:- View Life Cycle  -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if objAppShareData.isFromNotification{
            
        if objAppShareData.strNotificationType == "driver_assigned" || objAppShareData.strNotificationType == "ask_for_review" || objAppShareData.strNotificationType == "delivery_pickup" || objAppShareData.strNotificationType == "delivery_inprogress" ||
            objAppShareData.strNotificationType == "delivery_delivered" {
                let vc = UIStoryboard.init(name: "DeliveryQuotes", bundle: Bundle.main).instantiateViewController(withIdentifier: "DeliveryDetailVC") as? DeliveryDetailVC
                var property_id = 0
                if let id = objAppShareData.notificationDict["reference_id"] as? Int{
                    property_id = id
                }else if let id = objAppShareData.notificationDict["reference_id"] as? String{
                    property_id = Int(id)!
                }
                vc?.deliveryId = String(property_id)
                isfromTrackDelivery = true
                
                self.navigationController?.pushViewController(vc!, animated: false)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isFromAlertList = false
        
        self.limit = 20
        self.offset = 0
        self.arrDeliveryTrackList.removeAll()
        callWSForTrackList()
        self.tblDeliveryQuates.reloadData()
        self.viewNoDataFound.isHidden = true
        self.viewFilterForRadius.setViewRadius()
        self.viewFilter.isHidden = true
        
        if Nodata == 0 {
            self.viewNoDataFound.isHidden = false
        }else if Nodata == 1{
            self.viewNoDataFound.isHidden = true
        }
    }
    
    //MARK:- Buttons -
    
    @IBAction func btnChangeStatusForFilter(_ sender: Any) {
        self.viewFilter.isHidden = false
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @IBAction func btnReset(_ sender: Any) {
        self.status = ""
        FilterStatus = 0
        self.viewFilter.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
        self.arrDeliveryTrackList.removeAll()
        self.limit = 20
        self.offset = 0
        imgInProgessSelection.image = #imageLiteral(resourceName: "inactive_check_box_ico")
        imgDeliveredSelection.image = #imageLiteral(resourceName: "inactive_check_box_ico")
        imgDeliveryPick.image = #imageLiteral(resourceName: "inactive_check_box_ico")
        callWSForTrackList()
    }
    
    
    @IBAction func btnDoneFilter(_ sender: Any) {
        
        if FilterStatus == 0 {
            objAlert.showAlert(message: "Please select filter status", title: kAlertTitle, controller: self)
            
        }else{
            self.status = String(FilterStatus)
            self.viewFilter.isHidden = true
            self.tabBarController?.tabBar.isHidden = false
            self.arrDeliveryTrackList.removeAll()
            self.limit = 20
            self.offset = 0
            callWSForTrackList()
        }
    }
    
    @IBAction func btnCancelFilter(_ sender: Any) {
        self.viewFilter.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func btnDeliveryPIckUp(_ sender: Any) {
        imgDeliveryPick.image = UIImage(named: "active_check_box_ico")
        imgInProgessSelection.image = #imageLiteral(resourceName: "inactive_check_box_ico")
        imgDeliveredSelection.image = #imageLiteral(resourceName: "inactive_check_box_ico")
        FilterStatus = 3
    }
    
    @IBAction func btnInProgressSelection(_ sender: Any) {
        imgDeliveryPick.image = #imageLiteral(resourceName: "inactive_check_box_ico")
        imgInProgessSelection.image = UIImage(named: "active_check_box_ico")
        imgDeliveredSelection.image = #imageLiteral(resourceName: "inactive_check_box_ico")
        FilterStatus = 4
    }
    
    @IBAction func btnDeliveredSelection(_ sender: Any) {
        imgDeliveryPick.image = #imageLiteral(resourceName: "inactive_check_box_ico")
        imgInProgessSelection.image = #imageLiteral(resourceName: "inactive_check_box_ico")
        imgDeliveredSelection.image = UIImage(named: "active_check_box_ico")
        FilterStatus = 5
    }
    
    //MARK:- Table view Data source and Delegate  -
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  arrDeliveryTrackList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "trackListCell", for: indexPath) as! trackListCell
        let obj = arrDeliveryTrackList[indexPath.row]
        
        
        if arrDeliveryTrackList.count > 0{
            
            cell.lblTolocation.text = obj.strto_location
            cell.lblFromLocation.text = obj.strfrom_location
            cell.lblStatus.text = obj.strStatusTitle
            let objdate = obj.strdelivery_date
            let objTime = obj.strdelivery_time
            
            let Date = self.changeDateFormatter(date: objdate)
            let time = self.changeTimeFormatter(date: objTime)
            cell.lblDateTime.text = "\(Date) \(time)"
            
            let str = obj.strdelivery_type_name
            print(str.count)
            
            let arr = str.components(separatedBy: ",")
            print(arr.count)
            if arr.count >= 2 {
                cell.lblDeliveryType.text = "Multiple delivery"
            }else {
                cell.lblDeliveryType.text = obj.strdelivery_type_name
            }
            
            let strimage = obj.strphoto
            let urlImg = URL(string: strimage)
            cell.imgDelivery.sd_setImage(with: urlImg, placeholderImage:UIImage(named: "placeholder_img"))
            
            
            let strDPImage = obj.strProfile_picture
            let urlDpImg = URL(string: strDPImage)
            cell.imgUser.sd_setImage(with: urlDpImg, placeholderImage:#imageLiteral(resourceName: "user_placeholder_img"))
            
            
            let status = obj.strstatus
            if status == "3"{
                cell.lblStatus.textColor = #colorLiteral(red: 0.1549426671, green: 0.6481797003, blue: 0.9686274529, alpha: 1)
                cell.lblStatus.font = UIFont(name:"Nunito-Bold", size: 14.0)

            }else {
                cell.lblStatus.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                cell.lblStatus.font = UIFont(name:"Nunito-Bold", size: 12.0)

            }
            
            let DeliveryTitle = obj.strStatusTitle
            if DeliveryTitle == "No Delivery Person Assigned"{
                
                cell.imgUser.isHidden = true
            }else{
                cell.imgUser.isHidden = false
            }
            
        }else{
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _ = tableView.cellForRow(at: indexPath) as? DeliveryQuotesCell
        
        self.view.endEditing(true)
        let vc = UIStoryboard.init(name: "DeliveryQuotes", bundle: nil).instantiateViewController(withIdentifier: "DeliveryDetailVC")as! DeliveryDetailVC
        let obj = arrDeliveryTrackList[indexPath.row]
        print(obj.strDelvieryId)
        vc.deliveryId = obj.strDelvieryId
        isfromTrackDelivery = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //MARK:- Local Methods   -
    
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
    
    func changeTimeFormatter(date:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
        
        dateFormatter.dateFormat = "HH:mm:ss"
        // dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let dt = dateFormatter.date(from: date) //{
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: dt ?? Date())
    }
}

//MARK:- Webservices Calling  -


extension TrackVc{
    
    func callWSForTrackList(){
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAppShareData.showNetworkAlert(view:self)
            return
        }
        objWebServiceManager.showIndicator()
        
        let param = [WsParam.limit:limit,
                     WsParam.offset:offset,
                     WsParam.status:status] as [String:Any]
        print(param)
        objWebServiceManager.requestGet(strURL: WsUrl.trackList , params:param, queryParams: [:], strCustomValidation: "", success: { (response) in
            let status = response["status"] as? String ?? ""
            let message = response["message"] as? String ?? ""
            
            if status == "success"{
                objWebServiceManager.hideIndicator()
                if let data = response["data"] as? [String:Any]{
                    self.Nodata = data["data_found"] as? Int ?? -1
                    self.totalRecords = data["total_records"] as? Int ?? 0
                    
                    if  let paging = data["paging"] as? [String:Any]{
                        self.Next = paging["next"] as? String ?? ""
                        print(self.Next)
                    }
            
                    if let arrTenantList = data["delivery_list"]as? [[String:Any]]{
                        for dic in arrTenantList{
                            let obj = TrackListModel.init(dict: dic)
                            self.arrDeliveryTrackList.append(obj)
                            print(obj)
                        }
                    }
                    print(self.arrDeliveryTrackList.count)
                    if self.Nodata == 0{
                        if self.arrDeliveryTrackList.count == 0{
                            self.viewNoDataFound.isHidden = false
                            
                        }else{
                            self.viewNoDataFound.isHidden = true
                        }
                    }else{
                        self.viewNoDataFound.isHidden = true
                        
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
//MARK:- Paggination Logic-
extension TrackVc{
    
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

                    if Next != ""  {
                        self.callWSForTrackList()
                    }else {
                        print("All records fetched")
                    }
                }
            }
        }
    }
}
