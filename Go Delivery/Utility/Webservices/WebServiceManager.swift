//
//  WebServiceClass.swift
//  Link
//
//  Created by MINDIII on 10/3/17.
//  Copyright © 2017 MINDIII. All rights reserved.
import UIKit
import Alamofire
import SVProgressHUD


var strAuthToken : String = ""
//let stripeKey = "Bearer sk_test_5LBctxgLZlmgYzB2oCWlw36O00OIq2Kfgg"
let stripeKey = "Bearer sk_test_jVM872jPfk462GPwYDH7mr84"

let objWebServiceManager = WebServiceManager.sharedObject()

class Connectivity {
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}


class WebServiceManager: NSObject {
    
    
    var typeCaseInPDf = ""
    var fileNameCasePdf = ""
    //MARK: - Shared object
    fileprivate var window = UIApplication.shared.keyWindow
    
    private static var sharedNetworkManager: WebServiceManager = {
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.setMinimumDismissTimeInterval(1)
        SVProgressHUD.setRingThickness(3)
        SVProgressHUD.setRingRadius(22)
        
        let networkManager = WebServiceManager()
        return networkManager
    }()
    
    // MARK: - Accessors
    class func sharedObject() -> WebServiceManager {
        return sharedNetworkManager
    }
    
    
    func isNetworkAvailable() -> Bool{
        if !NetworkReachabilityManager()!.isReachable{
            return false
        }else{
            return true
        }
    }
    
    func showNetworkAlert(){
        let alert = UIAlertController(title:"No network" , message:"Please check your internet connection." , preferredStyle: .alert)
        let action = UIAlertAction(title:"OK", style: .default, handler: nil)
        alert.addAction(action)
        alert.show()
    }
    
    //MARK:- Show/hide Indicator
    func showIndicator(){
        //        if #available(iOS 13.0, *) {
        //            SVProgressHUD.setOffsetFromCenter(.init(horizontal: (UIApplication.shared.keyWindow?.center.x)!, vertical: (UIApplication.shared.keyWindow?.center.y)!))
        //        }else {
        //        }
        UIApplication.shared.keyWindow?.isUserInteractionEnabled = false
        SVProgressHUD.show(withStatus: "Please wait..")
    }
    
    func hideIndicator(){
        SVProgressHUD.dismiss()
        UIApplication.shared.keyWindow?.isUserInteractionEnabled = true
    }
    
    //MARK:-get current timezone
    func getCurrentTimeZone() -> String{
        return TimeZone.current.identifier
    }
    
    func queryString(_ value: String, params: [String: Any]) -> String? {
        var components = URLComponents(string: value)
        components?.queryItems = params.map { element in URLQueryItem(name: element.key, value: element.value as? String ) }
        
        return components?.url?.absoluteString
    }
}



//MARK:- Webservice methods
extension WebServiceManager {
    
    //MARK: - Request Post method ----
    
    public func requestPost(strURL:String,queryParams : [String:Any], params : [String:Any], strCustomValidation:String , showIndicator:Bool, success:@escaping(Dictionary<String,Any>) ->Void, failure:@escaping (Error) ->Void) {
        if !objWebServiceManager.isNetworkAvailable(){
            //objWebServiceManager.hideIndicator()
            //objAppShareData.showNetworkAlert()
            return
        }
        
        strAuthToken = ""
        if let token = UserDefaults.standard.string(forKey:UserDefaults.Keys.AuthToken){
            strAuthToken = "Bearer" + " " + token
        }
        
        
        var strUdidi = ""
        if let MyUniqueId = UserDefaults.standard.string(forKey:UserDefaults.Keys.strVenderId) {
            print("defaults VenderID: \(MyUniqueId)")
            strUdidi = MyUniqueId
        }
        
        let currentTimeZone = getCurrentTimeZone()
        
        let header: HTTPHeaders = [
            "Authorization": strAuthToken,
            "Accept": "application/json",
            WsHeader.deviceId:strUdidi,
            WsHeader.deviceType:"1",
            WsHeader.deviceTimeZone: currentTimeZone
        ]
        var StrCompleteUrl = ""
        
        if strCustomValidation ==  WsParamsType.PathVariable{
            let pathvariable = queryParams.PathString
            StrCompleteUrl  = "\(strURL)"   + (pathvariable )
            print("pathvariablepathvariable.....\(pathvariable )")
            
        }
        else if  strCustomValidation ==  WsParamsType.QueryParams{
            StrCompleteUrl = self.queryString(strURL, params: queryParams ) ?? ""
        }
            
        else{
            StrCompleteUrl = strURL
        }
        print(StrCompleteUrl)
        print(header)
        print(params)
        AF.request(StrCompleteUrl,method: .post, parameters: params, encoding: URLEncoding.default, headers:header).responseJSON { response in
            
            print(response.result)
            switch response.result{
                
            case .success(let json):
                
                let dictionary = json as! [String:Any]
                
                
                if let errorCode = dictionary["status_code"] as? Int{
                    let strErrorType = dictionary["error_type"] as? String ?? ""
                    let strMessage1 = dictionary["message"] as? String ?? ""
                    if errorCode == 400{
                        
                        
                        if  strErrorType == "ACCOUNT_DISABLED" || strErrorType == "INVALID_TOKEN" || strErrorType == "SESSION_EXPIRED" || strErrorType == "USER_NOT_FOUND"{
                            objAppShareData.showSessionFailAlert()
                            return
                            
                        }else{
                            objAppShareData.showErrorAlert(strMessage:strMessage1)
                        }
                    }
                }
                
                success(dictionary)
                 
            case .failure(let encodingError):
                // let error : Error = response.error!
                failure(encodingError)
                //  let str =   response.data?.base64EncodedString(options: .endLineWithLineFeed)//String(decoding: response.data as? NSData, as: UTF8.self)
                print("PHP ERROR :",encodingError.errorDescription as Any)
            }
            
        }
    }
    
    
    //MARK: - Request Put method ----
    public func requestPut(strURL:String, params : [String:Any]?,strCustomValidation:String,showIndicator:Bool, success:@escaping(Dictionary<String,Any>) ->Void, failure:@escaping (Error) ->Void ) {
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            //objAppShareData.showNetworkAlert()
            return
        }
        
        strAuthToken = ""
        if let token = UserDefaults.standard.string(forKey:UserDefaults.Keys.AuthToken){
            strAuthToken = "Bearer " + token
        }
        var strUdidi = ""
        if let MyUniqueId = UserDefaults.standard.string(forKey:UserDefaults.Keys.strVenderId) {
            print("defaults VenderID: \(MyUniqueId)")
            strUdidi = MyUniqueId
        }
        let currentTimeZone = getCurrentTimeZone()
        let header: HTTPHeaders = ["Authorization":strAuthToken,
                                   WsHeader.deviceId:strUdidi,
                                   WsHeader.deviceType:"1",
                                   WsHeader.deviceTimeZone: currentTimeZone,
                                   WsHeader.ContentType: "application/x-www-form-urlencoded"]
        print(header)
        
        AF.request(strURL, method: .put, parameters:  params, encoding: URLEncoding.default, headers: header).responseJSON{ response in
            
            print(response )
            
            switch response.result{
                
            case .success(let json):
                //  do {
                let dictionary = json as! [String:Any]
                
                
                if let errorCode = dictionary["status_code"] as? Int{
                    let strErrorType = dictionary["error_type"] as? String ?? ""
                    let strMessage1 = dictionary["message"] as? String ?? ""
                    if errorCode == 400{
                        
                        if  strErrorType == "ACCOUNT_DISABLED" || strErrorType == "INVALID_TOKEN" || strErrorType == "SESSION_EXPIRED" || strErrorType == "USER_NOT_FOUND"{
                            objAppShareData.showSessionFailAlert()
                            return
                            
                        }else{
                            objAppShareData.showErrorAlert(strMessage:strMessage1)
                        }
                    }
                }
                
                
                success(dictionary as! Dictionary<String, Any>)
                
                
                //                }catch{
                //
                //                }
                
            case .failure(let encodingError):
                print("PHP error",encodingError)
                failure(encodingError)
            }
        }
    }
    
    //MARK: - Request get method ----
    public func requestGet(strURL:String, params : [String:Any] ,queryParams : [String:Any], strCustomValidation:String , success:@escaping(Dictionary<String,Any>) ->Void, failure:@escaping (Error) ->Void ) {
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            // objAppShareData.showNetworkAlert()
            return
        }
        
        strAuthToken = ""
        if let token = UserDefaults.standard.string(forKey:UserDefaults.Keys.AuthToken){
            strAuthToken = "Bearer" + " " + token
        }
        
        print(strAuthToken)
        
        let currentTimeZone = getCurrentTimeZone()
        
        var strUdidi = ""
        if let MyUniqueId = UserDefaults.standard.string(forKey:UserDefaults.Keys.strVenderId) {
            print("defaults VenderID: \(MyUniqueId)")
            strUdidi = MyUniqueId
        }
        
        let headers: HTTPHeaders = [
            "Authorization": strAuthToken ,
            "Accept": "application/json",
            WsHeader.deviceId:strUdidi,
            WsHeader.deviceType:"1",
            WsHeader.deviceTimeZone: currentTimeZone
        ]
        
        print("url....\(strURL)")
        print("header....\(headers)")
        //
        let urlString = strURL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        var StrCompleteUrl = ""
        if strCustomValidation ==  WsParamsType.PathVariable{
            let pathvariable = queryParams.PathString
            StrCompleteUrl  = "\(urlString)"   + (pathvariable)
            print("pathvariablepathvariable.....\(pathvariable)")
            
        }
        else if  strCustomValidation ==  WsParamsType.QueryParams{
            StrCompleteUrl = self.queryString(urlString, params: queryParams ) ?? ""
        }
        else{
            StrCompleteUrl = urlString
        }
        AF.request(StrCompleteUrl, method: .get, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON { responseObject in
            
            print(responseObject)
            
            switch responseObject.result{
                
            case .success(let json):
                do {
                    let dictionary = json as! NSDictionary
                    
                    if let errorCode = dictionary["status_code"] as? Int{
                        let strErrorType = dictionary["error_type"] as? String ?? ""
                        let strMessage1 = dictionary["message"] as? String ?? ""
                        if errorCode == 400{
                            
                            if  strErrorType == "ACCOUNT_DISABLED" || strErrorType == "INVALID_TOKEN" || strErrorType == "SESSION_EXPIRED" || strErrorType == "USER_NOT_FOUND"{
                                objAppShareData.showSessionFailAlert()
                                return
                                
                            }else{
                                objAppShareData.showErrorAlert(strMessage:strMessage1)
                            }
                        }
                    }
                    
                    
                    success(dictionary as! Dictionary<String, Any>)
                    
                }catch{
                    objWebServiceManager.hideIndicator()
                }
                
            case .failure(let encodingError):
                print("PHP error",encodingError.errorDescription)
                failure(encodingError)
            }
            
        }
    }
    
    //MARK: - Request Delete method ----
    public func requestDelete(strURL:String, params : [String : AnyObject]?,queryParams : [String:Any], strCustomValidation:String , success:@escaping(Dictionary<String,Any>) ->Void, failure:@escaping (Error) ->Void ) {
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            //  objAppShareData.showNetworkAlert()
            return
        }
        
        strAuthToken = ""
        if let token = UserDefaults.standard.string(forKey:UserDefaults.Keys.AuthToken){
            strAuthToken = "Bearer" + " " + token
        }
        
        let currentTimeZone = getCurrentTimeZone()
        
        var strUdidi = ""
        if let MyUniqueId = UserDefaults.standard.string(forKey:UserDefaults.Keys.strVenderId) {
            print("defaults VenderID: \(MyUniqueId)")
            strUdidi = MyUniqueId
        }
        
        let headers: HTTPHeaders = [
            "Authorization": strAuthToken ,
            WsHeader.ContentType: "application/x-www-form-urlencoded",
            WsHeader.deviceId:strUdidi,
            WsHeader.deviceType:"1",
            WsHeader.deviceTimeZone: currentTimeZone
        ]
        
        var StrCompleteUrl = ""
        
        if strCustomValidation ==  WsParamsType.PathVariable{
            let pathvariable = queryParams.PathString
            StrCompleteUrl  = "\(strURL)"   + (pathvariable)
            print("pathvariablepathvariable.....\(pathvariable)")
             
        }
        else if  strCustomValidation ==  WsParamsType.QueryParams{
            StrCompleteUrl = self.queryString(strURL, params: queryParams ) ?? ""
        }
        else{
            StrCompleteUrl = strURL
        }
        
        print("url....\(strURL)")
        print("header....\(headers)")
        AF.request(StrCompleteUrl, method: .delete, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON { responseObject in
            
            print(responseObject)
            
            switch responseObject.result{
                
            case .success(let json):
                do {
                    let dictionary = json as! NSDictionary
                    
                    if let errorCode = dictionary["status_code"] as? Int{
                        let strErrorType = dictionary["error_type"] as? String ?? ""
                        let strMessage1 = dictionary["message"] as? String ?? ""
                        if errorCode == 400{
                            
                            if  strErrorType == "ACCOUNT_DISABLED" || strErrorType == "INVALID_TOKEN" || strErrorType == "SESSION_EXPIRED"  || strErrorType == "USER_NOT_FOUND"{
                                objAppShareData.showSessionFailAlert()
                                return
                                
                            }else{
                                objAppShareData.showErrorAlert(strMessage:strMessage1)
                            }
                        }
                    }
                    
                    success(dictionary as! Dictionary<String, Any>)
                    
                }catch{
                    objWebServiceManager.hideIndicator()
                    //                    let error : Error = responseObject.result.error!
                    //                    failure(error)
                    //                    let str = String(decoding: responseObject.data!, as: UTF8.self)
                    //                    print("PHP ERROR : \(str)")
                }
                
                
            case .failure(let encodingError):
                print("PHP error",encodingError)
                failure(encodingError)
            }
            
        }
    }
    
    //MARK: - Request Patch method ----
    public func requestPatch(strURL:String, params : [String:Any]?,queryParams : [String:Any], strCustomValidation:String , success:@escaping(Dictionary<String,Any>) ->Void, failure:@escaping (Error) ->Void ) {
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            // objAppShareData.showNetworkAlert()
            return
        }
        
        strAuthToken = ""
        
        if let token = UserDefaults.standard.string(forKey:UserDefaults.Keys.AuthToken){
            strAuthToken = "Bearer" + " " + token
        }
        
        let currentTimeZone = getCurrentTimeZone()
        
        var strUdidi = ""
        if let MyUniqueId = UserDefaults.standard.string(forKey:UserDefaults.Keys.strVenderId) {
            print("defaults VenderID: \(MyUniqueId)")
            strUdidi = MyUniqueId
        }
        
        let headers: HTTPHeaders = [
            "Authorization": strAuthToken ,
            "Accept": "application/json",
            WsHeader.deviceId:strUdidi,
            WsHeader.deviceType:"1",
            WsHeader.deviceTimeZone: currentTimeZone
        ]
        
        var StrCompleteUrl = ""
        
        if strCustomValidation ==  WsParamsType.PathVariable{
            let pathvariable = queryParams.PathString
            StrCompleteUrl  = "\(strURL)"   + (pathvariable)
            print("pathvariablepathvariable.....\(pathvariable)")
            
        }
        else if  strCustomValidation ==  WsParamsType.QueryParams{
            StrCompleteUrl = self.queryString(strURL, params: queryParams ) ?? ""
        }
        else{
            StrCompleteUrl = strURL
        }
        
        print("url....\(StrCompleteUrl)")
        print("header....\(headers)")
        AF.request(StrCompleteUrl, method: .patch, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON { responseObject in
            
            switch responseObject.result{
                
            case .success(let json):
                do {
                    let dictionary = json as! NSDictionary
                    
                    if let errorCode = dictionary["status_code"] as? Int{
                        let strErrorType = dictionary["error_type"] as? String ?? ""
                        let strMessage1 = dictionary["message"] as? String ?? ""
                        if errorCode == 400{
                            
                            if  strErrorType == "ACCOUNT_DISABLED" || strErrorType == "INVALID_TOKEN" || strErrorType == "SESSION_EXPIRED" || strErrorType == "USER_NOT_FOUND"{
                                objAppShareData.showSessionFailAlert()
                                return
                                
                            }else{
                                objAppShareData.showErrorAlert(strMessage:strMessage1)
                            }
                        }
                    }
                    
                    success(dictionary as! Dictionary<String, Any>)
                    
                }catch{
                    
                    objWebServiceManager.hideIndicator()

                }
                
            case .failure(let encodingError):
                print("PHP error",encodingError)
                failure(encodingError)
            }
        }
    }
    
    //MARK: - upload MultipartData method ----
    
    // //MARK: - upload MultipartData method ---
    
    public func uploadMultipartMultipleImagesData(strURL:String, params : [String:Any]?,showIndicator:Bool, imageData:Data?,imageToUpload:[Data],imagesParam:[String], fileName:String?, mimeType:String?, success:@escaping(Dictionary<String,Any>) ->Void, failure:@escaping (Error) ->Void){
        
        if !NetworkReachabilityManager()!.isReachable{
            let app = UIApplication.shared.delegate as? AppDelegate
            let window = app?.window
            // objAlert.showAlertVc(title: NoNetwork, controller: window!)
            DispatchQueue.main.async {
                objWebServiceManager.showIndicator()
            }
            return
        }
        ///////
        strAuthToken = ""
        
        if let token = UserDefaults.standard.string(forKey: UserDefaults.Keys.AuthToken){
            strAuthToken = "Bearer" + " " + token
        }
        
        let currentTimeZone = getCurrentTimeZone()
        
        
        var strUdidi = ""
        if let MyUniqueId = UserDefaults.standard.string(forKey:UserDefaults.Keys.strVenderId) {
            print("defaults VenderID: \(MyUniqueId)")
            strUdidi = MyUniqueId
        }
        
        let headers: HTTPHeaders = [
            "Authorization": strAuthToken ,
            "Accept": "application/json",
            "Content-type": "application/x-www-form-urlencoded",
            WsHeader.deviceId:strUdidi,
            WsHeader.deviceType:"1",
            WsHeader.deviceTimeZone: currentTimeZone
        ]
        
        print(headers)
        print(strURL)
    
               
        AF.upload(multipartFormData: { (multipartFormData) in
            
            
            let count = imageToUpload.count
            
            for i in 0..<count{
                
                
                multipartFormData.append(imageToUpload[i], withName: "\(imagesParam[i])", fileName: "file\(i).png" , mimeType: "image/png")
                
            }
            
            for (key, value) in params ?? [:] {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
            
        }, to: strURL,usingThreshold: UInt64.init(), method: .post, headers: headers).response{ response in
            
            
            switch response.result{
                
            case .success(let json):
                do {
                    
                    if let jsonData = response.data{
                        let parsedData = try JSONSerialization.jsonObject(with: jsonData) as! Dictionary<String, AnyObject>
                        print(parsedData)
                        
                        if let errorCode = parsedData["status_code"] as? Int{
                            let strErrorType = parsedData["error_type"] as? String ?? ""
                            let strMessage1 = parsedData["message"] as? String ?? ""
                            if errorCode == 400{
                                
                                if  strErrorType == "ACCOUNT_DISABLED" || strErrorType == "INVALID_TOKEN" || strErrorType == "SESSION_EXPIRED"  || strErrorType == "USER_NOT_FOUND"{
                                    objAppShareData.showSessionFailAlert()
                                    return
                                    
                                }else{
                                    objAppShareData.showErrorAlert(strMessage:strMessage1)
                                }
                            }
                        }
                
                        success(parsedData as Dictionary<String, Any>)
                    }
                    
                }catch{
                  //  let error : Error = response.error?.errorDescription
                   // failure(error)
                    objWebServiceManager.hideIndicator()

                  //  print("error message",response.error?.errorDescription)
                }
                
            case .failure(let encodingError):
                print("PHP error",encodingError)
                failure(encodingError)
            }
      
        }
    }
    
    
    
    
    
    // //MARK: - upload MultipartData for pdf test perpose -
     
     public func uploadMultipartDataPdf(strURL:String,strCustomValidation:String, params : [String:Any]?,showIndicator:Bool, imageData:Data?,imageToUpload:[Data],imagesParam:[String], fileName:String?, mimeType:String?, success:@escaping(Dictionary<String,Any>) ->Void, failure:@escaping (Error) ->Void){
         
         if !NetworkReachabilityManager()!.isReachable{
             let app = UIApplication.shared.delegate as? AppDelegate
             let window = app?.window
             // objAlert.showAlertVc(title: NoNetwork, controller: window!)
             DispatchQueue.main.async {
                 objWebServiceManager.showIndicator()
             }
             return
         }
         ///////
         strAuthToken = ""
         
         if let token = UserDefaults.standard.string(forKey: UserDefaults.Keys.AuthToken){
             strAuthToken = "Bearer" + " " + token
         }
         
         let currentTimeZone = getCurrentTimeZone()
         
         
         var strUdidi = ""
         if let MyUniqueId = UserDefaults.standard.string(forKey:UserDefaults.Keys.strVenderId) {
             print("defaults VenderID: \(MyUniqueId)")
             strUdidi = MyUniqueId
         }
         
         let headers: HTTPHeaders = [
             "Authorization": strAuthToken ,
             "Accept": "application/json",
             "Content-type": "application/x-www-form-urlencoded",
             WsHeader.deviceId:strUdidi,
             WsHeader.deviceType:"1",
             WsHeader.deviceTimeZone: currentTimeZone
         ]
         
         print(headers)
         print(strURL)
     
                
         AF.upload(multipartFormData: { (multipartFormData) in
             
            let count = imageToUpload.count
            if strCustomValidation == "image/*"{
                
                  for i in 0..<count{
                              
                              multipartFormData.append(imageToUpload[i], withName: "\(imagesParam[i])", fileName: "file\(i).png" , mimeType: "image/png")
                              
                          }
            }else if strCustomValidation == "application/pdf"{
                
                for i in 0..<count{
                    multipartFormData.append(imageToUpload[i], withName: "\(imagesParam[i])", fileName: "file\(i).pdf" , mimeType: "application/pdf")
                }
            }
//
//             for i in 0..<count{
//
//
//                 multipartFormData.append(imageToUpload[i], withName: "\(imagesParam[i])", fileName: "file\(i).pdf" , mimeType: "application/pdf")
//
//             }
             
             for (key, value) in params ?? [:] {
                 multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
             }
             
         }, to: strURL,usingThreshold: UInt64.init(), method: .post, headers: headers).response{ response in
             
             
             switch response.result{
                 
             case .success(let json):
                 do {
                     
                     if let jsonData = response.data{
                         let parsedData = try JSONSerialization.jsonObject(with: jsonData) as! Dictionary<String, AnyObject>
                         print(parsedData)
                         
                         if let errorCode = parsedData["status_code"] as? Int{
                             let strErrorType = parsedData["error_type"] as? String ?? ""
                             let strMessage1 = parsedData["message"] as? String ?? ""
                             if errorCode == 400{
                                 
                                 if strErrorType == "USER_NOT_FOUND" || strErrorType == "ACCOUNT_DISABLED" || strErrorType == "INVALID_TOKEN" || strErrorType == "SESSION_EXPIRED" {
                                     objAppShareData.showSessionFailAlert()
                                     return
                                     
                                 }else{
                                     objAppShareData.showErrorAlert(strMessage:strMessage1)
                                 }
                             }
                         }
                 
                         success(parsedData as Dictionary<String, Any>)
                     }
                     
                 }catch{
                   //  let error : Error = response.error?.errorDescription
                    // failure(error)
                    
                    objWebServiceManager.hideIndicator()

                    // print("error message",response.error?.errorDescription)
                 }
                 
             case .failure(let encodingError):
                 print("PHP error",encodingError)
                 failure(encodingError)
             }
       
         }
     }
    
    
    

    
}

//MARK:-  stripe payment method
//extension WebServiceManager{
//    public func requestAddCardOnStripe(strURL:String, params :[String : Any]?, success:@escaping(Dictionary<String,Any>) ->Void, failure:@escaping (Error) ->Void ) {
//
//
//        let url = strURL
//        print("url = \(url)")
//
//        let headers = ["Authorization" :  stripeKey,"Content-Type":"application/x-www-form-urlencoded"]
//
//
//        Alamofire.request(url, method: .post, parameters: params, headers: headers).responseJSON { responseObject in
//
//            print(responseObject)
//            if responseObject.result.isSuccess {
//                do {
//                    SVProgressHUD.show(withStatus: "Please wait..")
//                    let dictionary = try JSONSerialization.jsonObject(with: responseObject.data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
//                    success(dictionary as! Dictionary<String, Any>)
//                    // print(dictionary)
//                    SVProgressHUD.dismiss()
//                }catch{
//                    SVProgressHUD.dismiss()
//                    let error : Error = responseObject.result.error!
//                    failure(error)
//                }
//            }
//            if responseObject.result.isFailure {
//                SVProgressHUD.dismiss()
//                let error : Error = responseObject.result.error!
//                failure(error)
//            }
//        }
//    }
//
//    // Delete card
//    public func requestDeleteCardFromStripe(strURL:String, params :[String : Any]?, success:@escaping(Dictionary<String,Any>) ->Void, failure:@escaping (Error) ->Void ) {
//
//
//        let url = strURL
//        print("url = \(url)")
//
//        let headers = ["Authorization" :  stripeKey,"Content-Type":"application/x-www-form-urlencoded"]
//
//        Alamofire.request(url, method: .delete, parameters: params, headers: headers).responseJSON { responseObject in
//
//            print(responseObject)
//            if responseObject.result.isSuccess {
//                do {
//                    SVProgressHUD.show(withStatus: "Please wait..")
//                    let dictionary = try JSONSerialization.jsonObject(with: responseObject.data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
//                    success(dictionary as! Dictionary<String, Any>)
//                    // print(dictionary)
//                    SVProgressHUD.dismiss()
//                }catch{
//                    SVProgressHUD.dismiss()
//                    let error : Error = responseObject.result.error!
//                    failure(error)
//                }
//            }
//            if responseObject.result.isFailure {
//                SVProgressHUD.dismiss()
//                let error : Error = responseObject.result.error!
//                failure(error)
//            }
//        }
//    }
//
//    // Get all card List
//    public func requestGetCardsFromStripe(strURL:String, params :[String : Any]?, success:@escaping(Dictionary<String,Any>) ->Void, failure:@escaping (Error) ->Void ) {
//
//
//        let url = strURL
//        print("url = \(url)")
//
//        let headers = ["Authorization" : stripeKey,"Content-Type":"application/x-www-form-urlencoded"]
//
//        Alamofire.request(url, method: .get, parameters: params, headers: headers).responseJSON { responseObject in
//
//            // print(responseObject)
//            if responseObject.result.isSuccess {
//                do {
//                    SVProgressHUD.show(withStatus: "Please wait..")
//                    let dictionary = try JSONSerialization.jsonObject(with: responseObject.data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
//                    success(dictionary as! Dictionary<String, Any>)
//                    // print(dictionary)
//                    SVProgressHUD.dismiss()
//                }catch{
//                    SVProgressHUD.dismiss()
//                    let error : Error = responseObject.result.error!
//                    failure(error)
//                }
//            }
//            if responseObject.result.isFailure {
//                SVProgressHUD.dismiss()
//                let error : Error = responseObject.result.error!
//                failure(error)
//            }
//        }
//    }
//}


//extension WebServiceManager{
//
//    //MARK: - Request Not Form Data Put ---
//
//    public func requestNotMultipartPut(strURL:String, params : [String : Any]?, strCustomValidation:String , success:@escaping(Dictionary<String,Any>) ->Void, failure:@escaping (Error) ->Void ) {
//       if !objWebServiceManager.isNetworkAvailable(){
//           objWebServiceManager.hideIndicator()
//         //  objAppShareData.showNetworkAlert()
//           return
//       }
//
//        strAuthToken = ""
//        if let token = UserDefaults.standard.string(forKey: UserDefaults.Keys.AuthToken){
//            strAuthToken = "Bearer" + " " + token
//        }
//
//        let currentTimeZone = getCurrentTimeZone()
//
//        var strUdidi = ""
//        if let MyUniqueId = UserDefaults.standard.string(forKey:UserDefaults.Keys.strVenderId) {
//            print("defaults VenderID: \(MyUniqueId)")
//            strUdidi = MyUniqueId
//        }
//
//        let headers: HTTPHeaders = [
//            "Authorization": strAuthToken ,
//            "Accept": "application/json",
//            WsHeader.deviceId:strUdidi,
//            WsHeader.deviceType:"1",
//            WsHeader.deviceTimeZone: currentTimeZone
//        ]
//
//        print("url....\(strURL)")
//        print("header....\(headers)")
//        Alamofire.request(strURL, method: .put, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON { responseObject in
//
//            //self.StopIndicator()
//
//            if responseObject.result.isSuccess {
//                do {
//                    let dictionary = try JSONSerialization.jsonObject(with: responseObject.data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
//                    success(dictionary as! Dictionary<String, Any>)
//                    print(dictionary)
//                }catch{
//
//                    let error : Error = responseObject.result.error!
//                    failure(error)
//                    let str = String(decoding: responseObject.data!, as: UTF8.self)
//                    print("PHP ERROR : \(str)")
//                }
//            }
//            if responseObject.result.isFailure {
//                //self.StopIndicator()
//                let error : Error = responseObject.result.error!
//                failure(error)
//
//                let str = String(decoding: responseObject.data!, as: UTF8.self)
//                print("PHP ERROR : \(str)")
//            }
//        }
//    }
//
//
//    //MARK: - Request Delete method ----
//   /*   public func requestDelete(strURL:String, params : [String : AnyObject]?, strCustomValidation:String , success:@escaping(Dictionary<String,Any>) ->Void, failure:@escaping (Error) ->Void ) {
//             if !objWebServiceManager.isNetworkAvailable(){
//                 objWebServiceManager.hideIndicator()
//                 objAppShareData.showNetworkAlert()
//                 return
//             }
//
//
//        strAuthToken = ""
//        if let token = UserDefaults.standard.string(forKey:UserDefaults.Keys.AuthToken){
//              strAuthToken = "Bearer" + " " + token
//              }
//
//              let currentTimeZone = getCurrentTimeZone()
//
//              var strUdidi = ""
//        if let MyUniqueId = UserDefaults.standard.string(forKey:UserDefaults.Keys.strVenderId){
//              print("defaults VenderID: \(MyUniqueId)")
//              strUdidi = MyUniqueId
//              }
//
//              let headers: HTTPHeaders = [
//              "Authorization": strAuthToken ,
//              "Accept": "application/json",
//              WsHeader.deviceId:strUdidi,
//              WsHeader.deviceType:"1",
//              WsHeader.deviceTimeZone: currentTimeZone
//              ]
//
//              print("url....\(strURL)")
//              print("header....\(headers)")
//              Alamofire.request(strURL, method: .delete, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON { responseObject in
//
//              //self.StopIndicator()
//
//              if responseObject.result.isSuccess {
//              do {
//              let dictionary = try JSONSerialization.jsonObject(with: responseObject.data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
//              success(dictionary as! Dictionary<String, Any>)
//              print(dictionary)
//              }catch{
//
//              let error : Error = responseObject.result.error!
//              failure(error)
//              let str = String(decoding: responseObject.data!, as: UTF8.self)
//              print("PHP ERROR : \(str)")
//              }
//              }
//              if responseObject.result.isFailure {
//              //self.StopIndicator()
//              let error : Error = responseObject.result.error!
//              failure(error)
//
//              let str = String(decoding: responseObject.data!, as: UTF8.self)
//              print("PHP ERROR : \(str)")
//              }
//            }
//          }*/
//}

extension Dictionary {
    var queryString: String {
        var output: String = ""
        for (key,value) in self {
            output += "\(key)=\(value)&"
        }
        output = String(output.dropLast())
        return output
    }
    
    var PathString: String {
        var output: String = ""
        for (_,value) in self {
            output += "\(value)"
        }
        output = String(output)
        return output
    }
    
}
