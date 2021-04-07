//
//  DeliveryPersonInfoVc.swift
//  Go Delivery
//  Created by MACBOOK-SHUBHAM V on 07/09/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//
import UIKit
import HCSStarRatingView

class DeliveryPersonInfoVc: UIViewController ,UIScrollViewDelegate{
    
    //MARK:- IBOutlets -

    @IBOutlet weak var viewNoDataFound: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var viewDelvieryPersonImg: UIView!
    @IBOutlet weak var imgDeliveryPerson: UIImageView!
    @IBOutlet weak var lblDeliveryPersonName: UILabel!
    @IBOutlet weak var viewDeleveryPersonRatinf: HCSStarRatingView!
    @IBOutlet weak var tblhieghtConstrants: NSLayoutConstraint!
    @IBOutlet weak var tblCompleteJobs: UITableView!
    
    //MARK:- Local Variables -
    
    var strDeliveryPersonUserId = ""
    var isDataLoading:Bool=false
    var limit:Int=20
    var offset:Int=0
    var totalRecords = Int()
    var arrCompletedList  = [CompletedListModel]()
    var Next = ""
    var DeliveryPersonName = ""
    var DeliveryPersonImage = ""
    var ProfileRating = 0
    
    //MARK:- View Life Cycles -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.arrCompletedList.removeAll()
        self.limit = 20
        self.offset = 0
        self.callWSForDeliveryPersonInfo()
        self.scrollView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        self.imgDeliveryPerson.setImageFream()
        self.viewDelvieryPersonImg.layer.cornerRadius = viewDelvieryPersonImg.layer.frame.size.height/2
        self.viewDelvieryPersonImg.layer.masksToBounds = true
        self.viewDelvieryPersonImg.layer.borderWidth = 4
        self.viewDelvieryPersonImg.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.viewDelvieryPersonImg.setshadowViewCircle()
        self.viewDeleveryPersonRatinf.allowsHalfStars = false
        self.viewDeleveryPersonRatinf.maximumValue = 5
        self.viewDeleveryPersonRatinf.minimumValue = 0
        self.viewDeleveryPersonRatinf.isUserInteractionEnabled = false
    }
    
    //MARK:- Button Action -
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Local Methods -
    
    func changeDateFormatter(date:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dt = dateFormatter.date(from: date) //{
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "d MMM, yyyy"
        return dateFormatter.string(from: dt ?? Date())
    }
    
    func changeTimeFormatter(date:String) -> String {
          let dateFormatter = DateFormatter()
            dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
            dateFormatter.dateFormat = "HH:mm:ss"
            let dt = dateFormatter.date(from: date) //{
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = "hh:mm a"
            return dateFormatter.string(from: dt ?? Date())
    }
}

//MARK:- UITableViewDelegate/UITableViewDataSource-

extension DeliveryPersonInfoVc:UITableViewDelegate,UITableViewDataSource{
    
    //  if arr
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        self.viewWillLayoutSubviews()
    }
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        DispatchQueue.main.async {
            
            if self.arrCompletedList.count > 0 {
                self.tblhieghtConstrants?.constant = self.tblCompleteJobs.contentSize.height
                self.view.layoutIfNeeded()
               }else
            {
          }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCompletedList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "DeleveryPersonJobsCell", for: indexPath) as! DeleveryPersonJobsCell
        if arrCompletedList.count > 0 {
            let obj = arrCompletedList[indexPath.row]
            cell.lblFromAddress.text = obj.strFrom_location
            cell.lblToAddress.text = obj.strToLocation
            cell.viewReviewRating.allowsHalfStars = false
            cell.viewReviewRating.maximumValue = 5
            cell.viewReviewRating.minimumValue = 0
            cell.viewReviewRating.isUserInteractionEnabled = false
            let rating = obj.strRating
            let rat = Int(rating)
            
            cell.viewReviewRating.value = CGFloat(rat ?? 0)
            let objdate = obj.strDelivery_date
            let objTime = obj.strDelivery_time
            
            let Date = self.changeDateFormatter(date: objdate)
            let time = self.changeTimeFormatter(date: objTime)
            cell.lblDateAndTIme.text = "\(Date) \(time)"
            
        }
        return cell
    }
}

//MARK:- Webservice Classes-

extension DeliveryPersonInfoVc {
    
    func callWSForDeliveryPersonInfo(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAppShareData.showNetworkAlert(view:self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let   param = [
            WsParam.DeliverPersonUserId: Int(strDeliveryPersonUserId) ?? 0,
            WsParam.limit:self.limit,
            WsParam.offset:self.offset,
            ] as [String : Any]
        print(param)
        
        objWebServiceManager.requestGet(strURL: WsUrl.DeliveryPersonInfo , params: param, queryParams: [:], strCustomValidation: "", success: { (response) in
            print(response)
            let status = response["status"] as? String ?? ""
 
            if status == "success"{
                if let data = response["data"] as? [String:Any]{
                    _ = data["data_found"] as? Int
                    
                    let objData = DeliverypersonModel.init(dict: data)
                    if  let paging = data["paging"] as? [String:Any]{
                        self.Next = paging["next"] as? String ?? ""
                        print(self.Next)
                    }
    
                    if objData.strFirst_name != ""{
                        
                        self.DeliveryPersonName = "\(objData.strFirst_name) \(objData.strLast_name) "
                        
                        UserDefaults.standard.set(self.DeliveryPersonName, forKey: UserDefaults.Keys.DPersonName)
                        UserDefaults.standard.set(objData.strDpRating, forKey: UserDefaults.Keys.DPersonRating)
                        UserDefaults.standard.set(objData.strProfile_picture, forKey: UserDefaults.Keys.DPersonImage)
                       
                        self.lblDeliveryPersonName.text = UserDefaults.standard.value(forKey: UserDefaults.Keys.DPersonName) as? String ?? ""
                        let urlstring = UserDefaults.standard.value(forKey: UserDefaults.Keys.DPersonImage) as? String ?? ""
                        let urlImg = URL(string: urlstring)
                        self.imgDeliveryPerson.sd_setImage(with: urlImg, placeholderImage:#imageLiteral(resourceName: "user_placeholder_img"))
                        let Ratingvalue = UserDefaults.standard.value(forKey:UserDefaults.Keys.DPersonRating) as? String ?? ""
                        self.ProfileRating = Int(Ratingvalue) ?? 0
                        self.viewDeleveryPersonRatinf.value = CGFloat(self.ProfileRating)
                    }
                    
                    if self.arrCompletedList.count > 0
                    {
                        for obj in objData.arrQuoteList
                        {
                            self.arrCompletedList.append(obj)
                        }
                    }
                    else{
                        self.arrCompletedList = objData.arrQuoteList
                    }
                    print(self.arrCompletedList.count)
                    if self.arrCompletedList.count == 0{
                        self.viewNoDataFound.isHidden = false
                        self.tblCompleteJobs.isHidden = true
                        
                    }else{
                        self.viewNoDataFound.isHidden = true
                        self.tblCompleteJobs.isHidden = false

                    }
                    objWebServiceManager.hideIndicator()
                    self.tblCompleteJobs.reloadData()
                }
            }else{
                objWebServiceManager.hideIndicator()
            }
        }) { (error) in
            objWebServiceManager.hideIndicator()
            objAppShareData.showAlert(title: kAlertTitle, message: kErrorMessage, view: self)
            print(error)
        }
    }
}
//MARK:- Paggination Logic -
extension DeliveryPersonInfoVc{
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isDataLoading = false
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.stoppedScrolling()
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.stoppedScrolling()
        }
    }
    func stoppedScrolling() {
        print("Scroll finished")
    }
    
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if velocity.y < 0 {
            print("up")
        }else{
            
            print(tblCompleteJobs.contentOffset.y + tblCompleteJobs.frame.size.height)
            print(tblCompleteJobs.contentSize.height)
          
            
            if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height))
                //reach bottom
                
            {
                if !isDataLoading{
                    isDataLoading = true
                    
                    self.offset = self.offset+self.limit
                    if Next != ""  {
                        self.callWSForDeliveryPersonInfo()
                    }else {
                        print("All records fetched")
                    }
                }
            }
        }
    }
}
