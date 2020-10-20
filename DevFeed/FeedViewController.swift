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
        
        // Navigation Bar 라인 제거
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        // TODO - 리팩토링
        self.title = "Apple Developer News"
        parseAppleDevNews()
    }
    
    // MARK: - XMLParserDelegate
    
    /* Apple Developer News 파싱 */
    func parseAppleDevNews() {
        let rssURL = "https://developer.apple.com/news/rss/news.rss"
        guard let encoded = rssURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: encoded) else { return }
        
        let parser = XMLParser(contentsOf: url)
        parser?.delegate = self
        if true == parser?.parse() {
            print("parsing success!")
        } else {
            print("parsing failure")
        }
    }
    
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
        cell.title.text = feed[indexPath.row].title
        cell.title.sizeToFit()
        // TODO - Feed 형식일 경우 WebView 표시
//        let str = "<div style=\"font-family: -apple-system, BlinkMacSystemFont, sans-serif;\">" + feed[indexPath.row].description
//        cell.webView.loadHTMLString(str, baseURL: nil)
//        cell.webView.sizeToFit()
        
        return cell
    }
    
    // MARK: - Actions
}
