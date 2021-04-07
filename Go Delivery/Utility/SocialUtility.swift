//
//  SocialUtility.swift
//  Go Delivery
//  Created by MACBOOK-SHUBHAM V on 14/09/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.

import Foundation
import UIKit
import FacebookLogin
import FBSDKLoginKit
import Social
import GoogleSignIn

class SocialUtility: NSObject {
    
    typealias SignInCompletionHandler = (_ sucess :Bool,_ userDict :NSDictionary?)-> Void
    
    typealias GetFBFriendsCompletionHandler = (_ sucess :Bool,_ friendsArray :NSDictionary?)-> Void
    var _completionHandler:SignInCompletionHandler?
    var _fbFriendsCompletionHandler:GetFBFriendsCompletionHandler?
    
    var actionSheetview:UIView?
    static let shared: SocialUtility = {
        let instance = SocialUtility()
        // setup code
        return instance
    }()
    
    var dictDataGmail = [String: Any]()
    
    var dataArray = [String]()
    var rowSelected: ((_ title: String,_ indexSelected:Int)->())?
    var dateSelected: (()->())?
    var completion: ((_ isDoneClicked: Bool)->())?
    
    
    //Taking User's basic info from Facebook
    
    class func getFacebookProfileInfo(completionHandler:@escaping SignInCompletionHandler) {
        let requestMe: GraphRequest = GraphRequest(graphPath: "me", parameters: ["fields": "picture.type(large), name, gender, email, first_name, last_name, cover,birthday"])
        let connection: GraphRequestConnection = GraphRequestConnection()
        connection.add(requestMe) { (FBSDKGraphRequestConnection, result, error) in
            if (result != nil) {
                let dicFbData: NSDictionary = result as! NSDictionary
                print("dicFbData \(dicFbData)")
                DispatchQueue.main.async(execute: {
                    completionHandler(true, dicFbData)
                })
            } else {
                DispatchQueue.main.async(execute: {
                    completionHandler(false,nil)
                })
            }
        };
        connection.start()
    }
    
    //MARK:- FaceBook Login
    
    func getFacebookData(sender: UIViewController, completionHandler:SignInCompletionHandler?, isForFBFriends: Bool, completionHandlerFriends:GetFBFriendsCompletionHandler?){
      
        
        if completionHandler != nil{
            _completionHandler = completionHandler
        }else{
            _fbFriendsCompletionHandler = completionHandlerFriends
        }

        if (AccessToken.current == nil) {
            let objFBSDKLoginManager : LoginManager = LoginManager()
            objFBSDKLoginManager.logIn(permissions:["public_profile", "email"], from: sender)  { (result, error) -> Void in
            
               
                print("\(error as Optional))")
                if (error != nil) {
                    DispatchQueue.main.async(execute: {
                        if completionHandler != nil{
                            self._completionHandler!(false,nil)
                            
                        }else{
                            self._fbFriendsCompletionHandler!(false, nil)
                            
                        }
                    })
                }else if (result?.isCancelled)!{
                    DispatchQueue.main.async(execute: {
                        if completionHandler != nil{
                            self._completionHandler!(false,nil)
                        }else{
                            self._fbFriendsCompletionHandler!(false, nil)
                            
                        }
                    })
                }else{
                    if isForFBFriends == false{
                        self.getFacebookProfileInfo()
                    }else{
                        self.getFaceBookFriends()
                    }
                }
            }
        }else{
            if isForFBFriends == false{
                self.getFacebookProfileInfo()
            }else{
                self.getFaceBookFriends()
            }
        }
    }
    
    func normalFacebookLogin(sender: UIViewController, completionHandler:SignInCompletionHandler?, isForFBFriends: Bool, completionHandlerFriends:GetFBFriendsCompletionHandler?){
        let fbLoginManager : LoginManager = LoginManager()
        fbLoginManager.logIn(permissions: ["email","public_profile"], from: sender) { (result, error) in
    if (error == nil){
        let fbloginresult : LoginManagerLoginResult = result!
      
    if fbloginresult.grantedPermissions != nil {
    if(fbloginresult.grantedPermissions.contains("public_profile"))
    {
    //self.getFBUserData()
    //fbLoginManager.logOut()
    }
    }
    }else{
          print(error)
        }
    }
}
    //Taking User's basic info from Facebook
    func getFacebookProfileInfo()
    {
        let requestMe: GraphRequest = GraphRequest(graphPath: "me", parameters: ["fields": "picture.type(large), name, gender, email, first_name, last_name,birthday"])
        let connection: GraphRequestConnection = GraphRequestConnection()
        connection.add(requestMe) { (FBSDKGraphRequestConnection, result, error) in
            if (result != nil){
                let dicFbData: NSDictionary = result as! NSDictionary
                print("dicFbData \(dicFbData)")
                DispatchQueue.main.async(execute: {
                    self._completionHandler!(true,dicFbData)
                })
            }else{
                DispatchQueue.main.async(execute: {
                    self._completionHandler!(false,nil)
                })
            }
        };
        connection.start()
    }
    
    //getFaceBookFriends function is used to take Fb user firnds list
    func getFaceBookFriends()
    {
        let params = ["fields": "id, name, picture"]
        
        let request = GraphRequest(graphPath:"/me/friends?limit=5000", parameters: params)
        _ = request.start(completionHandler: {(connection, result, error) -> Void in
            if error == nil {
                print("Friends are : \(result ?? "")")
                self._fbFriendsCompletionHandler!(true, result as? NSDictionary)
            } else {
                print("Error Getting Friends \(error as Optional))");
                self._fbFriendsCompletionHandler!(false, nil)
            }
        })
    }
}

//MARK:- Gmail Login

extension SocialUtility:GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
          withError error: Error!) {
    
    if (error) != nil {
        self._completionHandler!(false,nil)
    }else {
        // SVProgressHUD.show()
        
        let userId = user.userID                  // For client-side use only!
        //   strSocial_Id = user.userID
        _ = user.authentication.idToken // Safe to send to the server
        let fullName = user.profile.name
        let email = user.profile.email
        let dimension = round(200 * UIScreen.main.scale)
        let pic = user.profile.imageURL(withDimension: UInt(dimension))
        let urlString = pic!.absoluteString
        dictDataGmail = ["userId": userId!,"fullName":fullName!,"email":email!,"profileImage":urlString]
        print(dictDataGmail)
        GIDSignIn.sharedInstance().signOut();
        DispatchQueue.main.async(execute: {
            self._completionHandler!(true,self.dictDataGmail as NSDictionary)
        })
        // SVProgressHUD.show()
        
    }}


    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
          withError error: Error!) {
        self._completionHandler!(false,nil)

    // Perform any operations when the user disconnects from app here.
    }
    func sign(_ signIn: GIDSignIn!,present viewController: UIViewController!) {
        //APP_DELEGATE.window?.rootViewController?.present(viewController, animated: true, completion: nil)
    }
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        //APP_DELEGATE.window?.rootViewController?.dismiss(animated: false, completion: nil)
    }
   
   func getGmailData(sender: UIViewController, completionHandler:SignInCompletionHandler?){
        GIDSignIn.sharedInstance()?.delegate = self
//GIDSignIn.sharedInstance()?.uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
        _completionHandler = completionHandler
    }
    
    

    
}
