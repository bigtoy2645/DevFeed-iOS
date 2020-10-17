//
//  ViewController.swift
//  DevFeed
//
//  Created by yurim on 2020/10/07.
//  Copyright © 2020 yurim. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    @IBAction func buttonDidTap(_ sender: UIButton) {
        let feedVC = FeedViewController(nibName: "FeedViewController", bundle: nil)
        self.navigationController?.pushViewController(feedVC, animated: true)
    }
}


