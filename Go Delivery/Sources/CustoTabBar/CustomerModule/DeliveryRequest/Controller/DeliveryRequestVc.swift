//
//  DeliveryRequestVc.swift
//  Go Delivery
//
//  Created by MACBOOK-SHUBHAM V on 23/07/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit
import KMPlaceholderTextView
import GooglePlaces
import SVProgressHUD
import SDWebImage
import GoogleMaps
import INTULocationManager
import IQKeyboardManagerSwift
import IQKeyboardManager

class DeliveryRequestVc: UIViewController,UIGestureRecognizerDelegate,UITextViewDelegate,UITextFieldDelegate {
    
    //MARK:- Local Variables-
    var address = ""
    var strCity = ""
    var strState = ""
    var strCountry = ""
    var strlat = ""
    var strlong = ""
    var id = ""
    var deliverytypetext = ""
    var isAllFreightSelcted = false
    var isFromAdd = false
    var isbtnWidthInCm = false
    var isbtnLenghtInCm = false
    var isbtnHeightInLbs = false
    var isbtnWeigthInKg = false
    var WidthCm = "cm"
    var LenghtCm = "cm"
    var HeightLbs = "cm"
    var weightKg = "kg"
    var lenghtUnit = "1"
    var WightUnit = "1"
    var WidthUnit = "1"
    var HightUnit = "1"
    
    var DeliveryTypeId = ""
    var selectedType = ""
    
    var latitude = 0.0
    var langtitue = 0.0
    var strfromLongitude = ""
    var strfromLatitude = ""
    var strToLongitude = ""
    var strToLatitude = ""
    var FromLocation = ""
    var ToLocation = ""
    var deliveryDate = ""
    var deliveryTime = ""
    var StrTime1 = ""
    
    var trimDescription = ""
    
    var arrdeliverytypeId = [deliveryListTypeModel]()
    var arrtype = [String]()
    var sorted = [String]()
    var imageUploadData : Data?
    var pickedImage:UIImage?
    
    var isbtnDateRequested = false
    var isbtnTimeRequested = false
    var arrDeliveryType = [deliveryListTypeModel]()
    var arrheight = [height_unit_listModel]()
    var arrwidth = [width_unit_listModel]()
    var arrlenght = [length_unit_listModel]()
    var arrWeight = [weightUnitListModel]()
    var blank = ["", ""]
    var selectedImage : UIImage!
    
    var imagePicker = UIImagePickerController()
    var convertedImage : UIImage!
    
    
    //MARK:- IBOutlet -
    
    @IBOutlet weak var imgDropDownDeleveryType: UIImageView!
    @IBOutlet weak var imgAllfreightSelected: UIImageView!
    @IBOutlet weak var lblForWidthtype: UILabel!
    @IBOutlet weak var lblForHeightType: UILabel!
    @IBOutlet weak var lblForKgType: UILabel!
    @IBOutlet weak var viewLine: UIView!
    @IBOutlet weak var lblForLenghtTyep: UILabel!
    @IBOutlet weak var lblDescriptionSelectTitle: UILabel!
    @IBOutlet weak var lblDatePickerTitle: UILabel!
    @IBOutlet weak var viewUnderDevelopment: UIView!
    @IBOutlet weak var txtToLocation: UITextField!
    @IBOutlet weak var txtFromLocation: UITextField!
    @IBOutlet weak var lblFromLocation: UILabel!
    @IBOutlet weak var imgDefault: UIImageView!
    @IBOutlet weak var btnClearSelectedImage: UIButton!
    @IBOutlet weak var imgCamera: UIImageView!
    @IBOutlet weak var imgUploaded: UIImageView!
    @IBOutlet weak var txtDeliveryType: UITextField!
    @IBOutlet weak var lblDeliveryType: UILabel!
    @IBOutlet weak var viewLocationForShadow: UIView!
    @IBOutlet weak var viewDescriptionforShadow: UIView!
    @IBOutlet weak var btnGetQuotes: UIButton!
    @IBOutlet weak var viewDatePicker: UIView!
    @IBOutlet weak var viewHorizontalDasline: UIView!
    @IBOutlet weak var viewDashdLine: UIView!
    @IBOutlet weak var DatePicker: UIDatePicker!
    @IBOutlet weak var viewPickerContaint: NSLayoutConstraint!
    @IBOutlet weak var txtWidthCm: UITextField!
    @IBOutlet weak var txtHeigthLbs: UITextField!
    @IBOutlet weak var txtlenghtcm: UITextField!
    @IBOutlet weak var txtWightKg: UITextField!
    @IBOutlet weak var DescriptionPicke: UIPickerView!
    @IBOutlet weak var DesConstaint: NSLayoutConstraint!
    @IBOutlet weak var txtNote: KMPlaceholderTextView!
    @IBOutlet weak var txtDeleDateRequested: UITextField!
    @IBOutlet weak var txtDeleTimeRequested: UITextField!
    @IBOutlet weak var tblDeleveryType: UITableView!
    @IBOutlet weak var viewDeleveryType: UIView!
    @IBOutlet weak var viewContainerType: UIView!
    @IBOutlet weak var viewHeaderView: UIView!
    @IBOutlet weak var viewDescriptionAlert: UIView!
    @IBOutlet weak var viewDatePickerforhide: UIView!
    
    //MARK:- View Life Cycles -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.endEditing(true)
        self.hideDescriptionPicker()
       
    
        self.lblForKgType.text = weightKg
        self.lblForLenghtTyep.text = LenghtCm
        self.lblForHeightType.text = HeightLbs
        self.lblForWidthtype.text = WidthCm
        
        
        imgAllfreightSelected.image = #imageLiteral(resourceName: "inactive_check_box_ico")
        isAllFreightSelcted = false
        objAppShareData.SelectedTypeDate.removeAll()
        if arrDeliveryType.count == 0 {
            self.callWSForGeneralList()
        }
        self.tblDeleveryType.reloadData()
        let isEnable = self.checkForLocation()
        if !isEnable{
            self.showAlertForLocation()
        }else{
            self.getLocation()
        }
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imagePicker.delegate = self
        if #available(iOS 13.4, *) {
            self.DatePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        
        self.initalUISetup()
        self.addDoneButtonOnKeyboard()
        self.hideDatePicker()
        self.hideDescriptionPicker()
        self.imgCamera.isHidden = true
        self.addplaceholderColor()
        self.DatePicker.minimumDate = Date()
        self.txtWightKg.delegate = self
        self.txtlenghtcm.delegate = self
        self.txtHeigthLbs.delegate = self
        self.txtWidthCm.delegate = self
        self.imagePicker.delegate = self
        self.viewDeleveryType.isHidden = true
        self.tblDeleveryType.dataSource = self
        self.tblDeleveryType.delegate = self
        self.txtNote.delegate = self
        self.viewDescriptionAlert.isHidden = true
        self.viewDatePickerforhide.isHidden = true
        self.DatePicker.minimumDate = Date()
        self.DescriptionPicke.dataSource = self;
        self.DescriptionPicke.delegate = self;
        self.DescriptionPicke.dataSource = self
        
        
        if arrDeliveryType.count == 1{
            txtDeliveryType.text = "Land delivery"
            id = "1"
            self.imgDropDownDeleveryType.isHidden = true
            
        }else{
            self.imgDropDownDeleveryType.isHidden = false
        }
        
        if arrDeliveryType.count == 0 {
            self.callWSForGeneralList()
        }
        self.tblDeleveryType.reloadData()
    }
    
    //MARK:- UIButtons -
    
    @IBAction func btnSelectAllFrieght(_ sender: Any) {
        
        if isAllFreightSelcted == false{
            imgAllfreightSelected.image = #imageLiteral(resourceName: "Accept_btn")
            isAllFreightSelcted = true
            id = ""
            deliverytypetext = ""
            objAppShareData.SelectedTypeDate.removeAll()
            arrtype.removeAll()
            
            for obj in arrDeliveryType{
                objAppShareData.SelectedTypeDate.append(obj)
            }
            self.tblDeleveryType.reloadData()
            
        } else {
            imgAllfreightSelected.image = #imageLiteral(resourceName: "inactive_check_ico")
            isAllFreightSelcted = false
            objAppShareData.SelectedTypeDate.removeAll()
            arrtype.removeAll()
            self.tblDeleveryType.reloadData()
            id = ""
            deliverytypetext = ""
        }
    }
    
    @IBAction func btnCancelDatePicker(_ sender: Any) {
        self.view.endEditing(true)
        self.hideDatePicker()
        self.hideDescriptionPicker()
    }
    
    @IBAction func btnSelectWidthinCm(_ sender: Any) {
        self.lblDescriptionSelectTitle.text = "Width"
        isbtnWidthInCm = true
        isbtnLenghtInCm = false
        isbtnHeightInLbs = false
        isbtnWeigthInKg = false
        showDescriptionPicker()
        self.DescriptionPicke.reloadAllComponents()
    }
    
    @IBAction func btnSelectHightLbs(_ sender: Any) {
        self.lblDescriptionSelectTitle.text = "Height"
        isbtnHeightInLbs = true
        isbtnLenghtInCm = false
        isbtnWeigthInKg = false
        isbtnWidthInCm = false
        showDescriptionPicker()
        self.DescriptionPicke.reloadAllComponents()
    }
    
    @IBAction func btnSelectLengthCm(_ sender: Any) {
        self.lblDescriptionSelectTitle.text = "Length"
        isbtnLenghtInCm = true
        isbtnHeightInLbs = false
        isbtnWeigthInKg = false
        isbtnWidthInCm = false
        showDescriptionPicker()
        self.DescriptionPicke.reloadAllComponents()
    }
    
    @IBAction func btnSelWiightKg(_ sender: Any) {
        self.lblDescriptionSelectTitle.text = "Weight"
        isbtnWeigthInKg = true
        isbtnLenghtInCm = false
        isbtnHeightInLbs = false
        isbtnWidthInCm = false
        showDescriptionPicker()
        self.DescriptionPicke.reloadAllComponents()
    }
    
    @IBAction func btnUploadImage(_ sender: Any) {
        self.view.endEditing(true)
        self.hideDatePicker()
        self.hideDescriptionPicker()
        
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: { _ in
            
            if  self.imgUploaded.image != nil {
                self.imgDefault.isHidden = true
            }
            else {
                self.imgDefault.isHidden = false
            }
            self.hideDatePicker()
            self.hideDescriptionPicker()
            
        }))
        
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alert.popoverPresentationController?.sourceView = sender as? UIView
            alert.popoverPresentationController?.sourceRect = (sender as AnyObject).bounds
            alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func btnClearImage(_ sender: Any) {
        self.view.endEditing(true)
        self.hideDatePicker()
        self.hideDescriptionPicker()
        
        imgUploaded.image = nil
        imgCamera.isHidden = true
        self.imgDefault.isHidden = false
        btnClearSelectedImage.isHidden = true
    }
    
    @IBAction func btnDoneDatePicker(_ sender: Any) {
        self.view.endEditing(true)
        self.hideDatePicker()
        self.hideDescriptionPicker()
        
        if isbtnTimeRequested == true {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
            dateFormatter.timeStyle = .short
            let strShowDate = dateFormatter.string(from: self.DatePicker.date)
            print(strShowDate)
            txtDeleTimeRequested.text = strShowDate
            deliveryTime = convertTimeFormater(strShowDate)
            
            
        }else if isbtnDateRequested == true {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
            dateFormatter.dateStyle = .none
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let strShowDate = dateFormatter.string(from: self.DatePicker.date)
            if isbtnDateRequested == true {
                self.txtDeleDateRequested.text = strShowDate
                deliveryDate = strShowDate
                print(deliveryDate)
                
            }
        }
        self.hideDatePicker()
    }
    
    @IBAction func btnOpenDeliveryTypetbl(_ sender: Any) {
        self.view.endEditing(true)
        if arrDeliveryType.count == 1{
            
        }else if arrDeliveryType.count == 0 {
            
        }else{
            self.hideDatePicker()
            self.hideDescriptionPicker()
            self.tabBarController?.tabBar.isHidden = true
            viewDeleveryType.isHidden = false
            self.tblDeleveryType.reloadData()
        }
    }
    
    @IBAction func btnCreateQoutes(_ sender: Any) {
        self.hideDatePicker()
        self.hideDescriptionPicker()
        
        self.txtNote.text = self.txtNote.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if txtFromLocation.text == ""{
            objAlert.showAlert(message: "The From Location field is required.", title: kAlertTitle, controller: self)
        }else if txtToLocation.text == ""{
            objAlert.showAlert(message: "The To Location field is required.", title: kAlertTitle, controller: self)
        }
        else if txtDeliveryType.text == ""{
            objAlert.showAlert(message: "The Delivery Type field is required.", title: kAlertTitle, controller: self)
        }
        else if txtDeleDateRequested.text == ""{
            objAlert.showAlert(message: "The Delivery Date field is required.", title: kAlertTitle, controller: self)
        }else if deliveryTime == ""{
            objAlert.showAlert(message: "The Delivery Time field is required.", title: kAlertTitle, controller: self)
        }
        else{
            self.callWebCreateQuotes()
        }
    }
    
    @IBAction func btnDoneSelcteDilveryType(_ sender: Any) {
        self.view.endEditing(true)
        self.hideDatePicker()
        self.hideDescriptionPicker()
        
        print(objAppShareData.SelectedTypeDate.count)
        id = ""
        deliverytypetext = ""
        arrtype.removeAll()
        
        if objAppShareData.SelectedTypeDate.count != 0{
            for i in objAppShareData.SelectedTypeDate{
                arrtype.append(i.strDeliveryTypeId)
                
                sorted = arrtype.sorted {$0.localizedStandardCompare($1) == .orderedAscending}
                
                print(sorted)
            }
            
            if objAppShareData.SelectedTypeDate.count < 3{
                for i in objAppShareData.SelectedTypeDate{
                    deliverytypetext =  String(deliverytypetext)+","+String(i.strtitle)
                    
                }
                
            }else if  objAppShareData.SelectedTypeDate.count == 3{
                deliverytypetext = ",All delivery"
            }
            
            if deliverytypetext != ""{
                deliverytypetext.removeFirst()
                self.txtDeliveryType.text = deliverytypetext
                viewDeleveryType.isHidden = true
                self.tabBarController?.tabBar.isHidden = false
                for obj in sorted{
                    id  = String(id)+","+obj
                }
                print(id)
                id.removeFirst()
                print(id)
            }
        }else {
            objAlert.showAlert(message: "Please Select Delivery Type first", title: "Alert", controller: self)
            self.tabBarController?.tabBar.isHidden = true
        }
    }
    
    @IBAction func btnEnterFromLocation(_ sender: Any) {
        self.view.endEditing(true)
        self.hideDatePicker()
        self.hideDescriptionPicker()
        
        PlacePicker.shared.openPicker(controller: self, success: { (placeDict) in
            print("place info = \(placeDict)")
            self.txtFromLocation.text = placeDict["formattedAddress"] as? String ?? ""
            let straddress = self.txtFromLocation.text
            self.strfromLatitude = placeDict["lat"] as? String ?? ""
            self.strfromLongitude = placeDict["long"]
                as? String ?? ""
            
            let coordLat = placeDict["clat"] as? CLLocationDegrees ?? 0.0
            let coordLong = placeDict["clong"] as? CLLocationDegrees ?? 0.0
            
            let Cordinate = CLLocationCoordinate2D.init(latitude: coordLat, longitude: coordLong)
            PlacePicker.shared.reverseGeocodeCoordinate(Cordinate, success: { (addressModel) in
                self.FromLocation = addressModel.address ?? ""
                self.txtFromLocation.text = self.FromLocation
            }) { (error) in
                
                print("error in getting address.")
            }
        }) { (error) in
            print("error = \(error.localizedDescription)")
        }
    }
    
    
    @IBAction func btnEnterToLocation(_ sender: Any) {
        self.view.endEditing(true)
        self.hideDatePicker()
        self.hideDescriptionPicker()
        
        PlacePicker.shared.openPicker(controller: self, success: { (placeDict) in
            print("place info = \(placeDict)")
            self.txtToLocation.text = placeDict["formattedAddress"] as? String ?? ""
            let straddress = self.txtToLocation.text
            print(straddress ?? "")
            self.strToLatitude = placeDict["lat"] as? String ?? ""
            self.strToLongitude = placeDict["long"]
                as? String ?? ""
            
            let coordLat = placeDict["clat"] as? CLLocationDegrees ?? 0.0
            let coordLong = placeDict["clong"] as? CLLocationDegrees ?? 0.0
            
            let Cordinate = CLLocationCoordinate2D.init(latitude: coordLat, longitude: coordLong)
            PlacePicker.shared.reverseGeocodeCoordinate(Cordinate, success: { (addressModel) in
                self.ToLocation = addressModel.address ?? ""
                self.txtToLocation.text = self.ToLocation
                self.strCity = addressModel.city ?? ""
                self.strState = addressModel.state ?? ""
                self.strCountry = addressModel.country ?? ""
                
            }) { (error) in
                
                print("error in getting address.")
            }
        }) { (error) in
            print("error = \(error.localizedDescription)")
        }
        
    }
    
    @IBAction func btnCancelDeliveryTypeView(_ sender: Any) {
        self.view.endEditing(true)
        self.hideDatePicker()
        self.hideDescriptionPicker()
        viewDeleveryType.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
        
        if id == ""{
            txtDeliveryType.text = ""
        }else{
            print("selectedTyep not nil")
        }
        // selectedType = ""
        self.tblDeleveryType.reloadData()
    }
    
    @IBAction func btnDeliveryDateRequest(_ sender: Any) {
        self.view.endEditing(true)
        self.hideDatePicker()
        self.hideDescriptionPicker()
        isbtnDateRequested = true
        isbtnTimeRequested = false
        DatePicker.datePickerMode = .date
        lblDatePickerTitle.text = "Select Date"
        self.tabBarController?.tabBar.isHidden = true
        self.showDatePicker()
    }
    
    @IBAction func btnDeliveryTimeRequest(_ sender: Any) {
        self.view.endEditing(true)
        self.hideDatePicker()
        self.hideDescriptionPicker()
        isbtnTimeRequested = true
        isbtnDateRequested = false
        lblDatePickerTitle.text = "Select time"
        DatePicker.datePickerMode = .time
        self.showDatePicker()
    }
    
    @IBAction func btnCancelHeighLenghtView(_ sender: Any) {
        self.view.endEditing(true)
        self.hideDatePicker()
        self.hideDescriptionPicker()
    }
    
    @IBAction func btnDoneHeightLenView(_ sender: Any) {
        self.view.endEditing(true)
        
        self.hideDatePicker()
        self.hideDescriptionPicker()
        if isbtnWeigthInKg == true{
            self.lblForKgType.text = weightKg
            
        }else if isbtnLenghtInCm == true {
            
            self.lblForLenghtTyep.text = LenghtCm
            
        }else if isbtnHeightInLbs == true {
            self.lblForHeightType.text = HeightLbs
            
        }else if isbtnWidthInCm == true {
            self.lblForWidthtype.text = WidthCm
        }
    }
    
    //MARK:- Local methods  -
    
    func convertTimeFormater(_ time: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
        dateFormatter.dateFormat = "hh:mm a"
        let date = dateFormatter.date(from: time)!
        dateFormatter.dateFormat = "HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        let timeStamp = dateFormatter.string(from: date)
        self.StrTime1 = dateFormatter.string(from: date)
        return timeStamp
    }
    
    
    func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        txtNote.inputAccessoryView = doneToolbar
        txtHeigthLbs.inputAccessoryView = doneToolbar
        txtWightKg.inputAccessoryView = doneToolbar
        txtWidthCm.inputAccessoryView = doneToolbar
        txtlenghtcm.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction(){
        self.hideDatePicker()
        self.hideDescriptionPicker()
        // txtNote.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    func addplaceholderColor(){
        txtNote.placeholder = "Delivery contents and any special note"
        txtDeleDateRequested.attributedPlaceholder = NSAttributedString(string: "Delivery Date Requested",
                                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        txtDeleTimeRequested.attributedPlaceholder = NSAttributedString(string: "Delivery Time Requested",
                                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        txtDeliveryType.attributedPlaceholder = NSAttributedString(string: "Delivery Type",
                                                                   attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        
        txtFromLocation.attributedPlaceholder = NSAttributedString(string: "Enter From Location",
                                                                   attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        txtToLocation.attributedPlaceholder = NSAttributedString(string: "Enter To Location",
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        
        txtWidthCm.attributedPlaceholder = NSAttributedString(string: "Width",
                                                              attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        txtlenghtcm.attributedPlaceholder = NSAttributedString(string: "Length",
                                                               attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        txtHeigthLbs.attributedPlaceholder = NSAttributedString(string: "Height",
                                                                attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        txtWightKg.attributedPlaceholder = NSAttributedString(string: "Weight",
                                                              attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
    }
    
    func initalUISetup(){
        self.viewLocationForShadow.setShadowAllView10()
        self.viewDescriptionforShadow.setShadowAllView10()
        self.btnGetQuotes.btnRadNonCol22()
        self.btnGetQuotes.setbtnshadow()
        self.viewContainerType.setViewRadius()
        self.viewHeaderView.setViewRadius()
        self.imgUploaded.setImgRadiTopBottomLeft()
    }
    
    func showDatePicker(){
        self.viewDatePickerforhide.isHidden = false
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func hideDatePicker(){
        self.view.endEditing(true)
        self.viewDatePickerforhide.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func showDescriptionPicker(){
        self.viewDescriptionAlert.isHidden = false
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func hideDescriptionPicker(){
        self.view.endEditing(true)
        self.viewDescriptionAlert.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func checkForLocation() -> Bool {
        var isEnable = false
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted:
                print("No access")
            // self.showAlertForLocation()
            case .denied:
                print("No access")
            // self.showAlertForLocation()
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
                if objAppShareData.strLat.count == 0{
                    self.showAlertForLocation()
                }else{
                    isEnable = true
                }
            default:
                break
            }
        } else {
            self.showAlertForLocation()
            print("Location services are not enabled")
        }
        return isEnable
    }
    
    func showAlertForLocation(){
        let alertVC = UIAlertController(title: "Alert" , message: "If you want to add delivery request first you have to enable your location!", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "Go to Settings", style: UIAlertAction.Style.cancel) { (alert) in
            let url = URL(string: UIApplication.openSettingsURLString)!
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            
        }
        alertVC.addAction(okAction)
        DispatchQueue.main.async {
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    
    func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D, success: @escaping (AddressModel)->(), failure: @escaping (Error)-> ()) {
        
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(coordinate.latitude)")!
        let lon: Double = Double("\(coordinate.longitude)")!
        let _: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        //let geocoder = GMSGeocoder()
        let geocoder: CLGeocoder = CLGeocoder()
        //print("coordinate = \(coordinate)")
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        geocoder.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                
                let pm = placemarks! as [CLPlacemark]
                placemarks
                if pm.count > 0 {
                    let pm = placemarks![0]
                    var addressString : String = ""
                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! + ", "
                    }
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "
                    }
                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + ", "
                    }
                    if pm.country != nil {
                        addressString = addressString + pm.country! + ", "
                    }
                    if pm.postalCode != nil {
                        addressString = addressString + pm.postalCode! + " "
                    }
                    print(addressString)
                    
                    let currentAddress = AddressModel()
                    currentAddress.address = addressString
                    currentAddress.city = pm.locality
                    currentAddress.state = pm.administrativeArea
                    currentAddress.country = pm.country
                    currentAddress.zipCode = pm.postalCode
                    currentAddress.lat = String(center.latitude)
                    currentAddress.lng = String(center.longitude)
                    success(currentAddress)
                }
        })
    }
    
}


//MARK:-TableView For Select Delivery Type -
extension DeliveryRequestVc : UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.arrDeliveryType.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblDeleveryType.dequeueReusableCell(withIdentifier: "DeliveryTypeCell", for: indexPath) as! DeliveryTypeCell
        
        let obj = arrDeliveryType[indexPath.row]
        cell.lblDeliveryType.text? = "\(obj.strtitle)"
        
        if objAppShareData.SelectedTypeDate.contains(obj){
            cell.imgSelectedImage.image = UIImage(named: "active_check_box_ico")
            
        }else{
            cell.imgSelectedImage.image = #imageLiteral(resourceName: "inactive_check_box_ico")
        }
        
        if objAppShareData.SelectedTypeDate.count == 3{
            imgAllfreightSelected.image = #imageLiteral(resourceName: "Accept_btn")
            isAllFreightSelcted = true 
        }else if objAppShareData.SelectedTypeDate.count < 3{
            imgAllfreightSelected.image = #imageLiteral(resourceName: "inactive_check_box_ico")
            isAllFreightSelcted = false
        }
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _ = tblDeleveryType.cellForRow(at: indexPath) as? DeliveryTypeCell
        
        let obj = arrDeliveryType[indexPath.row]
        
        if objAppShareData.SelectedTypeDate.contains(obj){
            let index = objAppShareData.SelectedTypeDate.index(of: obj)
            objAppShareData.SelectedTypeDate.remove(at:index!)
            
        }else{
            objAppShareData.SelectedTypeDate.append(obj)
        }
        
        self.tblDeleveryType.reloadData()
    }
}


//MARK:- UIPickerViewDelegate & UIPickerViewDataSource -


extension DeliveryRequestVc : UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if isbtnHeightInLbs == true {
            return arrheight.count
        }else if isbtnWidthInCm == true{
            return arrwidth.count
        }else if isbtnLenghtInCm == true {
            return arrlenght.count
        }else if isbtnWeigthInKg == true {
            return arrWeight.count
        }
        else
        {
            return 0
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        self.view.endEditing(true)
        if isbtnHeightInLbs == true {
            return arrheight[row].strValue
            
        }else if isbtnWidthInCm == true{
            return arrwidth[row].strValue
        }else if isbtnLenghtInCm == true {
            return arrlenght[row].strValue
        }else if isbtnWeigthInKg == true {
            return arrWeight[row].strValue
            self.DescriptionPicke.reloadAllComponents()
        }
        self.DescriptionPicke.reloadAllComponents()
        
        return blank[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if arrheight.count > 0 && arrwidth.count > 0  &&  arrlenght.count > 0 &&  arrWeight.count > 0 {
            
            if isbtnHeightInLbs == true {
                
                let item = arrheight[row]
                HeightLbs = item.strValue
                HightUnit = item.strId
                
            }else if isbtnWidthInCm == true{
                let item = arrwidth[row]
                WidthCm = item.strValue
                WidthUnit = item.strId
                
            }else if isbtnLenghtInCm == true {
                let item = arrlenght[row]
                LenghtCm = item.strValue
                lenghtUnit = item.strId
                
            }else if isbtnWeigthInKg == true {
                let   item = arrWeight[row]
                weightKg = item.strValue
                WightUnit = item.strId
                
            }
        }
    }
}
//MARK:- UIImagePicker Delegate -
extension DeliveryRequestVc : UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true
            imagePicker.modalPresentationStyle = .fullScreen
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert = UIAlertController(title: "Warning", message: "You don't have camera.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func openGallary()
    {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.modalPresentationStyle = .fullScreen
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        imgUploaded.image = nil
        selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imgUploaded.image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        imgUploaded.image = imgUploaded.image?.fixOrientation()
        
        selectedImage = imgUploaded.image
        self.imgCamera.isHidden = false
        self.imgDefault.isHidden = true
        self.btnClearSelectedImage.isHidden = false
        self.dismiss(animated: true, completion: nil)
    }
    func convertImageToBase64(_ image: UIImage) -> String {
        let imageData:NSData = image.jpegData(compressionQuality: 0.4)! as NSData
        let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
        return strBase64
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        if  self.imgUploaded.image != nil {
            self.imgDefault.isHidden = true
        }
        else {
            self.imgDefault.isHidden = false
        }
        dismiss(animated: true, completion: nil)
    }
}

//MARK:- Get Current Location -

extension DeliveryRequestVc {
    func getLocation(){
        if self.isFromAdd{
            SVProgressHUD.show()
        }
        PlacePicker.shared.getUsersCurrentLocation(success: { (CLLocationCoordinate2D) in
            print(CLLocationCoordinate2D)
            let lat = CLLocationCoordinate2D.latitude
            let long = CLLocationCoordinate2D.longitude
            let Cordinate = type(of: CLLocationCoordinate2D).init(latitude: lat, longitude: long)
            
            PlacePicker.shared.reverseGeocodeCoordinate(Cordinate, success: { (addressModel) in
                self.address  = addressModel.address ?? ""
                self.strCity = addressModel.city ?? ""
                self.strState = addressModel.state ?? ""
                self.strCountry = addressModel.country ?? ""
                self.strlong = addressModel.lng ?? ""
                self.strlat = addressModel.lat ?? ""
                print(self.address)
                self.strfromLatitude = self.strlat
                print(self.strfromLatitude)
                self.strfromLongitude = self.strlong
                print(self.strfromLongitude)
                self.txtFromLocation.text = self.address
                self.view.endEditing(true)
                
                
            }) { (error) in
                SVProgressHUD.dismiss()
            }
        }) { (Error) in
            SVProgressHUD.dismiss()
            print(Error)
        }
    }
}

//MARK:- WebServices Calling -

extension DeliveryRequestVc{
    func callWSForGeneralList(){
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAppShareData.showNetworkAlert(view:self)
            return
        }
        objWebServiceManager.showIndicator()
        
        let   param = [
            WsParam.user_id: objAppShareData.userDetail.strUserID,
            ] as [String : Any]
        
        objWebServiceManager.requestGet(strURL: WsUrl.generalList , params: param, queryParams: [:], strCustomValidation: "", success: { (response) in
            print(response)
            let status = response["status"] as? String ?? ""
            let message = response["message"] as? String ?? ""
            let data = response["data"] as? [String:Any] ?? [:]
            
            if status == "success"{
                _ = GeneralListModel.init(dict: data)
                
                objWebServiceManager.hideIndicator()
                if let arrpending = data["delivery_types_list"]as? [[String:Any]]{
                    
                    self.arrDeliveryType.removeAll()
                    for obj in arrpending{
                        let objModel = deliveryListTypeModel.init(dict: obj)
                        self.arrDeliveryType.append(objModel)
                    }
                    
                    if self.arrDeliveryType.count == 1 {
                        self.txtDeliveryType.text = "Land delivery"
                        self.id = "1"
                        self.imgDropDownDeleveryType.isHidden = true
                    }else
                    {
                        self.imgDropDownDeleveryType.isHidden = false
                        
                    }
                    self.tblDeleveryType.reloadData()
                    
                }
                if let hieght = data["height_unit_list"]as? [[String:Any]]{
                    self.arrheight.removeAll()
                    
                    for dic in hieght{
                        let obj = height_unit_listModel.init(dict: dic)
                        self.arrheight.append(obj)
                        print(obj)
                    }
                    self.DescriptionPicke.reloadAllComponents()
                    
                }
                if let arrother = data["weight_unit_list"]as? [[String:Any]]{
                    self.arrWeight.removeAll()
                    
                    for dic in arrother{
                        let obj = weightUnitListModel.init(dict: dic)
                        self.arrWeight.append(obj)
                        print(obj)
                    }
                    self.DescriptionPicke.reloadAllComponents()
                }
                
                if let lenght = data["length_unit_list"]as? [[String:Any]]{
                    self.arrlenght.removeAll()
                    
                    for dic in lenght{
                        let obj = length_unit_listModel.init(dict: dic)
                        self.arrlenght.append(obj)
                        print(obj)
                    }
                    self.DescriptionPicke.reloadAllComponents()
                }
                
                if let width = data["width_unit_list"]as? [[String:Any]]{
                    self.arrwidth.removeAll()
                    
                    for dic in width{
                        let obj = width_unit_listModel.init(dict: dic)
                        self.arrwidth.append(obj)
                        print(obj)
                    }
                    self.DescriptionPicke.reloadAllComponents()
                }
                
                
                self.DescriptionPicke.reloadAllComponents()
                self.tblDeleveryType.reloadData()
                
            }else{
                objWebServiceManager.hideIndicator()
                objWebServiceManager.hideIndicator()
                objAppShareData.showAlert(title: kAlertTitle, message: message , view: self)
            }
        }) { (error) in
            print(error)
            objWebServiceManager.hideIndicator()
            objAppShareData.showAlert(title: kAlertTitle, message: kErrorMessage, view: self)
        }
    }
    
    func callWebCreateQuotes(){
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAppShareData.showNetworkAlert(view:self)
            return
        }
        objWebServiceManager.showIndicator()
        self.view.endEditing(true)
        
        txtNote.text = txtNote.text.trimmingCharacters(in: .whitespacesAndNewlines)
        let desc = self.txtNote.text ?? ""
        trimDescription = desc.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines).filter{!$0.isEmpty}.joined(separator: "\n")
        
        print(trimDescription)
        
        let param = [
            WsParam.from_location :txtFromLocation.text ?? "",
            WsParam.to_location :txtToLocation.text ?? "",
            WsParam.from_latitude :strfromLatitude,
            WsParam.to_latitude :strToLatitude,
            WsParam.from_longitude :strfromLongitude,
            WsParam.to_longitude :strToLongitude,
            WsParam.length :txtlenghtcm.text ?? "",
            WsParam.height :txtHeigthLbs.text ?? "",
            WsParam.width :txtWidthCm.text ?? "",
            WsParam.weight :txtWightKg.text ?? "",
            WsParam.length_unit:lenghtUnit,
            WsParam.width_unit:WidthUnit,
            WsParam.weight_unit:WightUnit,
            WsParam.height_unit:HightUnit,
            WsParam.description :trimDescription,
            WsParam.delivery_date :txtDeleDateRequested.text ?? "",
            WsParam.delivery_time :deliveryTime,
            WsParam.delivery_type :id,
            
            ] as [String : Any]
        print(param)
        
        let imageParam  =  [WsParam.photo ] as [String]
        var imgData = Data()
        var arrImageData = [Data]()
        
        if self.imgUploaded.image ==  nil
        {
            print("BlankImage")
        }
        else
        {
            imgData = (self.imgUploaded.image?.pngData())!
            arrImageData.append(imgData) 
        }
        
        objWebServiceManager.uploadMultipartMultipleImagesData(strURL: WsUrl.getDelivery, params: param, showIndicator: false, imageData: nil, imageToUpload: arrImageData, imagesParam:imageParam, fileName: nil, mimeType: "image/*", success: { (response) in
            
            
            let status = (response["status"] as? String)
            let message = (response["message"] as? String)
            print(param)
            if status == k_success{
                objWebServiceManager.hideIndicator()
                if (response["data"]as? [String:Any]) != nil{
                    
                    objAppShareData.showAlert(title: kAlertTitle, message: message ?? "", view: self)
                    self.txtToLocation.text = ""
                    self.txtlenghtcm.text = ""
                    self.txtHeigthLbs.text = ""
                    self.txtWidthCm.text = ""
                    self.txtWightKg.text = ""
                    self.txtNote.text = ""
                    self.trimDescription = ""
                    self.txtDeleTimeRequested.text = ""
                    self.txtDeleDateRequested.text = ""
                    self.imgUploaded.image = nil
                    self.imgCamera.isHidden = true
                    self.imgDefault.isHidden = false
                    self.btnClearSelectedImage.isHidden = true
                    self.txtDeliveryType.text = ""
                    self.deliveryDate = ""
                    self.deliveryTime = ""
                    self.id = ""
                    objAppShareData.SelectedTypeDate.removeAll()
                    self.tblDeleveryType.reloadData()
                }
            }else{
                objWebServiceManager.hideIndicator()
                objAppShareData.showAlert(title: kAlertTitle, message: message ?? "", view: self)
            }
        }, failure: { (error) in
            // print(error)
            
            objWebServiceManager.hideIndicator()
            objAppShareData.showAlert(title: kAlertTitle, message: kErrorMessage, view: self)
        })
    }
}

