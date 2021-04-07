//
//  File.swift
//  Hoggz
//  Created by MACBOOK-SHUBHAM V on 26/12/19.
//  Copyright © 2019 MACBOOK-SHUBHAM V. All rights reserved.
//  File.swift
//  Hoggz
//  Created by MACBOOK-SHUBHAM V on 26/12/19.
//  Copyright © 2019 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit
import UIKit
import MobileCoreServices
import SVProgressHUD
import AVFoundation
import SVProgressHUD



// convenience GoogleAppkey - AIzaSyBj6W7zUHkvo3H74j7ihnpNxVMfxPsoBHk
       // go delivery Goole app key -AIzaSyDci0pAqq4R3J8pzZQv1bnED9mZATdioQs
       // twitter intregation consumer key
       //let ConsumerKey = "TIM4GPHiD8FAot3Od5wAe8wBx"
       //let consumerSecret = "WfFhxS9SwgjzHdXk6BQnqHURIISDdS8ssb3Wnyv9cT8BU52ZA2"
       //FirebaseApp.configure()
       //Braintree for paypal
       
       //AIzaSyC4Q5zPft2_JIR1ZXQJCui4kogy6BYm49I

// GoDeliveryDev Firebase Server key - AAAAyX4iN_I:APA91bHO0YRAmI1dQT6l3LqO5LmA-9dTvCP3DwOFXQ_mqABs_Mzt0qOug7tXaIHAtIcASVHfM__J4Kt1egomgxEzw5ciPhReCXcF01_CpXrs7QvfVTZk0mPSo9mucVv9CfTduPHAJipB


// GoDeliverylive  Firebse Server Key -  AAAA7Q1hqwM:APA91bEUDtG-c9TkMTulBOhvEfiZEs7JguzzZckDOCe3vdmhU80zZTb2kgnziBGx2Ho6D4Ly-0TtxFEqA0DUwrQYUzUrP6rb7aZ5or3rtQt5NrXZoXVFhBqi8AHO4sHNF3caQ5_iB9fc




class AppSharedClass: NSObject {
    
    static let shared = AppSharedClass()
    
    var successBlock : ((_ placeInfo: [String: Any])->())?
    var failureBlock : ((_ error: Error)->())?
    var controller: UIViewController?
    var imagePicker = UIImagePickerController()
    var isFromSignup = false
    var isFromLogin = false
    var strLat = ""
    var strLong = ""
    var kServerKey = ""
    //    var isfromLoginSocialsignup = false
    //    var isfromSignupSocialsignup = false
    var isFromSocialcase = false
    var isfromFacebookLgin = false
   
    var isFromNotification = false
    
    var strUserType = ""
    
    
    var strDpFirstName = ""
    var strDpMiddleName = ""
    var strDpLastName = ""
    var strDpRating = ""
    var strDpprofile = ""
    var strNewContractFormUploaded = ""


    
    var isFromFirebaseDynamicLink = false
 //   var userDetail : UserDetailModel?
    
    var userDetail = UserDetailModel(dict: [:])
    var arrGeneralList = [GeneralListModel]()
    var SelectedTypeDate = [deliveryListTypeModel]()
    var strDeliveryPersonUserdetails   = MyProfileModel(dict: [:])// dp profile
    
    
    
    var strNotificationType = ""
    var strFirebaseToken = ""
    var strNotificationAlertId = ""
    
    
    //
    var isreadStatus = ""
    
    
    var strDeeplinkDeliveryId = ""
    var strDeepLinkUserId = ""

    var strNotificationId = ""
    
    var notificationDict = [String:Any]()
    var socialStatus = 3
    
    //    var strExcerciseVideo = ""
    //    var strTotalTime = ""
    //    var strIntroTime = ""
    //    var strExcerciseVideoThumb = ""
    //    var strExcerciseId = ""
    //    var strExcerciseTitle = ""
    
    var isFromTutorial = false
    // var objExcercise:ExcerciseVideoModel?
    
    override init() {
        super.init()
    }
    
    func getCurrentTimeZone() -> String{
        return TimeZone.current.identifier
    }
    
    func setView(view: UIView, hidden: Bool) {
        UIView.transition(with: view, duration: 1.0, options: .transitionCrossDissolve, animations: {
            view.isHidden = hidden
        })
    }
    
    
    func fireNotification() {
        let currentDate = Date()
        
        let content = UNMutableNotificationContent()
        content.title = "Reminder"
        content.body = "your excercise start in sometime"
        
        content.sound = UNNotificationSound.default
        let calendar = Calendar.current
        
        var component = calendar.dateComponents([.year,.month,.day,.hour,.minute], from: currentDate)
        component.hour = 17
        component.minute = 00
        print(component.month,component.year,component.day,component.hour,component.minute)
        let trigger = UNCalendarNotificationTrigger(dateMatching: component, repeats: true)
        // let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
        let request = UNNotificationRequest(identifier:
            "@1276", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { [weak self] (error) in
            if let err = error{
                print("error in scheduling notoification \(err.localizedDescription)")
                return
            }
            
            DispatchQueue.main.async {
                print("Local notification scheduled.")
            }
        }
        
    }
    
    
    func changeDateFormatter(date:String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?

        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let dt = dateFormatter.date(from: date) //{
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "d MMM yyyy  hh:mm a"
        return dateFormatter.string(from: dt ?? Date())
    }
    

   func compress_Image(image:UIImage) -> Data? {
       // Reducing file size to a 10th
       var actualHeight : CGFloat = image.size.height
       var actualWidth : CGFloat = image.size.width
       let maxHeight : CGFloat = 1000.0
       let maxWidth : CGFloat = 1000.0
       let minHeight : CGFloat = 1000.0
       let minWidth : CGFloat = 1000.0
       var imgRatio : CGFloat = actualWidth/actualHeight
       let maxRatio : CGFloat = maxWidth/maxHeight
       let minRatio : CGFloat = minWidth/minHeight
       var compressionQuality : CGFloat = 0.5
       
       if (actualHeight > maxHeight || actualWidth > maxWidth){
           if(imgRatio < maxRatio){
               //adjust width according to maxHeight
               imgRatio = maxHeight / actualHeight
               //                      actualWidth = imgRatio * actualWidth
               //                      actualHeight = maxHeight
               actualWidth = 1000
               actualHeight = 1000
               
           }
           else if(imgRatio > maxRatio){
               //adjust height according to maxWidth
               imgRatio = maxWidth / actualWidth
               //                      actualHeight = imgRatio * actualHeight
               //                      actualWidth = maxWidth
               actualHeight = 1000
               actualWidth = 1000
           }
           else{
               actualHeight = maxHeight
               actualWidth = maxWidth
               compressionQuality = 1
           }
       }
       
       if (actualHeight < minHeight || actualWidth < minWidth){
           if(imgRatio > minRatio){
               //adjust width according to maxHeight
               imgRatio = minHeight / actualHeight
               //                   actualWidth = imgRatio * actualWidth
               //                   actualHeight = minHeight
               actualWidth = 1000
               actualHeight = 1000
           }
           else if(imgRatio < minRatio){
               //adjust height according to maxWidth
               imgRatio = minWidth / actualWidth
               actualHeight = 1000
               actualWidth = 1000
           }
           else{
               actualHeight = minHeight
               actualWidth = minWidth
               compressionQuality = 1
           }
       }
       let rect = CGRect(x: 0.0, y: 0.0, width: actualWidth, height: actualHeight)
       UIGraphicsBeginImageContext(rect.size)
       image.draw(in: rect)
       guard let img = UIGraphicsGetImageFromCurrentImageContext() else {
           return nil
       }
       UIGraphicsEndImageContext()
       guard let imageData = img.jpegData(compressionQuality: compressionQuality)else{
           return nil
       }
       return imageData
   }
   
    
    func compressImage (_ image: UIImage) -> UIImage {
        
        let actualHeight:CGFloat = image.size.height
        let actualWidth:CGFloat = image.size.width
        let imgRatio:CGFloat = actualWidth/actualHeight
        let maxWidth:CGFloat = 500.0
        let resizedHeight:CGFloat = maxWidth/imgRatio
        let compressionQuality:CGFloat = 0.5
        
        let rect:CGRect = CGRect(x: 0, y: 0, width: maxWidth, height: resizedHeight)
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in: rect)
        let img: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        let imageData:Data = img.jpegData(compressionQuality: compressionQuality)!
        UIGraphicsEndImageContext()
        return UIImage(data: imageData)!
    }
    
    //MARK: - For validation Alerts
    func showAlert(title:String, message:String,view:UIViewController){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let subView = alert.view.subviews.first!
        let alertContentView = subView.subviews.first!
        // alertContentView.tintColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        alertContentView.layer.cornerRadius = 20
        let action = UIAlertAction(title: k_OK, style: .default, handler: nil)
        alert.addAction(action)
        view.present(alert, animated: true, completion: nil)
    }
    
    func showLogoutAlert(view:UIViewController){
        
        let alert = UIAlertController(title: "Confirm", message: " Do you want to Logout?", preferredStyle: UIAlertController.Style.alert)
        // let subView = alert.view.subviews.first!
        //let alertContentView = subView.subviews.first!
        // alertContentView.tintColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        let okAction = UIAlertAction(title: "Yes", style: .destructive) {
            UIAlertAction in
            self.callWSFor_logout()
        }
        
        let cancelAction = UIAlertAction(title: "No", style: UIAlertAction.Style.default) {
            UIAlertAction in
        }
        
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        //   alert.show()
        view.present(alert, animated: true, completion: nil)
    }
    
    func showNetworkAlert(view:UIViewController){
        let alert = UIAlertController(title: k_noNetwork, message: k_networkAlert, preferredStyle: .alert)
        let subView = alert.view.subviews.first!
        let alertContentView = subView.subviews.first!
        //   alertContentView.tintColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        let action = UIAlertAction(title: k_OK, style: .default, handler: nil)
        alert.addAction(action)
        view.present(alert, animated: true, completion: nil)
    }
    
    func showAlertVC(title:String,message:String,controller:UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        //let subView = alertController.view.subviews.first!
        // let alertContentView = subView.subviews.first!
        //   alertContentView.tintColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        let OKAction = UIAlertAction(title: k_OK, style: .default, handler: nil)
        alertController.addAction(OKAction)
        controller.present(alertController, animated: true, completion: nil)
    }
    
    func sessionExpireAlertVC(controller:UIViewController,alertTitle:String,alertMessage:String) {
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: k_OK, style: .default, handler: {(_ action: UIAlertAction) -> Void in
            
            ObjAppdelegate.loginNavigation()
        })
        alertController.addAction(OKAction)
        controller.present(alertController, animated: true, completion: nil)
    }
    
    // Session Expired Alert Show...
    func showSessionFailAlert() {
        objWebServiceManager.hideIndicator()
        let alert = UIAlertController(title: "Session Expired", message: "Please Login Again", preferredStyle: .alert)
        let yesButton = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            
            ObjAppdelegate.loginNavigation()
        })
        alert.addAction(yesButton)
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    func showErrorAlert(strMessage:String) {
        let alert = UIAlertController(title: kAlertTitle, message: strMessage, preferredStyle: .alert)

        let OKAction = UIAlertAction(title: k_OK, style: .default, handler: nil)
        alert.addAction(OKAction)
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    
    
    
    
    // Alert call back function
    func showAlertCallBack(alertLeftBtn:String, alertRightBtn:String,  title: String, message: String ,controller: UIViewController, callback: @escaping (_ isAlertRightBtn:Bool) -> ()) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: alertRightBtn, style: .default, handler: {
            alertAction in
            callback(true)
            
        }))
        alert.addAction(UIAlertAction(title:alertLeftBtn, style: .cancel, handler: {
            alertAction in
            callback(false)
            
            
        }))
        
        controller.present(alert, animated: true, completion: nil)
    }
    
    func showAlertCallBackother(alertLeftBtn:String, alertRightBtn:String,  title: String, message: String ,controller: UIViewController, callback: @escaping (_ isAlertRightBtn:Bool) -> () , callbackCancel:@escaping()  -> ()) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: alertRightBtn, style: .default, handler: {
            alertAction in
            callback(true)
        }))
        alert.addAction(UIAlertAction(title:alertLeftBtn, style: .cancel, handler: {
            alertAction in
            
            callbackCancel()
            
        }))
        
        controller.present(alert, animated: true, completion: nil)
    }
    
    
    
    
    func showAlertCallBackOk(alertLeftBtn:String,  title: String, message: String ,controller: UIViewController , callbackCancel:@escaping()  -> ()) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title:alertLeftBtn, style: .cancel, handler: {
            alertAction in
            
            callbackCancel()
            
        }))
        
        controller.present(alert, animated: true, completion: nil)
    }
    
    
    // For alert show on UIWindow if you have no Viewcontroller then show this alert.
    func showAlertVc(message: String = "", title: String , controller: UIWindow) {
        DispatchQueue.main.async(execute: {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            let subView = alertController.view.subviews.first!
            let alertContentView = subView.subviews.first!
            alertContentView.backgroundColor = UIColor.gray
            alertContentView.layer.cornerRadius = 20
            
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(OKAction)
            
            
            UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
        })
    }
    
    
    
    func showAlert(message: String = "", title: String , controller: UIWindow) {
        DispatchQueue.main.async(execute: {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let subView = alertController.view.subviews.first!
            let alertContentView = subView.subviews.first!
            alertContentView.backgroundColor = UIColor.gray
            alertContentView.layer.cornerRadius = 20
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(OKAction)
            UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
        })
    }
    
    
    
    
    
}




//MARK:- Image Picker

extension AppSharedClass{
    
    func openImagePicker(controller: UIViewController, success: @escaping ([String: Any])->(), failure: @escaping (Error)-> ()) {
        self.successBlock = success
        self.failureBlock = failure
        self.controller = controller
        self.imagepick()
    }
    
    func imagepick() {
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            self.openCamera()
        }
        let galleryAction = UIAlertAction(title: "Gallery", style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            self.openGallery()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
        {
            UIAlertAction in
        }
        
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
        self.controller?.modalPresentationStyle = .overCurrentContext
        self.controller?.present(alert, animated: true, completion: nil)
    }
    
    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            self.imagePicker.sourceType = UIImagePickerController.SourceType.camera
            self.imagePicker.allowsEditing = false
            self.imagePicker.delegate = self
            self.imagePicker.mediaTypes = [kUTTypeImage as String]
            self.controller?.present(self.imagePicker, animated: true, completion: nil)
        }
    }
    
    func openGallery(){
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            self.imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.imagePicker.allowsEditing = false
            self.imagePicker.delegate = self
            self.imagePicker.mediaTypes = [kUTTypeImage as String]
            self.imagePicker.modalPresentationStyle = .fullScreen
            self.controller?.present(self.imagePicker, animated: true, completion: nil)
        }
    }
}

//MARK:- Image Picker for Video

extension AppSharedClass{
    func openImagePickerForVideo(controller: UIViewController, success: @escaping ([String: Any])->(), failure: @escaping (Error)-> ()) {
        self.successBlock = success
        self.failureBlock = failure
        self.controller = controller
        self.imagePickForVideo()
    }
    
    func imagePickForVideo() {
        let alert:UIAlertController=UIAlertController(title: "Choose Video", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            self.openCameraForVideo()
        }
        let galleryAction = UIAlertAction(title: "Gallery", style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            self.openVideoGallery()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
        {
            UIAlertAction in
        }
        
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
        self.controller?.present(alert, animated: true, completion: nil)
    }
    
    func openCameraForVideo(){
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            self.imagePicker.sourceType = UIImagePickerController.SourceType.camera
            self.imagePicker.allowsEditing = true
            self.imagePicker.delegate = self
            self.imagePicker.mediaTypes = [kUTTypeMovie as String]
            self.controller?.present(self.imagePicker, animated: true, completion: nil)
        }
    }
    
    func openVideoGallery(){
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            self.imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.imagePicker.allowsEditing = true
            self.imagePicker.delegate = self
            self.imagePicker.mediaTypes = [kUTTypeMovie as String]
            self.controller?.present(self.imagePicker, animated: true, completion: nil)
        }
    }
}


//MARK:- Image picker Controller Delegate

extension AppSharedClass:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.controller?.dismiss(animated: true, completion: nil)
        self.successBlock = nil
        self.failureBlock = nil
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        self.controller?.dismiss(animated: true, completion: nil)
        var dict  = [String: Any]()
        dict["image"] = info[.originalImage]
        dict["imageUrl"] = info[.mediaURL]
        print("media info",dict)
        self.successBlock?(dict)
        self.successBlock = nil
        self.failureBlock = nil
    }
    
    //MARK:- checkCameraPermissions
    func checkCameraPermissions(handler:(Bool)->Void) {
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch authStatus {
        case .authorized:
            print("Allowed")
            handler(true)
        case .denied:
            handler(false)
            alertPromptToAllowCameraAccessViaSetting()
        default:
            print("Allowed")
            handler(true)
        }
    }
    
    func alertPromptToAllowCameraAccessViaSetting() {
        let alert = UIAlertController(title: "Camera access required", message: "Camera access is disabled please allow from Settings.", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", tableName: nil, comment: ""), style: .cancel))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Settings", tableName: nil, comment: ""), style: .default) { (alert) -> Void in
            //UIApplication.shared.openURL(URL(string: UIApplication.UIApplicationOpenSettingsURLString)!)
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options:  [:], completionHandler: nil)
            
        })
        alert.show()
    }
}

extension AppSharedClass {
    
    func callWSFor_logout(){
    
                objWebServiceManager.showIndicator()
          let   param = [
                  WsParam.user_id: objAppShareData.userDetail.strUserID,
                  ] as [String : Any]
        
                print(param)
        
                objWebServiceManager.requestGet(strURL: WsUrl.logout, params: param, queryParams: [:], strCustomValidation: "", success: { (response) in
                    print(response)
                    objWebServiceManager.hideIndicator()
                    let code = response["status_code"] as? Int ?? 000
        
                    if code == 200{
                        ObjAppdelegate.loginNavigation()
                    }else{
                    }
                }) { (error) in
                    print(error)
                    objWebServiceManager.hideIndicator()
                }
         }
}

extension AppSharedClass
{

       // MARK: - saveUpdateUserInfoFromAppshareData ---------------------
       func SaveUpdateUserInfoFromAppshareData(userDetail:[String:Any])
       {
        
        var userDetailRemoveNull = [String:Any]()
        
           userDetailRemoveNull = self.removeNSNull(from: userDetail);
           do {
               let archived = try NSKeyedArchiver.archivedData(withRootObject: userDetailRemoveNull, requiringSecureCoding: false)
               
               UserDefaults.standard.set(archived, forKey: UserDefaults.KeysDefault.userInfo)
               
           } catch { print(error) }
           
       }

    // MARK: - FetchUserInfoFromAppshareData -------------------------
     func fetchUserInfoFromAppshareData()
     {
         
         if let unarchivedObject = UserDefaults.standard.object(forKey:UserDefaults.KeysDefault.userInfo) as? NSData {
             do {
                 let records  = try NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSDictionary.self, Record.self], from:  unarchivedObject as Data)
                 print("records----- \(records ?? [:])")
                 userDetail = UserDetailModel.init(dict: records as? [String: Any] ?? [:])
               // userDetail = self.removeNSNull(from: userDetail);

             } catch { print(error) }
         }

     }
    
    func resetDefaultsAlluserInfo(){
           let defaults = UserDefaults.standard
           let myVenderId = defaults.string(forKey:UserDefaults.KeysDefault.strVenderId)
           let fcmDevceToken = defaults.string(forKey:UserDefaults.KeysDefault.deviceToken)

           let dictionary = defaults.dictionaryRepresentation()
           dictionary.keys.forEach { key in
               defaults.removeObject(forKey: key)
           }
           
           if let bundleID = Bundle.main.bundleIdentifier {
               UserDefaults.standard.removePersistentDomain(forName: bundleID)
           }
           
           defaults.set(fcmDevceToken, forKey:UserDefaults.KeysDefault.deviceToken)
           defaults.set(myVenderId ?? "", forKey:UserDefaults.KeysDefault.strVenderId)
           userDetail = UserDetailModel(dict: [:])
       }
    
    
    func removeNSNull(from dict: [String: Any]) -> [String: Any] {
        var mutableDict = dict
        
        let keysWithEmptString = dict.filter { $0.1 is NSNull }.map { $0.0 }
        for key in keysWithEmptString {
            mutableDict[key] = ""
            print(key)
        }
        return mutableDict
    }
    
    // Array to json formate convert
    func json(from arrayAdtionalEmail:[String]) -> String? {
        
        var myJsonString = ""
        do {
            let data =  try JSONSerialization.data(withJSONObject:arrayAdtionalEmail, options: .prettyPrinted)
            myJsonString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
        } catch {
            print(error.localizedDescription)
        }
        return myJsonString
    }
  
}



extension UIImage {
    func fixOrientation() -> UIImage? {
        if self.imageOrientation == UIImage.Orientation.up {
            return self
        }
        
        UIGraphicsBeginImageContext(self.size)
        self.draw(in: CGRect(origin: .zero, size: self.size))
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return normalizedImage
    }
    
    //MARK:- Image rotation extension code

    func fixedOrientation() -> UIImage {
    // No-op if the orientation is already correct
    if (imageOrientation == UIImage.Orientation.up) {
    return self
    }
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    var transform:CGAffineTransform = CGAffineTransform.identity

    if (imageOrientation == UIImage.Orientation.down
    || imageOrientation == UIImage.Orientation.downMirrored) {

    transform = transform.translatedBy(x: size.width, y: size.height)
    transform = transform.rotated(by: CGFloat(Double.pi))
    }

    if (imageOrientation == UIImage.Orientation.left
    || imageOrientation == UIImage.Orientation.leftMirrored) {

    transform = transform.translatedBy(x: size.width, y: 0)
    transform = transform.rotated(by: CGFloat(Double.pi/2))
    }

    if (imageOrientation == UIImage.Orientation.right
    || imageOrientation == UIImage.Orientation.rightMirrored) {

    transform = transform.translatedBy(x: 0, y: size.height);
    transform = transform.rotated(by: CGFloat(-Double.pi/2));
    }

    if (imageOrientation == UIImage.Orientation.upMirrored
    || imageOrientation == UIImage.Orientation.downMirrored) {

    transform = transform.translatedBy(x: size.width, y: 0)
    transform = transform.scaledBy(x: -1, y: 1)
    }

    if (imageOrientation == UIImage.Orientation.leftMirrored
    || imageOrientation == UIImage.Orientation.rightMirrored) {

    transform = transform.translatedBy(x: size.height, y: 0);
    transform = transform.scaledBy(x: -1, y: 1);
    }

    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    let ctx:CGContext = CGContext(data: nil, width: Int(size.width), height: Int(size.height),
    bitsPerComponent: cgImage!.bitsPerComponent, bytesPerRow: 0,
    space: cgImage!.colorSpace!,
    bitmapInfo: cgImage!.bitmapInfo.rawValue)!

    ctx.concatenate(transform)


    if (imageOrientation == UIImage.Orientation.left
    || imageOrientation == UIImage.Orientation.leftMirrored
    || imageOrientation == UIImage.Orientation.right
    || imageOrientation == UIImage.Orientation.rightMirrored
    ) {


    ctx.draw(cgImage!, in: CGRect(x:0,y:0,width:size.height,height:size.width))

    } else {
    ctx.draw(cgImage!, in: CGRect(x:0,y:0,width:size.width,height:size.height))
    }

    // And now we just create a new UIImage from the drawing context
    let cgimg:CGImage = ctx.makeImage()!
    let imgEnd:UIImage = UIImage(cgImage: cgimg)

    return imgEnd
    }
    

    func jpeg(_ quality: JPEGQuality) -> Data? {
    //return UIImageJPEGRepresentation(self, quality.rawValue)
    return jpegData(compressionQuality: quality.rawValue)
    }


    enum JPEGQuality: CGFloat {
    case lowest = 0
    case low = 0.2
    case medium = 0.4
    case high = 0.6
    case highest = 0.8
    case Original = 1
    }
    
    
}


