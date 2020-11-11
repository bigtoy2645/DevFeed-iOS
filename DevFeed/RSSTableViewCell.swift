//
//  RSSTableViewCell.swift
//  DevFeed
//
//  Created by yurim on 2020/11/09.
//  Copyright © 2020 yurim. All rights reserved.
//

import UIKit

class RSSTableViewCell: UITableViewCell {
    
    @IBOutlet weak var favicon: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var link: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
