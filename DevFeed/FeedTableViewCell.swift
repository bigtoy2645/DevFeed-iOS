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
    
    var isRead: Bool = false
    let badgeView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 3
        view.backgroundColor = .red
        return view
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // TextView 여백 제거
        title.textContainerInset = UIEdgeInsets.zero
        title.textContainer.lineFragmentPadding = 0
        
        // 뱃지 생성
        setBadge()
    }
    
    /* 읽음/읽지않음 뱃지 표시 */
    func setBadge() {
        if isRead == false {
            addSubview(badgeView)
            badgeView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                badgeView.rightAnchor.constraint(equalTo: title.leftAnchor, constant: -5),
                badgeView.topAnchor.constraint(equalTo: title.topAnchor, constant: 10),
                badgeView.heightAnchor.constraint(equalToConstant: badgeView.layer.cornerRadius*2),
                badgeView.widthAnchor.constraint(equalToConstant: badgeView.layer.cornerRadius*2)
            ])
        } else {
            title.tintColor = UIColor.systemGray2
            pubDate.tintColor = UIColor.systemGray2
        }
    }
    
}
