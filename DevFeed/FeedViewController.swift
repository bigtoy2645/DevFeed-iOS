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

class FeedViewController: UIViewController, XMLParserDelegate, UITableViewDelegate, UITableViewDataSource {

    enum element: String {
        case item = "item"
        case title = "title"
        case description = "description"
        case pubDate = "pubDate"
        case link = "link"
    }
    
    @IBOutlet weak var tblFeed: UITableView!
    
    var viewTitle: String?
    var feed: [Feed] = []
    var currentElement: element?
    var currentFeed = Feed()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Cell 등록
        let nibName = UINib(nibName: "FeedTableViewCell", bundle: nil)
        tblFeed.register(nibName, forCellReuseIdentifier: "FeedCell")
        
        // Navigation 설정
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = .label
        self.navigationItem.backBarButtonItem = backBarButtonItem
        
        // TODO - 리팩토링
        self.title = "Apple Developer News"
        
        // Apple Developer News 파싱
        DispatchQueue.global().async {
            let rssURL = "https://developer.apple.com/news/rss/news.rss"
            guard let encoded = rssURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: encoded) else { return }
            
            let parser = XMLParser(contentsOf: url)
            parser?.delegate = self
            
            DispatchQueue.main.async {
                if false == parser?.parse() {
                    self.tblFeed.setEmptyView(title: "Failed to connect network.")
                }
                self.tblFeed.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tblFeed.reloadData()
    }
    
    // MARK: - XMLParserDelegate
    
    /* 시작 Tag */
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = element(rawValue: elementName)
        if currentElement == element.item {
            currentFeed.title = ""
            currentFeed.description = ""
            currentFeed.pubDate = ""
            currentFeed.link = ""
        }
    }
    
    /* 종료 Tag */
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if element(rawValue: elementName) == element.item {
            currentFeed.title = currentFeed.title.replacingOccurrences(of: "&nbsp;", with: " ")
            let inputFormatter = DateFormatter()
            let outputFormatter = DateFormatter()
            
            // Mon, 26 Oct 2020 12:39:59 PDT
            inputFormatter.dateFormat = "EEE, dd MMM yyyy hh:mm:ss z"
            outputFormatter.dateStyle = .long
            if let date = inputFormatter.date(from: currentFeed.pubDate) {
                currentFeed.pubDate = outputFormatter.string(from: date)
            }
            
            feed.append(currentFeed)
        }
        currentElement = nil
    }
    
    /* Tag에 해당하는 문자열 */
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentElement {
        case .title:
            currentFeed.title += string
        case .description:
            currentFeed.description += string
        case .pubDate:
            currentFeed.pubDate += string
        case .link:
            currentFeed.link += string
        default:
            return
        }
    }
    
    // MARK: - UITableViewDelegate
    
    /* cell 개수 */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feed.count
    }
    
    /* cell 그리기 */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as! FeedTableViewCell
        cell.updateValue(feed: feed[indexPath.row])
        
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
        feed[indexPath.row].isRead = true
        webVC.feed = feed[indexPath.row]
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
