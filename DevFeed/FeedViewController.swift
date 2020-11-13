//
//  FeedViewController.swift
//  DevFeed
//
//  Created by yurim on 2020/10/16.
//  Copyright © 2020 yurim. All rights reserved.
//

import UIKit
import Foundation
import WebKit

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tblFeed: UITableView!
    
    let rssParser = RSSParser()
    var rss: RSS = RSS(name: "", link: "", dateFormat: "", startTag: "", titleTag: "", dateTag: "", linkTag: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Cell 등록
        let nibName = UINib(nibName: "FeedTableViewCell", bundle: nil)
        tblFeed.register(nibName, forCellReuseIdentifier: "FeedCell")
        
        // Navigation 설정
        self.title = rss.name
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = .label
        self.navigationItem.backBarButtonItem = backBarButtonItem
        
        // XML 파싱
        DispatchQueue.global().async {
            self.rss.feed = self.rssParser.parse(rss: self.rss)
            DispatchQueue.main.async {
                if 0 == self.rss.feed.count {
                    self.tblFeed.setEmptyView(title: "Failed to connect network.")
                }
                self.tblFeed.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tblFeed.reloadData()
    }
    
    // MARK: - UITableViewDelegate
    
    /* cell 개수 */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rss.feed.count
    }
    
    /* cell 그리기 */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as! FeedTableViewCell
        cell.updateValue(feed: rss.feed[indexPath.row])
        
        // TODO - Feed 형식일 경우 WebView 표시
//        let str = "<div style=\"font-family: -apple-system, BlinkMacSystemFont, sans-serif;\">" + feed[indexPath.row].description
//        cell.webView.loadHTMLString(str, baseURL: nil)
//        cell.webView.sizeToFit()
        
        return cell
    }
    
    /* cell 선택 시 */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // WebView 표시
        guard let webVC = self.storyboard?.instantiateViewController(identifier: "DetailWebView") as? WebViewController else { return }
        rss.feed[indexPath.row].isRead = true
        webVC.feed = rss.feed[indexPath.row]
        self.navigationController?.pushViewController(webVC, animated: true)
    }
    
    // MARK: - Actions
}

extension UITableView {
    /* 오류 화면 */
    func setEmptyView(title: String) {
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        let titleLabel = UILabel()
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = UIColor.systemGray
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        emptyView.addSubview(titleLabel)
        
        titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
        titleLabel.text = title
        
        self.backgroundView = emptyView
        self.separatorStyle = .none
    }
}
