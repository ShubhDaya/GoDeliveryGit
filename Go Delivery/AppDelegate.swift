//
//  AppDelegate.swift
//  Go Delivery
//  Created by MACBOOK-SHUBHAM V on 15/07/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//  Latest code

import UIKit
import CoreData
import GooglePlaces
import GoogleMaps
import Braintree
import GoogleSignIn
import FacebookCore
import FacebookLogin
import TwitterKit
import TwitterCore
import Firebase
import FirebaseCore
import FirebaseMessaging
import UserNotifications
import FirebaseDynamicLinks
import FirebaseInstanceID
import IQKeyboardManagerSwift


let ObjAppdelegate = AppDelegate.AppDelegateObject()
//let abc = AppDelegate.AppDelegateObject()

@UIApplicationMain
class AppDelegate: UIResponder,CLLocationManagerDelegate,UIApplicationDelegate,GIDSignInDelegate ,UNUserNotificationCenterDelegate {
    
    var locationManager:CLLocationManager!
    var currentLocation: CLLocation!
    var window: UIWindow?
    var kDeviceToken = ""
    var isappdelegateForgroundManage = false
    
    private static var AppDelegateManager: AppDelegate = {
        let manager = UIApplication.shared.delegate as! AppDelegate
        return manager 
    }()
    // MARK: - Accessors
    class func AppDelegateObject() -> AppDelegate {
        return AppDelegateManager
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //deepLinkURLScheme Configure -
        //BrainTreePayPal Payment URLScheme -
       
        BTAppSwitch.setReturnURLScheme("com.mindiii.Go-Delivery.payments")
        
        isappdelegateForgroundManage = true
        // Place api keys
        GMSServices.provideAPIKey("AIzaSyDuclnUxWGEIRR3O1w66-MogELN3gpR74s")
        GMSPlacesClient.provideAPIKey("AIzaSyDuclnUxWGEIRR3O1w66-MogELN3gpR74s")
                
        // Google Sign in crediential
        GIDSignIn.sharedInstance().clientID = "1018131753731-ntatkql4sro8jfvcvboab71up8ovq37o.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        
        // Twitter sign in
        TWTRTwitter.sharedInstance().start(withConsumerKey:"TIM4GPHiD8FAot3Od5wAe8wBx", consumerSecret:"WfFhxS9SwgjzHdXk6BQnqHURIISDdS8ssb3Wnyv9cT8BU52ZA2")
        
        //Location manager
        self.setupLocationManager()
        
        //self.FireBaseGooglePlistSetUp()
        // Override point for customization after application launch.
        // Fetch userInfo
        objAppShareData.fetchUserInfoFromAppshareData()
        let getudid = getUUID()
        let defaults = UserDefaults.standard
        defaults.set(getudid ?? "", forKey:UserDefaults.Keys.strVenderId)
        if let myString = defaults.string(forKey:UserDefaults.Keys.strVenderId) {
            print("defaults savedString: \(myString)")
        }
        
        FireBaseGooglePlistSetUp()
        self.configureNotification()
        self.registerForRemoteNotification()
        manageNavigationRoot()
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    func getUUID() -> String? {
        // create a keychain helper instance
        let keychain = KeychainAccess()
        // this is the key we'll use to store the uuid in the keychain
        let uuidKey = "DeviceUniqueId"
        // check if we already have a uuid stored, if so return it
        if let uuid = try? keychain.queryKeychainData(itemKey: uuidKey), uuid != nil {
            return uuid
        }
        // generate a new id
        guard let newId = UIDevice.current.identifierForVendor?.uuidString else {
            return nil
        }
        // store new identifier in keychain
        try? keychain.addKeychainData(itemKey: uuidKey, itemValue: newId)
        // return new id
        return newId
    }
    
    func manageNavigationRoot(){
        
        let userID = UserDefaults.standard.value(forKey: UserDefaults.KeysDefault.kUserId)
        let usertype = objAppShareData.userDetail.strUserType
        let token = objAppShareData.userDetail.strAuth_token

        
        if token == ""{
                  self.loginNavigation()
              }else if userID == nil{
                  // for if user in tab bar we check user id
                      self.loginNavigation()
              }else {
                  // if user id not == nil then we naviagte root tab bar
                  if usertype == "customer"{
                      showTabbarNavigation()
                  }else if usertype == "delivery_person"{
                    
                   // self.checkApplicationApprovedStatus()

                    DeliveryPersonTabBar()
                     //showTenantTabbarNavigation()
                  }
              }
    }
    
    func setupLocationManager(){
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        self.locationManager?.requestWhenInUseAuthorization()
        locationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager?.startUpdatingLocation()
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation();
        }
    }
    
    // Below method will provide you current location.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if currentLocation == nil {
            currentLocation = locations.last
            locationManager?.stopMonitoringSignificantLocationChanges()
            let locationValue:CLLocationCoordinate2D = manager.location!.coordinate
            print("locations = \(locationValue)")
            objAppShareData.strLat = String(locationValue.latitude)
            objAppShareData.strLong = String(locationValue.longitude)
            locationManager?.stopUpdatingLocation()
        }
    }
    
    // Below Mehtod will print error if not able to update location.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error")
    }
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
    
        let container = NSPersistentContainer(name: "Go_Delivery")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
         
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}
//MARK:- Manage Root Navigation
extension AppDelegate{
    
    func loginNavigationWithoutDeleteDate(){
        
        let login = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainInitial_VC") as! MainInitial_VC
        let nav = UINavigationController(rootViewController: login)
        nav.setNavigationBarHidden(true, animated: true)
        self.window?.rootViewController = nav
        
    }
    func loginNavigation(){
        self.RemoveDefault()
        
        let login = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainInitial_VC") as! MainInitial_VC
        let nav = UINavigationController(rootViewController: login)
        nav.setNavigationBarHidden(true, animated: true)
        self.window?.rootViewController = nav
    }
    
    func homeNavigation(){
        
        let storyboard:UIStoryboard = UIStoryboard(name: "CustoTabBar", bundle: nil)
        let navigationController = storyboard.instantiateViewController(withIdentifier: "CustomerNav") as? UINavigationController
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
    }
    
    func DeliveryPersonTabBar(){
           
           let storyboard:UIStoryboard = UIStoryboard(name: "DeliveryPersonTab", bundle: nil)
           let navigationController = storyboard.instantiateViewController(withIdentifier: "DeliveryPersonNav") as? UINavigationController
           self.window?.rootViewController = navigationController
           self.window?.makeKeyAndVisible()
       }
    
    func checkApplicationApprovedStatus(){
             
             let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
             let navigationController = storyboard.instantiateViewController(withIdentifier: "ApplicationApprovedStatusVC") as? ApplicationApprovedStatusVC
             self.window?.rootViewController = navigationController
             self.window?.makeKeyAndVisible()
         }
 
    
    func RemoveDefault(){
        
        objAppShareData.resetDefaultsAlluserInfo()
        UserDefaults.standard.removeObject(forKey: UserDefaults.Keys.AuthToken)
        UserDefaults.standard.removeObject(forKey: UserDefaults.Keys.userID)
        UserDefaults.standard.removeObject(forKey: UserDefaults.Keys.user_FirstName)
        UserDefaults.standard.removeObject(forKey: UserDefaults.Keys.user_LastName)
        UserDefaults.standard.removeObject(forKey: UserDefaults.Keys.email)
    }
    
    func showTabbarNavigation() {
        
        let storyboard:UIStoryboard = UIStoryboard(name: "CustoTabBar", bundle: nil)
        let navigationController = storyboard.instantiateViewController(withIdentifier: "CustomerNav") as? UINavigationController
      
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if url.scheme?.localizedCaseInsensitiveCompare("com.mindiii.Go-Delivery.payments") == .orderedSame {
            return BTAppSwitch.handleOpen(url, options: options)
        }
        if TWTRTwitter.sharedInstance().application(app, open: url, options: options){
            return true
        }
        
        GIDSignIn.sharedInstance().handle(url)
        ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
  
            if DynamicLinks.dynamicLinks().shouldHandleDynamicLink(fromCustomSchemeURL: url) {
                let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url)
                self.handleDynamicLink(dynamicLink)
                return true
            }
        
        return false
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
            return
        }
      
    }
}

//MARK:- notification setup
extension AppDelegate{
    func registerForRemoteNotification() {
        // iOS 10 support
        if #available(iOS 10, *) {
            let authOptions : UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options:authOptions){ (granted, error) in
                UNUserNotificationCenter.current().delegate = self
                Messaging.messaging().delegate = self

                let deafultCategory = UNNotificationCategory(identifier: "CustomSamplePush", actions: [], intentIdentifiers: [], options: [])
                let center = UNUserNotificationCenter.current()
                center.setNotificationCategories(Set([deafultCategory]))
            }
        }else {
            
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        UIApplication.shared.registerForRemoteNotifications()
        
        NotificationCenter.default.addObserver(self, selector:
            #selector(tokenRefreshNotification), name:
            .InstanceIDTokenRefresh, object: nil)
 // InstanceIDTokenRefresh
    
    }
    
    func configureNotification() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
            // If granted comes true you can enabled features based on authorization.
            guard granted else { return }
            
            DispatchQueue.main.async {
                UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
}

//MARK: - FireBase Methods / FCM Token
extension AppDelegate:MessagingDelegate {
    
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        // Note: This callback is fired at each app startup and whenever a new token is generated.
        objAppShareData.strFirebaseToken = fcmToken ?? ""
        
        print("objAppShareData.firebaseToken = \(objAppShareData.strFirebaseToken)")
    }

    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        objAppShareData.strFirebaseToken = fcmToken
        ConnectToFCM()
    }
    
    @objc func tokenRefreshNotification(_ notification: Notification) {
        
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instange ID: \(error)")
            }else if let result = result {
                print("Remote instance ID token: \(result.token)")
                objAppShareData.strFirebaseToken = result.token
                print("objAppShareData.firebaseToken = \(result.token)")
            }
        }
        // Connect to FCM since connection may have failed when attempted before having a token.
        ConnectToFCM()
    }
    
    // Receive data message on iOS 10 devices while app is in the foreground.
    func applicationReceivedRemoteMessage(_ remoteMessage: MessagingAPNSTokenType) {
        
    }
  
    func ConnectToFCM() {
        InstanceID.instanceID().instanceID { (result, error) in
            
            if let error = error {
                print("Error fetching remote instange ID: \(error)")
            }else if let result = result {
                print("Remote instance ID token: \(result.token)")
                objAppShareData.strFirebaseToken = result.token
            }
        }
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        if let userInfo = notification.request.content.userInfo as? [String : Any]{
            print(userInfo)
        }
        completionHandler([.alert,.sound,.badge])
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: () -> Void) {
        
        print(response)
        
        switch response.actionIdentifier {
            
        case UNNotificationDismissActionIdentifier:
            print("Dismiss Action")
        case UNNotificationDefaultActionIdentifier:
            print("Open Action")
            if let userInfo = response.notification.request.content.userInfo as? [String : Any]{
                print(userInfo)
                self.handleNotificationWithNotificationData(dict: userInfo)
            }
        case "Snooze":
            print("Snooze")
        case "Delete":
            print("Delete")
        default:
            print("default")
        }
        completionHandler()
    }
    
    func handleNotificationWithNotificationData(dict:[String:Any]){
        
        var notifincationType = ""
        var notificationAlertid = ""
        if let notiType = dict["type"] as? String{
            notifincationType = notiType
        }
        
        if let alert_id = dict["alert_id"] as? String{
            notificationAlertid = alert_id
        }else if let alert_id = dict["alert_id"] as? Int{
            notificationAlertid = String(alert_id)
        }
        
        print(notifincationType)
        print(notificationAlertid)
        objAppShareData.isFromNotification = true
        objAppShareData.strNotificationAlertId = notificationAlertid
        objAppShareData.strNotificationType = notifincationType
        objAppShareData.notificationDict = dict
        
        if objAppShareData.userDetail.strUserType == "customer"{
            self.manageNavigationRoot()
        }else{
            self.manageNavigationRoot()
        }
    }
    
    func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }

    
     func FireBaseGooglePlistSetUp()
        {
            if  BASE_URL.contains("dev"){
          
               FirebaseOptions.defaultOptions()?.deepLinkURLScheme = "godlvrydev.page.link"

                objAppShareData.kServerKey = "key=AAAAPXVdkbw:APA91bGWwhhQYzfbmoZrSCVQqFtdS_4CrG-7hRhHARhc_7SGrroO2sHOvzrgKjlOVa14Hv6A5UdN96PppPXueegPHjRW86kILverfalVnYQjjr11JGkFw0g0LYw-cSXGdo2viDxemqIF"

                let firebaseConfig = Bundle.main.path(forResource: "GoogleService-Info-Dev", ofType: "plist")
                guard let options = FirebaseOptions(contentsOfFile: firebaseConfig!) else {
                    fatalError("Invalid Firebase configuration file.")
                }
                FirebaseApp.configure(options: options)
                Messaging.messaging().delegate = self
            }else{
                
            FirebaseOptions.defaultOptions()?.deepLinkURLScheme = "godeliveryapp.page.link"
            objAppShareData.kServerKey = "key=AAAA7Q1hqwM:APA91bEUDtG-c9TkMTulBOhvEfiZEs7JguzzZckDOCe3vdmhU80zZTb2kgnziBGx2Ho6D4Ly-0TtxFEqA0DUwrQYUzUrP6rb7aZ5or3rtQt5NrXZoXVFhBqi8AHO4sHNF3caQ5_iB9fc"

                let firebaseConfig = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist")
                guard let options = FirebaseOptions(contentsOfFile: firebaseConfig!) else {
                    fatalError("Invalid Firebase configuration file.")
                }
                FirebaseApp.configure(options: options)
                Messaging.messaging().delegate = self
            }
        }
    
    //Mark: - DeepLinking methods -
    
      func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
          if let incomingURL = userActivity.webpageURL {
              print(incomingURL)
              
              let linkHandled = DynamicLinks.dynamicLinks().handleUniversalLink(incomingURL) { (dynamicLink, error) in
                  guard error == nil else {
                      print("Found an error! \(error!.localizedDescription)")
                      return
                  }
                  if let dynamicLink = dynamicLink {
                      self.handleDynamicLink(dynamicLink)
                  }
              }

              if linkHandled {
                  return true
              }
              else {
                  //May be do other things with our incoming URL?
              
                  return false
              }
          }
          return false
      }
      
      func handleDynamicLink(_ dynamicLink: DynamicLink?) {
          guard let url = dynamicLink?.url else {
              
              print("here is no dymanic link")
              return }
          
          print("your incoming link parameter \(url.absoluteString)")
          
          guard let component  = URLComponents(url: url, resolvingAgainstBaseURL: false )  else {
              return
          }
          
        guard let queryItem = component.queryItems else { return  }
          
        print(queryItem)
        print( "Value of  element is \(queryItem[1])" )
        print(Array(queryItem)[0].value ?? "")
        print(Array(queryItem)[1].value ?? "")
        let deepUserID = Array(queryItem)[1].value ?? ""
        objAppShareData.strDeepLinkUserId = deepUserID
        print(objAppShareData.strDeepLinkUserId)

          for qyeryItem in queryItem
          {
              print("parmas \(qyeryItem.name)  has a value of \(String(describing: qyeryItem.value))")
              
            if qyeryItem.name == "user_id"{
                
                let userid =  qyeryItem.value
            }
            
             else  if qyeryItem.name == "delivery_id"
              {
                  objAppShareData.strDeeplinkDeliveryId = qyeryItem.value ?? ""
                  self.redirectionFromDynamicLink()
              }
          }
      }
    
    func redirectionFromDynamicLink()
     {
        objAppShareData.isFromFirebaseDynamicLink = true
  
        let emailVerified = objAppShareData.userDetail.str_is_EmailVerifed
        let userID = objAppShareData.userDetail.strUserID
        let auth = objAppShareData.userDetail.strAuth_token

                     print(userID)
        if   objAppShareData.userDetail.strUserType == "customer"{
            if auth != ""  {
                            if emailVerified == "1" && userID == objAppShareData.strDeepLinkUserId{
                                 self.homeNavigation()
                             }else{
                                objAppShareData.isFromFirebaseDynamicLink = false
                                 self.loginNavigation()
                             }
                         }
                         else{
                            objAppShareData.isFromFirebaseDynamicLink = false
                            self.loginNavigation()
                  }
            
        }else if objAppShareData.userDetail.strUserType == "customer"{
          
            
        }
    }
}

/*
 Client Account -
 wilsonf.2055@gmail.com
 Password: siocnarF@1972

 Facebook Account -
 Name: Go Delivery Plus
 Tele: 2425251555
 Password: Delivery@2020
 Username: https://www.facebook.com/godelivery.plus

 Gmail  Account -
 wilsonf.2055@gmail.com
 nosliW@2791

 Twitter Account -
 GoDeliveryPlus1
 Delivery2020

 wilsonf.2055@gmail.com
 Delivery2020

 Braintree sandbox Account -
 Wilson2055
 siocnarF@1972

 Paypal Account -
 wilsonf.2055@gmail.com
 Password: siocnarF@1972
 
 */
