//
//  reviewListVc.swift
//  Go Delivery
//
//  Created by MACBOOK-SHUBHAM V on 10.12.20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit
import HCSStarRatingView

class reviewListVc: UIViewController {
    
    
    //MARK:- IBOutlet-
    @IBOutlet weak var viewNoDataFound: UIView!
    @IBOutlet weak var lblReview: UILabel!
    
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var tblView: UITableView!
    
    //MARK:- Local Variables-

    var isDataLoading:Bool=false
    var limit:Int=20
    var offset:Int=0
    var totalRecords = Int()
    var arrReviewList = [ReviewModel]()
    var Next = ""
    var serverCurrentTime = ""
    
    //MARK:- View Life Cycle -

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tblView.delegate = self
        tblView.dataSource = self
        self.initialUISetup()
        self.callwebforReviewList()
    }
    
    //MARK:- Button Action -

    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Local Methods -

    func initialUISetup(){
        viewHeader.layer.shadowColor = UIColor.lightGray.cgColor
        viewHeader.layer.masksToBounds = false
        viewHeader.layer.shadowOffset = CGSize(width: 0.0 , height: 5.0)
        viewHeader.layer.shadowOpacity = 0.3
        viewHeader.layer.shadowRadius = 3
    }
}

//MARK:- UITableViewDelegate / UITableViewDataSource -

extension reviewListVc : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrReviewList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let obj = self.arrReviewList[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reviewCell") as? reviewCell
        cell?.lblCustomerName.text = "\(obj.strfirst_name) \(obj.strlast_name)"
        
        let desc = obj.strreview
        let trimDescription = desc.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines).filter{!$0.isEmpty}.joined(separator: "\n")
        
        if trimDescription != ""{
            cell?.lblReviewtext.text = trimDescription
            
        }else
        {
            cell?.lblReviewtext.text = "NA"
        }
                
        
        let strimage = obj.strprofile_picture
        let urlImg = URL(string: strimage)
        cell?.imgProfile.sd_setImage(with: urlImg, placeholderImage:#imageLiteral(resourceName: "notification_ico"))
        
        let createdTime = obj.strcreated_at
        let currentSeverTime = serverCurrentTime
        if createdTime != ""{
            
            
       let dateFormatter = DateFormatter()
       dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
       let createdTime = dateFormatter.date(from: createdTime)

       let dateFormatter1 = DateFormatter()
       dateFormatter1.dateFormat = "yyyy-MM-dd HH:mm:ss"
       let currentTime = dateFormatter1.date(from: currentSeverTime)

//
//            let dateFormatter1 = DateFormatter()
//            dateFormatter1.dateFormat = "yyyy-MM-dd HH:mm:ss"
//            let currentTime = dateFormatter1.date(from: createdTime)
//
            let changeTime = self.timeAgoSinceDate(date: createdTime as! NSDate, CurrentDate: currentTime as! NSDate, numericDates: true)
         
//            let changeTime = self.timeAgoSinceDate(date: currentTime as! NSDate, numericDates: true)
            
            print(changeTime)
            cell?.lblTime.text = "\(changeTime) ago"
            
            let revrating = obj.strrating
            cell?.viewRating.value = CGFloat(Int(revrating) ?? 0)
            
        }else{
   
        }
        return cell!
    }
}

//MARK:- Webservice Calling -


extension reviewListVc{
    
    func callwebforReviewList(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAppShareData.showNetworkAlert(view:self)
            return
            
        }
        objWebServiceManager.showIndicator()
        objWebServiceManager.requestGet(strURL: WsUrl.ReviewList+"offset="+String(self.offset)+"&limit="+String(self.limit) , params:[:], queryParams: [:], strCustomValidation: "", success: { (response) in
            let status = response["status"] as? String ?? ""
            let message = response["message"] as? String ?? ""
            
            if status == "success"{
                objWebServiceManager.hideIndicator()
                if let data = response["data"] as? [String:Any]{
                    let Nodata = data["data_found"] as? Int ?? -1
                    self.totalRecords = data["total_records"] as? Int ?? 0
                    self.serverCurrentTime = data["current_time"] as? String ??  ""
                    if  let paging = data["paging"] as? [String:Any]{
                        
                        self.Next = paging["next"] as? String ?? ""
                        
                        print(self.Next)
                    }
                    
                    if let arrTenantList = data["reviews"]as? [[String:Any]]{
                        for dic in arrTenantList{
                            let obj = ReviewModel.init(dict: dic)
                            self.arrReviewList.append(obj)
                            print(obj)
                        }
                    }
                    
                    if self.totalRecords == 0{
                        self.lblReview.text = "Reviews"

                    }else{
                        self.lblReview.text = "Reviews (\(self.totalRecords))"

                    }
                    
                    print(self.arrReviewList.count)
                    if Nodata == 0{
                        if self.arrReviewList.count == 0{
                            self.viewNoDataFound.isHidden = false
                        }else{
                            self.viewNoDataFound.isHidden = true
                        }
                    }else{
                        self.viewNoDataFound.isHidden = true
                        
                    }
                }
                
                self.tblView.reloadData()
                self.tblView.reloadData()
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
extension reviewListVc{
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isDataLoading = false
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if velocity.y < 0 {
            print("up")
        }else{
            if ((tblView.contentOffset.y + tblView.frame.size.height) >= tblView.contentSize.height)
            {
                if !isDataLoading{
                    isDataLoading = true
                    self.offset = self.offset+self.limit
                    print(totalRecords)
                    print(Next)
                    if Next != ""  {
                        self.callwebforReviewList()
                    }else {
                        print("All records fetched")
                    }
                }
            }
        }
    }
    
    func timeAgoSinceDate(date:NSDate,CurrentDate:NSDate, numericDates:Bool) -> String {
        
        let calendar = NSCalendar.current
        let now = CurrentDate
        let earliest = now.earlierDate(date as Date)
        let latest = (earliest == now as Date) ? date : now
        
        let unitsSet : Set<Calendar.Component> = [.year,.month,.weekOfYear,.day, .hour, .minute, .second, .nanosecond]
        
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
                return "1 month"
            } else {
                return "Last month"
            }
        }
        else if (components.weekOfYear >= 2) {
            return "\(components.weekOfYear) weeks"
        }
        else if (components.weekOfYear == 1){
            if (numericDates){
                return "1 week"
            } else {
                return "Last week"
            }
        } else if (components.day >= 2) {
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
            return "\(components.minute) mins"
        } else if (components.minute == 1){
            if (numericDates){
                return "1 min"
            } else {
                return "1 min"
            }
        } else if (components.second >= 3) {
            return "\(components.second) secs"
        } else {
            return "1 sec"
        }
        
    }
}
