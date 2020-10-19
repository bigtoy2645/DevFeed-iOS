//
//  FeedTableViewCell.swift
//  DevFeed
//
//  Created by yurim on 2020/10/19.
//  Copyright © 2020 yurim. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UITextView!
    @IBOutlet weak var pubDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // TextView 여백 제거
        title.textContainerInset = UIEdgeInsets.zero
        title.textContainer.lineFragmentPadding = 0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
