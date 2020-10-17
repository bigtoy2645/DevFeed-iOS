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

class FeedViewController: UIViewController, XMLParserDelegate {
    
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var webView: WKWebView!
    
    enum element: String {
        case item = "item"
        case title = "title"
        case description = "description"
        case pubDate = "pubDate"
        case link = "link"
    }
    
    var feed: [Feed] = []
    var currentElement: element?
    var currentFeed = Feed()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        parseAppleDevNews()
    }
    
    // MARK: - XMLParserDelegate
    
    /* Apple Developer News 파싱 */
    func parseAppleDevNews() {
        guard let url = URL(string: "https://developer.apple.com/news/rss/news.rss") else { return }
        
        let parser = XMLParser(contentsOf: url)
        parser?.delegate = self
        if true == parser?.parse() {
            print("parsing success!")
        } else {
            print("parsing failure")
        }
        
        // TODO - UI Update
//        newsTitle.text = feed[0].title
//        let str = "<div style=\"font-family: -apple-system, BlinkMacSystemFont, sans-serif;\">" + feed[0].description
//        webView.loadHTMLString(str, baseURL: nil)
    }
    
    /* 시작 Tag */
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = element(rawValue: elementName)
        if currentElement == element.item {
            currentFeed.title = ""
            currentFeed.description = ""
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
            currentFeed.title = string
        case .description:
            currentFeed.description += string
        case .pubDate:
            currentFeed.pubDate = string
        case .link:
            currentFeed.link = string
        default:
            return
        }
    }
    
    // MARK: - Actions
}
