//
//  WebViewController.swift
//  DevFeed
//
//  Created by yurim on 2020/10/23.
//  Copyright © 2020 yurim. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    var htmlString: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let systemFontHTMLString = "<div style=\"font-family: -apple-system, BlinkMacSystemFont, sans-serif;\"> " + htmlString
        webView.loadHTMLString(systemFontHTMLString, baseURL: nil)
    }
}
