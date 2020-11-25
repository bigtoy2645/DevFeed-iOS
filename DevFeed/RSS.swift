//
//  RSS.swift
//  DevFeed
//
//  Created by yurim on 2020/11/25.
//  Copyright © 2020 yurim. All rights reserved.
//

import Foundation

struct RSS {
    let name: String
    let link: String
    let dateFormat: String
    
    let startTag: String
    let titleTag: String
    let dateTag: String
    let linkTag: String
    
    var feed: [Feed] = []
}

class RSSParser: NSObject, XMLParserDelegate {
    var rss = RSS(name: "", link: "", dateFormat: "", startTag: "", titleTag: "", dateTag: "", linkTag: "")
    
    private var currentTag: String?
    private var currentFeed = Feed(title: "", date: "", link: "")
    
    /* XML 파싱 */
    func parse(rss: RSS) -> [Feed] {
        self.rss = rss
        self.rss.feed.removeAll()
        guard let encoded = self.rss.link.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: encoded) else { return [] }
        
        let parser = XMLParser(contentsOf: url)
        parser?.delegate = self
        parser?.parse()
        return self.rss.feed
    }
    
    // MARK: - XMLParserDelegate
    
    /* 시작 Tag */
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentTag = elementName
        if currentTag == rss.startTag {
            currentFeed.title = ""
            currentFeed.date = ""
            currentFeed.link = ""
        }
    }
    
    /* 종료 Tag */
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == rss.startTag {
            currentFeed.title = currentFeed.title.replacingOccurrences(of: "&nbsp;", with: " ")
            let inputFormatter = DateFormatter()
            let outputFormatter = DateFormatter()
            
            inputFormatter.dateFormat = rss.dateFormat
            outputFormatter.dateStyle = .long
            if let date = inputFormatter.date(from: currentFeed.date) {
                currentFeed.date = outputFormatter.string(from: date)
            }
            
            rss.feed.append(currentFeed)
        }
        currentTag = nil
    }
    
    /* Tag에 해당하는 문자열 */
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentTag {
        case rss.titleTag:
            currentFeed.title += string
        case rss.dateTag:
            currentFeed.date += string
        case rss.linkTag:
            currentFeed.link += string
        default:
            return
        }
    }
}
