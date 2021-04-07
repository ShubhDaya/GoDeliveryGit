//
//  PrivacyPolicyVc.swift
//  Go Delivery
//
//  Created by MACBOOK-SHUBHAM V on 08/09/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit
import WebKit

class PrivacyPolicyVc: UIViewController,WKNavigationDelegate,WKUIDelegate  {
    
    //MARK:- IBOutlet  -

    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var viewWkWebView: WKWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK:- Local Methods  -

    var isviewload = false
    var strprivacy = objAppShareData.userDetail.privacy_url
   
    //MARK:- View Life Cycles -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            activityIndicator.style = .medium
        } else {
            // Fallback on earlier versions
        }
            activityIndicator.color = .black
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.activityIndicator.isHidden = true

        viewHeader.layer.shadowColor = UIColor.lightGray.cgColor
        viewHeader.layer.masksToBounds = false
        viewHeader.layer.shadowOffset = CGSize(width: 0.0 , height: 5.0)
        viewHeader.layer.shadowOpacity = 0.3
        viewHeader.layer.shadowRadius = 3
        self.loadUrl(strUrl: self.strprivacy)
        print(strprivacy)
    }
    
    
    //MARK:- Buttons  -

    @IBAction func btnBack(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
    }

    //MARK: - Local Methods -
    
    func loadUrl(strUrl:String){

        let url = NSURL(string: strUrl)
        let request = NSURLRequest(url: url! as URL)
        self.viewWkWebView.navigationDelegate = self
        self.viewWkWebView.load(request as URLRequest)
        self.activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    //MARK: - webView Methods -

    private func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
       // objWebServiceManager.hideIndicator()
        activityIndicator.stopAnimating()
        self.activityIndicator.isHidden = true
        print(error.localizedDescription)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {

    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
        self.activityIndicator.isHidden = true
    }
}
