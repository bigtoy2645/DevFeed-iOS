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
    @IBOutlet weak var searchItem: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var webViewTopConstraint: NSLayoutConstraint!
    
    var feed: Feed?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 검색 기능
        if let path = Bundle.main.path(forResource: "WKWebViewSearch", ofType: "js"),
            let jsString = try? String(contentsOfFile: path, encoding: .utf8) {
            webView.evaluateJavaScript(jsString, completionHandler: nil)
        }
        
        // Navigation 설정
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        // 검색바 숨김
        searchBar.isHidden = true
        webViewTopConstraint.constant = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        if let htmlString = feed?.description {
//            let systemFontHTMLString = "<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></header>" + "<div style=\"font-family: -apple-system, BlinkMacSystemFont, sans-serif;\"> " + htmlString
//            webView.loadHTMLString(systemFontHTMLString, baseURL: nil)
//        }
        
        if let link = feed?.link, let url = URL(string: link) {
            webView.load(URLRequest(url: url))
        }
    }
    
    /* 검색 아이템 클릭 */
    @IBAction func searchButtonDidTap(_ sender: UIBarButtonItem) {
        if searchBar.isHidden == false {
            searchBar.isHidden = true
            webViewTopConstraint.constant = 0
            sender.tintColor = UIColor.label
            webView.evaluateJavaScript("DevFeed_RemoveAllHighlights()", completionHandler: nil)
        } else {
            searchBar.isHidden = false
            webViewTopConstraint.constant = searchBar.frame.height
            sender.tintColor = UIColor.systemGreen
        }
    }
}

extension WebViewController : UISearchBarDelegate {
    /* 검색 버튼 클릭 */
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let currentSearchText = searchBar.text else { return }
        
        let searchString = "DevFeed_HighlightAllOccurencesOfString('\(currentSearchText)')"
        webView.evaluateJavaScript(searchString, completionHandler: nil)
    }
    
    /* 검색 취소 버튼 클릭 */
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        webView.evaluateJavaScript("DevFeed_RemoveAllHighlights()", completionHandler: nil)
    }
}
