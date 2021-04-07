//
//  AboutUsVC.swift
//  Go Delivery
//  Created by MACBOOK-SHUBHAM V on 08/09/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.

import UIKit
import WebKit

class AboutUsVC: UIViewController,WKNavigationDelegate,WKUIDelegate {
    
    //MARK:- IBOutlet  -

    @IBOutlet weak var viewHeaderView: UIView!
    @IBOutlet weak var viewWkWebView: WKWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    //MARK:- Local Variables  -

    var aboutus = objAppShareData.userDetail.AboutUs

    //MARK:- ViewLifeCycle  -
   
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
        self.activityIndicator.isHidden = true
        super.viewWillAppear(animated)
        viewHeaderView.layer.shadowColor = UIColor.lightGray.cgColor
        viewHeaderView.layer.masksToBounds = false
        viewHeaderView.layer.shadowOffset = CGSize(width: 0.0 , height: 5.0)
        viewHeaderView.layer.shadowOpacity = 0.3
        viewHeaderView.layer.shadowRadius = 3
        self.loadUrl(strUrl: self.aboutus)
    }
    
    //MARK:- UiButtons  -

    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)

    }
    
    //MARK: - Functions -
      
      func loadUrl(strUrl:String){
          let url = NSURL(string: strUrl)
          let request = NSURLRequest(url: url! as URL)
          self.viewWkWebView.navigationDelegate = self
          self.viewWkWebView.load(request as URLRequest)
          activityIndicator.startAnimating()
          self.activityIndicator.isHidden = false
      }
    
      //MARK:- webView Methods  -

      private func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
          print(error.localizedDescription)
        activityIndicator.stopAnimating()
        self.activityIndicator.isHidden = true
      }
      
      func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
          print("Strat to load")
      }
      
      func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
               self.activityIndicator.isHidden = true
          print("finish to load")
      }
}
