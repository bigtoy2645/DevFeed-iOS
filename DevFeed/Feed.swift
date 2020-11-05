//
//  Feed.swift
//  DevFeed
//
//  Created by yurim on 2020/10/16.
//  Copyright © 2020 yurim. All rights reserved.
//

import Foundation

struct Feed {
    var title: String
    var date: String
    var link: String
    var isRead = false
}

struct RSS {
    let name: String
    let link: String
    let dateFormat: String
    
    let startTag: String
    let titleTag: String
    let dateTag: String
    let linkTag: String
}
