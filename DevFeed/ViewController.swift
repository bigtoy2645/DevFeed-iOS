//
//  ViewController.swift
//  DevFeed
//
//  Created by yurim on 2020/10/07.
//  Copyright © 2020 yurim. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var colRSS: UICollectionView!
    @IBOutlet weak var tblNews: UITableView!
    
    var rss: [String] = ["", "https://developer.apple.com/news/rss/news.rss"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Cell 등록
        let nibName = UINib(nibName: "FeedTableViewCell", bundle: nil)
        tblNews.register(nibName, forCellReuseIdentifier: "FeedCell")
        tblNews.rowHeight = UITableView.automaticDimension
        
        // Navigation 설정
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    // MARK: - UICollectionViewDelegate
    
    /* cell 개수 */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rss.count
    }
    
    /* cell 그리기 */
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubscribeCell", for: indexPath) as! SubscribeCell
        // Favicon 불러오기
        if indexPath.row != 0 {
            let url = URL(string: "https://www.google.com/s2/favicons?sz=64&domain=" + "\(rss[indexPath.row])")
            if let data = try? Data(contentsOf: url!) {
                cell.thumbnail.image = UIImage(data: data)
            }
        }
        
        return cell
    }
    
    /* cell 선택 시 */
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            guard let addRSSVC = self.storyboard?.instantiateViewController(identifier: "AddRSS") as? AddRSSViewController else { return }
            present(addRSSVC, animated: true, completion: nil)
        } else {
            guard let feedVC = self.storyboard?.instantiateViewController(identifier: "NewsFeed") as? FeedViewController else { return }
            self.navigationController?.pushViewController(feedVC, animated: true)
        }
    }
    
    // MARK: - UITableViewDelegate
    
    /* cell 개수 */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    /* cell 그리기 */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as! FeedTableViewCell
        cell.title.sizeToFit()
        cell.pubDate.sizeToFit()
        
        return cell
    }
    
    /* section 개수 */
    func numberOfSections(in tableView: UITableView) -> Int {
        return rss.count - 1
    }
    
    /* section 타이틀 */
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Apple Developer News"
    }
}


