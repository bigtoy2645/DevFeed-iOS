//
//  Feed.swift
//  DevFeed
//
//  Created by yurim on 2020/10/16.
//  Copyright © 2020 yurim. All rights reserved.
//

import Foundation

struct Feed {
    var title = ""
    var description = ""
    var pubDate = ""
    var link = ""
    var isRead = false
    var dateFormat = ""
}

struct RSS {
    let name: String
    let link: String
    
    let startTag: String
    let titleTag: String
    let dateTag: String
    let linkTag: String
}
