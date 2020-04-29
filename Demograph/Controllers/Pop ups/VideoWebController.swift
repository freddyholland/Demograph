//
//  VideoWebController.swift
//  Demograph-Prototype
//
//  Created by Frederick Holland on 01/04/20.
//  Copyright © 2020 Frederick Holland. All rights reserved.
//

import UIKit
import WebKit

class VideoWebController: UIViewController, WKUIDelegate {
    
    @IBOutlet var webView: WKWebView!
    
    var link: String = ""
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let myURL = URL(string:link)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }

}
