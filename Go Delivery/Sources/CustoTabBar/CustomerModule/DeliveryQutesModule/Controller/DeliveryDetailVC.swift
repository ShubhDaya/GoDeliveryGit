//
//  DeliveryDetailVC.swift
//  Go Delivery
//
//  Created by MACBOOK-SHUBHAM V on 25/07/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit
import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation
import Alamofire
import SwiftyJSON
import Braintree
import BraintreeDropIn
import HCSStarRatingView
import INTULocationManager
import SVProgressHUD

var isFromTrackPerButton = false
var isPaymentsuccess  = false 

class DeliveryDetailVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    //MARK:- IBOutlet -
    
    @IBOutlet weak var viewGiveReviewRating: HCSStarRatingView!
    @IBOutlet weak var viewReviewDetails: UIView!
    @IBOutlet weak var lblReviewTime: UILabel!
    @IBOutlet weak var lblUpdatedReviewDetail: UILabel!
    
    @IBOutlet weak var viewGiveReview: HCSStarRatingView!
    @IBOutlet weak var viewGiveReviewPopUp: UIView!
    @IBOutlet weak var btnSubmitReview: UIButton!
    
    @IBOutlet weak var txtViewForReview: UITextView!
    @IBOutlet weak var viewGiveReviewForRadius: UIView!
    @IBOutlet weak var btnCloseGiveReviewView: UIButton!
    @IBOutlet weak var lblDeliveryStatus: UILabel!
    @IBOutlet weak var viewStatusAndGiveReviebtn: UIView!
    @IBOutlet weak var viewBtnView: UIView!
    @IBOutlet weak var viewDeliverdStatusView: UIView!
    @IBOutlet weak var viewRating: HCSStarRatingView!
    @IBOutlet weak var deliveryPersonName: UILabel!
    @IBOutlet weak var imgDeliveryPersonImage: UIImageView!
    @IBOutlet weak var viewQuoteList: UIView!
    @IBOutlet weak var viewDeliveryPersonInfo: UIView!
    @IBOutlet weak var lblAllQuoteQuoteInfoTitle: UILabel!
    @IBOutlet weak var lblAcceptedQuoteType: UILabel!
    @IBOutlet weak var lblAcceptedQuoteDescription: UILabel!
    @IBOutlet weak var lblAcceptedQuotePrice: UILabel!
    @IBOutlet weak var viewDeliveryPersonInfoTrackD: UIView!
    @IBOutlet weak var viewQuoteInfoForTrackD: UIView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var viewHorizontalDotline: UIView!
    @IBOutlet weak var viewVerticalDotLine: UIView!
    @IBOutlet weak var viewNoDeliveryPerson: UIView!
    @IBOutlet weak var btnGiveReview: UIButton!
    @IBOutlet weak var tblhieghtconstraints: NSLayoutConstraint!
    @IBOutlet weak var tblQuotes: UITableView!
    
    @IBOutlet weak var viewNoqouteList: UIView!
    @IBOutlet weak var imgDeliveryType: customImage!
    @IBOutlet weak var lblDeleveryType: UILabel!
    @IBOutlet weak var lblDeliveryDate: UILabel!
    @IBOutlet weak var lblFromAddress: UILabel!
    @IBOutlet weak var lblToAddress: UILabel!
    
    @IBOutlet weak var lblWidth: UILabel!
    @IBOutlet weak var lblLenght: UILabel!
    @IBOutlet weak var lblHeight: UILabel!
    @IBOutlet weak var lblWeight: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
    ///Divyanshu

    @IBOutlet weak var lblCarNumber: UILabel!
    @IBOutlet weak var lblCarMake: UILabel!
    @IBOutlet weak var lblCarModel: UILabel!
    @IBOutlet weak var lblCarColor: UILabel!
    
    ///
    
    //  Converted to Swift 5.2 by Swiftify v5.2.19227 - https://swiftify.com/
    
    //MARK:- Local Variables -
    var braintreeClient: BTAPIClient?

    var ratingStr: String?
    var ReviewRatingInt : Int?
    var DeliveryPersonUserId = ""
    var reviewGiven = ""
    var arrQuoteList = [QuoteListModel]()
    var deliveryId = ""
    var delivery_type_id = ""
    var action = 11
    var strPathSourceLat = ""
    var strPathSourceLong = ""
    var strPathDestinationLat = ""
    var strPathDestinationLong = ""
    var isFromAcceptButton = false
    var isFromRejectButton = false
    var paypalemail = ""
    var paypalNonceId = ""
    var strAlertId = ""
    var isFromAlertNewQuoteAdded = ""
    var isnotificationread = ""
    var ReViewTextDetail = ""
    var strPaymentNonce = ""
    var stramount = ""
    
    //MARK:- ViewLifeCycle Methods  -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.endEditing(true)
        
        self.tblQuotes.dataSource = self
        self.tblQuotes.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.endEditing(true)
        
        SVProgressHUD.dismiss()
        self.UIinitialSetup()
        self.viewGiveReviewPopUp.isHidden = true
        braintreeClient = BTAPIClient(authorization: "sandbox_9q68j7sp_w373qh4y4mykq7hj")
        self.callWSForQouteDetails()
        
        
        self.viewRating.allowsHalfStars = false
        self.viewRating.maximumValue = 5
        self.viewRating.minimumValue = 0
        self.btnGiveReview.btnRadNonCol22()
        self.btnGiveReview.setbtnshadow()
        viewRating.isUserInteractionEnabled = false
        
        self.viewGiveReviewRating.allowsHalfStars = false
        self.viewGiveReviewRating.maximumValue = 5
        self.viewGiveReviewRating.minimumValue = 0
        viewGiveReviewRating.isUserInteractionEnabled = false
    }
    
    //MARK:- Button Action  -
    @IBAction func btbGiveReview(_ sender: Any) {
        
        self.viewGiveReviewPopUp.isHidden = false
    }
    
    @IBAction func btnDeliveryPersonInfo(_ sender: Any) {
        isFromTrackPerButton = true
        let vc = UIStoryboard.init(name: "DeliveryQuotes", bundle: nil) .instantiateViewController(withIdentifier: "DeliveryPersonInfoVc")as! DeliveryPersonInfoVc
        vc.strDeliveryPersonUserId = DeliveryPersonUserId
        print(DeliveryPersonUserId)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnCloseGiveReview(_ sender: Any) {
        self.view.endEditing(true)
        self.viewGiveReviewPopUp.isHidden = true
    }
    
    
    @IBAction func btnSubmitReview(_ sender: Any) {
        let rating = Int(self.viewGiveReview.value)
        let strRatingcount = rating
        ReviewRatingInt = Int(strRatingcount)
        
        self.txtViewForReview.text = self.txtViewForReview.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if  rating <= 0 {
            
            objAlert.showAlert(message: "Please give review first.", title: kAlertTitle, controller: self)
        }else if txtViewForReview.text?.isEmpty  == true {
            
            objAlert.showAlert(message: "Please write some review.", title: kAlertTitle, controller: self)
        }else{
            
            self.callWebserviceForGiveReview()
        }
        
    }
    
    @IBAction func btnback(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Local Methods  -
    
    func UIinitialSetup(){
        self.imgDeliveryPersonImage.setImgCircle()
        self.viewGiveReviewForRadius.setViewRadius()
        // self.txtViewForReview.setViewCornerRadius5()
        self.btnSubmitReview.btnRadNonCol22()
        self.btnSubmitReview.setbtnshadow()
    }
    
    
    func EsternToLocal(dateStr: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "EST")

        if let date = dateFormatter.date(from: dateStr) {
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

            return dateFormatter.string(from: date)
        }
        return nil
    }

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
    
    
    //MARK:- MapViewDrawPath -
    
    func drawPath(){
        
        let StrPicklat = (self.strPathSourceLat as NSString).doubleValue
        let StrPickLong = (self.strPathSourceLong as NSString).doubleValue
        let StrDellat = (self.strPathDestinationLat as NSString).doubleValue
        let strDellong = (self.strPathDestinationLong as NSString).doubleValue
        
        _ = CLLocation(latitude: StrPicklat, longitude: StrPickLong)
        //My buddy's location
        _ = CLLocation(latitude: StrDellat, longitude: strDellong)
        let source = self.strPathSourceLat + "," + self.strPathSourceLong
        let destination = self.strPathDestinationLat + "," + self.strPathDestinationLong
        
        
        let camera = GMSCameraPosition.camera(withLatitude: StrPicklat, longitude: StrPickLong, zoom: 14)
        self.mapView.camera = camera
        let position = CLLocationCoordinate2D(latitude: StrDellat, longitude: strDellong)
        let marker = GMSMarker(position: position)
        marker.icon = #imageLiteral(resourceName: "gray_map_pin_ico")
        
        let position1 = CLLocationCoordinate2D(latitude: StrPicklat, longitude: StrPickLong)
        let marker1 = GMSMarker(position: position1)
        marker1.icon = #imageLiteral(resourceName: "blue_dot_ico")
        
        var UserLat:Double = 0
        var UserLong:Double = 0
        
        UserLat = StrPicklat
        UserLong = StrPickLong
        
        
        let position_1 = CLLocationCoordinate2D(latitude: UserLat, longitude: UserLong)
        let marker_1 = GMSMarker(position: position_1)
        
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(source)&destination=\(destination)&mode=driving&key=AIzaSyDuclnUxWGEIRR3O1w66-MogELN3gpR74s&sensor=false"
        print(url)
        
        //key=API_KEY
        // Type a message
        // AIzaSyC4Q5zPft2_JIR1ZXQJCui4kogy6BYm49I
        AF.request(url).responseJSON { response in
            
            let json = try! JSON(data: response.data!)
            // print(json)
            
            
            let routes = json["routes"].arrayValue
            
            if routes.count == 0{
                
            }
            
            for route in routes
            {
                let routeOverviewPolyline = route["overview_polyline"].dictionary
                let points = routeOverviewPolyline?["points"]?.stringValue
                let path = GMSPath.init(fromEncodedPath: points!)
                let polyline = GMSPolyline.init(path: path)
                polyline.map = self.mapView
                polyline.strokeWidth = 5
                polyline.strokeColor = #colorLiteral(red: 0.879128886, green: 0.1555605951, blue: 0.2124525889, alpha: 1)
            }
        }
        marker.map = self.mapView
        marker1.map = self.mapView
        
    }
    
    //MARK:- tableView DataSource Delegate  -
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewWillLayoutSubviews()
    }
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        DispatchQueue.main.async {
            self.tblhieghtconstraints?.constant = self.tblQuotes.contentSize.height
            self.view.layoutIfNeeded()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrQuoteList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllQuotesCell", for: indexPath) as! AllQuotesCell
        if arrQuoteList.count > 0 {
            
            
            let obj = arrQuoteList[indexPath.row]
            
            if obj.strQuoteDeliveryTypeId == "1"{
                cell.lblTypeName.text = "Land delivery"
                
            }else if obj.strQuoteDeliveryTypeId == "2"{
                cell.lblTypeName.text = "Air delivery"
                
            }else if obj.strQuoteDeliveryTypeId == "3"{
                cell.lblTypeName.text = "Sea delivery"
            }
            
            cell.lbPriceDetail.text = "$\(obj.strQuotePrice)"
            
            let description = obj.strQuoteDescription
            
            if description != ""{
                cell.lblDescription.text = obj.strQuoteDescription
            }else {
                cell.lblDescription.text = "NA"
            }
            cell.imgQuote.image = #imageLiteral(resourceName: "quote_ico")
            cell.btnAccept.tag = indexPath.row
            cell.btnReject.tag = indexPath.row
            cell.btnAccept.addTarget(self,action:#selector(acceptbtnClicked(sender:)), for: .touchUpInside)
            cell.btnReject.addTarget(self,action:#selector(cancelbtnclicked(sender:)), for: .touchUpInside)
        }
        return cell
    }
    @objc func cancelbtnclicked(sender : UIButton!) {
        let obj = self.arrQuoteList[sender.tag]
        isFromAcceptButton = false
        isFromRejectButton = true
        
        delivery_type_id = obj.strQuoteDeliveryTypeId
        action = 3
        self.callWebserviceForQuoteAction(index: sender.tag)
        
    }
    @objc func acceptbtnClicked(sender : UIButton!) {
        objWebServiceManager.showIndicator()
        
        let obj = self.arrQuoteList[sender.tag]
        print(obj)
        delivery_type_id = obj.strQuoteDeliveryTypeId
        isFromAcceptButton = true
        isFromRejectButton = false
        action = 2
        let price = obj.strQuotePrice
        self.stramount = obj.strQuotePrice
        let payPalDriver = BTPayPalDriver(apiClient: braintreeClient!)
        payPalDriver.viewControllerPresentingDelegate = self
        payPalDriver.appSwitchDelegate = self // Optional
        // Specify the transaction amount here. "2.32" is used in this example.
        let request = BTPayPalRequest(amount:price)
        request.currencyCode = "USD" // Optional; see BTPayPalRequest.h for more options
        SVProgressHUD.dismiss(withDelay: 3)
        
        payPalDriver.requestOneTimePayment(request) { (tokenizedPayPalAccount, error) in
            objWebServiceManager.hideIndicator()
            
            if let tokenizedPayPalAccount = tokenizedPayPalAccount {
                print("Got a nonce: \(tokenizedPayPalAccount.nonce)")
                self.paypalNonceId = tokenizedPayPalAccount.nonce
                self.paypalemail = tokenizedPayPalAccount.email ?? ""
                
                self.strPaymentNonce = tokenizedPayPalAccount.nonce
             
                print(tokenizedPayPalAccount)
                                
            } else if let error = error {
                print(error)
                self.paypalemail = ""
                self.paypalNonceId = ""
                objWebServiceManager.hideIndicator()
                
                // Handle error here...
            } else {
                objWebServiceManager.hideIndicator()
                self.paypalemail = ""
                self.paypalNonceId = ""
                // Buyer canceled payment approval
                print("Buyer canceled payment approval")
            }
            
            if self.paypalNonceId != ""{
                
                self.callWebserviceForQuoteAction(index: sender.tag)

            }else{
                
            }
    
            if let address = tokenizedPayPalAccount?.billingAddress {
                print("Billing address:\n\(address.streetAddress ?? "")\n\(address.extendedAddress ?? "")\n\(String(describing: address.locality)) \(String(describing: address.region))\n\(String(describing: address.postalCode)) \(address.countryCodeAlpha2 ?? "")")
            }
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

//MARK:- WebserviceApi Calling  -

extension DeliveryDetailVC{
    
    func callWSForQouteDetails(){
        self.arrQuoteList.removeAll()
        print(deliveryId)
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAppShareData.showNetworkAlert(view:self)
            return
        }
        objWebServiceManager.showIndicator()
        
        
        objWebServiceManager.requestGet(strURL: WsUrl.qoutDetails+String(deliveryId), params:[:], queryParams: [:], strCustomValidation: "", success: { (response) in
            print(response)
            
            let status = response["status"] as? String ?? ""
            let message = response["message"] as? String ?? ""
            _ = response["is_email_verified"] as? Int ?? 11
            
            if status == "success"{
                objWebServiceManager.hideIndicator()
                
                if let data = response["data"]as? [String:Any]{
                    let obj = DeliveryDetailsModel.init(dict: data)
                    
                    let revrating = obj.strRevRating
                    self.lblCarColor.text = obj.strCarColor
                    self.lblCarNumber.text = obj.strCarNumber
                    self.lblCarMake.text = obj.strCarMake
                    self.lblCarModel.text = obj.strCarModel
                    self.viewGiveReviewRating.value = CGFloat(Int(revrating) ?? 0)
                    
                    let str = obj.strdelivery_type_name
                    print(str.count)
                    
                    let arr = str.components(separatedBy: ",")
                    print(arr.count)

                    if arr.count >= 2 {
                        self.lblDeleveryType.text = "Multiple delivery"
                        
                    }else {
                        self.lblDeleveryType.text = obj.strdelivery_type_name
                        
                    }
                    let DeliveryStatus = obj.strstatus
                    self.reviewGiven = obj.strReviewGiven
                    print(self.reviewGiven)
                    
            
                    let objdate = obj.strdelivery_date
                    let objTime = obj.strdelivery_time
                    let Date = self.changeDateFormatter(date: objdate)
                    let time = self.changeTimeFormatter(date: objTime)
                    
                    self.DeliveryPersonUserId = obj.strdelivery_person_user_id
                    print(self.DeliveryPersonUserId)
                    
                    self.lblDeliveryDate.text = "\(Date) \(time)"
                    let strdpImg = obj.strDPersonprofile_picture
                    
                    let urlDp = URL(string: strdpImg)
                    self.imgDeliveryPersonImage.sd_setImage(with: urlDp, placeholderImage:#imageLiteral(resourceName: "logo"))
                    
                    let strimage = obj.strPhoto
                    
                    let urlImg = URL(string: strimage)
                    self.imgDeliveryType.sd_setImage(with: urlImg, placeholderImage:#imageLiteral(resourceName: "placeholder_img"))
                    
                    self.lblFromAddress.text = obj.strfrom_location
                    self.lblToAddress.text = obj.strto_location
                    
                    let desc = obj.strdescription
                    let trimDescription = desc.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines).filter{!$0.isEmpty}.joined(separator: "\n")
                    
                    if trimDescription != ""{
                        self.lblDescription.text = trimDescription
                        
                    }else
                    {
                        self.lblDescription.text = "NA"
                    }
                    
                    self.deliveryPersonName.text = "\(obj.strDPersonFirst_name) \(obj.strDPersonlast_name)"
                    
                    let reviewUp = obj.strRevReview
                    var FinalReview = reviewUp.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines).filter{!$0.isEmpty}.joined(separator: "\n")
                    
                    FinalReview = FinalReview.trimmingCharacters(in: .whitespacesAndNewlines)
     
                    if FinalReview != ""{
    
                        self.lblUpdatedReviewDetail.text = FinalReview
                        self.lblUpdatedReviewDetail.text = self.lblUpdatedReviewDetail.text?.trimmingCharacters(in: .whitespacesAndNewlines)
                        
                    }
                    
                    let value = obj.strDPRating
                    self.viewRating.value = CGFloat(Int(value) ?? 0)
                    let createdTime = obj.strRevCreated_at
                    let currentTime = obj.strCurrentTime

                    
                    if createdTime != ""{
                                                
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        let createdTime = dateFormatter.date(from: createdTime)

                        let dateFormatter1 = DateFormatter()
                        dateFormatter1.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        let currentTime = dateFormatter1.date(from: currentTime)
                        
                        
                        let changeTime = self.timeAgoSinceDate(date: createdTime as! NSDate, CurrentDate: currentTime as! NSDate, numericDates: true)
                        
                        print(changeTime)
                        self.lblReviewTime.text = "\(changeTime) ago"
                        
                    }
                    
                    if obj.strprice == ""{
                        self.lblAcceptedQuotePrice.text = "NA"
                    }else{
                        self.lblAcceptedQuotePrice.text = "$\(obj.strprice)"
                    }
                    if obj.strAcceptQouteDescription == ""{
                        self.lblAcceptedQuoteDescription.text = "NA"
                        
                    }else{
                        
                        let desc = obj.strAcceptQouteDescription
                        let trimDescription = desc.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines).filter{!$0.isEmpty}.joined(separator: "\n")
                        self.lblAcceptedQuoteDescription.text = trimDescription
                        
                    }
                    
                    let arrlist = obj.arrQuoteList
                    
                    for i in arrlist {
                        
                        if i.strQuoteStatus == "1"{
                            self.arrQuoteList.append(i)
                        }
                        print(self.arrQuoteList.count)
                    }
                    
                    let title = obj.strstatus_title
                    if title == "No Delivery Person Assigned"{
                        self.viewQuoteList.isHidden = true
                        self.viewNoqouteList.isHidden = true
                        
                        self.viewQuoteInfoForTrackD.isHidden = false
                        
                        self.viewDeliveryPersonInfoTrackD.isHidden = false
                        self.viewDeliveryPersonInfo.isHidden = true
                        
                        self.viewBtnView.isHidden = true
                        self.viewReviewDetails.isHidden = true
                        self.viewStatusAndGiveReviebtn.isHidden = true
                        self.viewDeliverdStatusView.isHidden = true
                        
                        
                    }else if  title == "Pending"{
                        
                        if self.arrQuoteList.count == 0{
                            self.tblQuotes.isHidden = true
                            self.viewQuoteList.isHidden = true
                            
                        }else {
                            self.tblQuotes.isHidden = false
                            self.viewNoqouteList.isHidden = true
                        }

                        self.viewQuoteInfoForTrackD.isHidden = true
                        
                        self.viewDeliveryPersonInfoTrackD.isHidden = true
                        self.viewDeliveryPersonInfo.isHidden = true
                        
                        self.viewBtnView.isHidden = true
                        self.viewReviewDetails.isHidden = true
                        self.viewStatusAndGiveReviebtn.isHidden = true
                        self.viewDeliverdStatusView.isHidden = true
                        
                        
                        
                        
                    } else if title == "Delivery Person Assigned"{
                        self.viewNoqouteList.isHidden = true
                        self.viewQuoteList.isHidden = true
                        
                        self.viewQuoteInfoForTrackD.isHidden = false
                        
                        self.viewDeliveryPersonInfoTrackD.isHidden = true
                        self.viewDeliveryPersonInfo.isHidden = false
                        
                        self.viewBtnView.isHidden = true
                        self.viewReviewDetails.isHidden = true
                        self.viewStatusAndGiveReviebtn.isHidden = true
                        self.viewDeliverdStatusView.isHidden = true
                        
                        
                        self.deliveryPersonName.text = "\(obj.strDPersonFirst_name) \(obj.strDPersonlast_name)"
                        let strimage = obj.strDPersonprofile_picture
                        let urlImg = URL(string: strimage)
                        self.imgDeliveryPersonImage.sd_setImage(with: urlImg, placeholderImage:#imageLiteral(resourceName: "user_placeholder_img"))
                        let status = obj.strstatus
                        
                    }else if DeliveryStatus == "3"{
                        self.lblDeliveryStatus.text  = "Pick-Up"
                        
                        self.viewNoqouteList.isHidden = true
                        self.viewQuoteList.isHidden = true
                        
                        self.viewQuoteInfoForTrackD.isHidden = false
                        
                        self.viewDeliveryPersonInfoTrackD.isHidden = true
                        self.viewDeliveryPersonInfo.isHidden = false
                        
                        self.viewStatusAndGiveReviebtn.isHidden = false
                        
                        self.viewBtnView.isHidden = true
                        self.viewReviewDetails.isHidden = true
                        self.viewDeliverdStatusView.isHidden = false
                        
                    }else if DeliveryStatus == "4"{
                        self.lblDeliveryStatus.text  = "In-Progress"
                        
                        self.viewNoqouteList.isHidden = true
                        self.viewQuoteList.isHidden = true
                        
                        self.viewQuoteInfoForTrackD.isHidden = false
                        
                        
                        self.viewDeliveryPersonInfoTrackD.isHidden = true
                        self.viewDeliveryPersonInfo.isHidden = false
                        
                        self.viewStatusAndGiveReviebtn.isHidden = false
                        
                        self.viewBtnView.isHidden = true
                        self.viewReviewDetails.isHidden = true
                        self.viewDeliverdStatusView.isHidden = false
                        
                    }else if DeliveryStatus == "5"{
                        
                        self.lblDeliveryStatus.text  = "Delivered"
                        self.viewQuoteList.isHidden = true
                        self.viewNoqouteList.isHidden = true
                        
                        self.viewQuoteInfoForTrackD.isHidden = false
                        
                        self.viewDeliveryPersonInfoTrackD.isHidden = true
                        self.viewDeliveryPersonInfo.isHidden = false
                        
                        self.viewReviewDetails.isHidden = true
                        
                        self.viewDeliverdStatusView.isHidden = false
                        self.viewStatusAndGiveReviebtn.isHidden = false
                        
                        if self.reviewGiven == "0"{
                            print("review not give ")
                            self.viewReviewDetails.isHidden = true
                            self.viewBtnView.isHidden = false
                            
                            
                        }else if self.reviewGiven == "1"{
                            print("review given ")
                            self.viewReviewDetails.isHidden = false
                            self.viewBtnView.isHidden = true
                        }
                    }
                    let deliverytypeId = obj.strdelivery_type_id
                    
                    if deliverytypeId == "1"{
                        self.lblAcceptedQuoteType.text = "Land delivery"
                        
                    }else if deliverytypeId == "2"{
                        self.lblAcceptedQuoteType.text = "Air delivery"
                        
                        
                    }else if deliverytypeId == "3"{
                        self.lblAcceptedQuoteType.text = "Sea delivery"
                        
                    }else if deliverytypeId == ""{
                        self.lblAcceptedQuoteType.text = "NA"
                        
                    }
                    
                    if objAppShareData.isFromNotification == true  {
                        self.callWebforReadNotification()
                    }else
                    {
                        
                    }
                    
                    if isFromAlertList == true{
                        print(self.isnotificationread)
                        print(self.strAlertId)
                        if  self.isnotificationread == "0"{
                            self.callWebforReadNotification()
                        }
                        
                    }else{
                        
                    }
                    
                    self.strPathSourceLat = obj.strfrom_latitude
                    self.strPathSourceLong = obj.strfrom_longitude
                    self.strPathDestinationLat = obj.strto_latitude
                    self.strPathDestinationLong = obj.strto_longitude
                    
                    if obj.strLength_unit == "1"{
                        
                        let lenght = obj.strLength
                        
                        if lenght == ""{
                            
                            self.lblLenght.text = "NA"
                        }else{
                            self.lblLenght.text = "\(obj.strLength) cm"
                            
                        }
                        
                    }else if  obj.strLength_unit == "2"{
                        
                        let lenght = obj.strLength
                        
                        if lenght == ""{
                            self.lblLenght.text = "NA"
                        }else{
                            self.lblLenght.text = "\(obj.strLength) feet"
                        }
                    }
                    
                    if obj.strhight_unit == "1"{
                        
                        let height = obj.strHeight
                        if height == ""{
                            self.lblHeight.text = "NA"
                        }else{
                            self.lblHeight.text = "\(obj.strHeight) cm"
                        }
                        
                    }else if  obj.strhight_unit == "2"{
                        let height = obj.strHeight
                        if height == ""{
                            self.lblHeight.text = "NA"
                        }else{
                            self.lblHeight.text = "\(obj.strHeight) feet"
                        }
                        
                    }
                    if obj.strweight_unit == "1"{
                        let weight = obj.strweight
                        if weight == ""{
                            self.lblWeight.text = "NA"
                        }else{
                            self.lblWeight.text = "\(obj.strweight) kg"
                        }
                        
                        
                    }else if obj.strweight_unit == "2"{
                        let weight = obj.strweight
                        if weight == ""{
                            self.lblWeight.text = "NA"
                        }else{
                            self.lblWeight.text = "\(obj.strweight) lbs"
                        }
                    }
                    
                    if obj.strwidth_unit == "1"{
                        
                        let width = obj.strwidth
                        if width == ""{
                            
                            self.lblWidth.text = "NA"
                        }else{
                            self.lblWidth.text = "\(obj.strwidth) cm"
                        }
                    }else if obj.strwidth_unit == "2"{
                        
                        let width = obj.strwidth
                        if width == ""{
                            
                            self.lblWidth.text = "NA"
                        }else{
                            self.lblWidth.text = "\(obj.strwidth) feet"
                        }
                    }
                    
                    if self.strPathSourceLat != "" && self.strPathSourceLat != "" && self.strPathDestinationLat != "" && self.strPathDestinationLong != ""{
                        self.drawPath()
                    }
                }
                
                self.tblQuotes.reloadData()
                
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
    
    func callWebserviceForQuoteAction(index:Int){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAppShareData.showNetworkAlert(view:self)
            return
        }
        objWebServiceManager.showIndicator()
        self.view.endEditing(true)
        var strUdidi = ""
        if let MyUniqueId = UserDefaults.standard.string(forKey:UserDefaults.Keys.strVenderId) {
            print("defaults VenderID: \(MyUniqueId)")
            strUdidi = MyUniqueId
        }
        
        let param = [WsParam.delivery_type_id:self.delivery_type_id,
                     WsParam.action:self.action,
                     WsParam.delivery_id:self.deliveryId,
                     WsParam.firebase_token :strUdidi,
                     WsParam.payment_nonce : self.strPaymentNonce,
                     WsParam.amount : self.stramount
            
            ] as [String : Any]
        
        print(param)
        
        objWebServiceManager.requestPost(strURL:WsUrl.quoteAction, queryParams: [:], params: param, strCustomValidation: "", showIndicator: true, success: {response in
            
            let status = (response["status"] as? String)
            let message = (response["message"] as? String)
            print(response)
            
            if   status == "success" {
                objWebServiceManager.hideIndicator()
                
                if (response["data"]as? [String:Any]) != nil{
                    
                    if self.action == 3{
                        self.arrQuoteList.remove(at:index)
                        self.tblQuotes.reloadData()
                    }
                    if  self.isFromAcceptButton == true{
                        
                        let vc = UIStoryboard.init(name: "DeliveryRequest", bundle: nil).instantiateViewController(withIdentifier: "PaymentSuccessVC")as! PaymentSuccessVC
                        
                        vc.closerAcceptPayment = {
                            isPaymentSuccess  in
                            if isPaymentSuccess{
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                        self.navigationController?.pushViewController(vc, animated: true)
            
                    }else if self.isFromRejectButton == true{
                        print(self.arrQuoteList.count)
                        if self.arrQuoteList.count == 0{
                            self.navigationController?.popViewController(animated: true)
                            
                        }
                    }else{
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }else{
                objWebServiceManager.hideIndicator()
                if message == "k_sessionExpire"{
                    objAlert.showAlert(message: k_sessionExpire, title: kAlertTitle, controller: self)
                    objAppShareData.resetDefaultsAlluserInfo()
                    
                    ObjAppdelegate.loginNavigation()
                }  else{
                    objAlert.showAlert(message:message ?? "", title: kAlertTitle, controller: self)
                }
                
            }
        }, failure: { (error) in
            print(error)
            objWebServiceManager.hideIndicator()
            objAppShareData.showAlert(title: kAlertTitle, message: kErrorMessage, view: self)
        })
    }
    
    func callWebserviceForGiveReview(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAppShareData.showNetworkAlert(view:self)
            return
        }
        
        self.txtViewForReview.text = self.txtViewForReview.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let desc = self.txtViewForReview.text ?? ""
        ReViewTextDetail = desc.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines).filter{!$0.isEmpty}.joined(separator: "\n")
        
        objWebServiceManager.showIndicator()
        self.view.endEditing(true)

        let param = [WsParam.delivery_id:deliveryId,
                     WsParam.rating:ReviewRatingInt ?? 000,
                     WsParam.review :ReViewTextDetail
            ] as [String : Any]
        print(param)
        
        objWebServiceManager.requestPost(strURL:WsUrl.GiveReview, queryParams: [:], params: param, strCustomValidation: "", showIndicator: true, success: {response in
            
            let status = (response["status"] as? String)
            let message = (response["message"] as? String)
            print(response)
            
            if   status == "success" {
                objWebServiceManager.hideIndicator()
                
                if (response["data"]as? [String:Any]) != nil{
                    self.viewGiveReviewPopUp.isHidden = true
                    
                    self.callWSForQouteDetails()
                }
            }else{
                objWebServiceManager.hideIndicator()
                if message == "k_sessionExpire"{
                    objAlert.showAlert(message: k_sessionExpire, title: kAlertTitle, controller: self)
                    objAppShareData.resetDefaultsAlluserInfo()
                    ObjAppdelegate.loginNavigation()
                }  else{
                    objAlert.showAlert(message:message ?? "", title: kAlertTitle, controller: self)
                }
                
            }
        }, failure: { (error) in
            print(error)
            objWebServiceManager.hideIndicator()
            objAppShareData.showAlert(title: kAlertTitle, message: kErrorMessage, view: self)
        })
    }
    
    
    func callWebforReadNotification(){
        
        strAlertId = objAppShareData.strNotificationAlertId
     
       // objWebServiceManager.showIndicator()
        
        objWebServiceManager.requestPatch(strURL: WsUrl.ReadNotification+String(strAlertId), params:[:] , queryParams: [:], strCustomValidation: "", success: { (response) in
            print(response)
            //objWebServiceManager.hideIndicator()
            
            
            let status = response["status"] as? String
            let message = response["message"] as? String ?? ""
            if status == "success"{
                let dic = response["data"] as? [String:Any] ?? [:]
                objAppShareData.isFromNotification = false
                objAppShareData.strNotificationType = ""
                objAppShareData.notificationDict = [:]
                
            }  else{
                //objWebServiceManager.hideIndicator()
                if message == "k_sessionExpire"{
                    objAlert.showAlert(message: k_sessionExpire, title: kAlertTitle, controller: self)
                    ObjAppdelegate.loginNavigation()
                }  else{
                  //  objWebServiceManager.hideIndicator()
                    
                    objAlert.showAlert(message:message, title: kAlertTitle, controller: self)
                }
            }
            
        }) { (error) in
            print(error)
            //objWebServiceManager.hideIndicator()
            objAppShareData.showAlert(title: kAlertTitle, message: kErrorMessage, view: self)
        }
    }                      
}

//MARK:- BTViewControllerPresentingDelegate  -


extension DeliveryDetailVC : BTViewControllerPresentingDelegate{
    
    // MARK: - BTViewControllerPresentingDelegate
    
    func paymentDriver(_ driver: Any, requestsPresentationOf viewController: UIViewController) {
        present(viewController, animated: true, completion: nil)
    }
    
    func paymentDriver(_ driver: Any, requestsDismissalOf viewController: UIViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
}

extension DeliveryDetailVC : BTAppSwitchDelegate{
    
    // MARK: - BTAppSwitchDelegate
    // Optional - display and hide loading indicator UI
    func appSwitcherWillPerformAppSwitch(_ appSwitcher: Any) {
        showLoadingUI()
     
    }
    
    func appSwitcherWillProcessPaymentInfo(_ appSwitcher: Any) {
        hideLoadingUI()
    }
    
    func appSwitcher(_ appSwitcher: Any, didPerformSwitchTo target: BTAppSwitchTarget) {
    }
    
    // MARK: - Private methods
    
    func showLoadingUI() {
        // ...
    }
    
    func hideLoadingUI() {
        NotificationCenter
            .default
        //   .removeObserver(self, name: NSNotification.Name.UIApplication.didBecomeActiveNotification, object: nil)
        // ...
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


