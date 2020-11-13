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
    
    let rssParser = RSSParser()
    var rssList: [RSS] = [RSS(name: "", link: "", dateFormat: "", startTag: "", titleTag: "", dateTag: "", linkTag: ""),
                          RSS(name: "Apple Developer News", link: "https://developer.apple.com/news/rss/news.rss", dateFormat: "EEE, dd MMM yyyy HH:mm:ss z", startTag: "item", titleTag: "title", dateTag: "pubDate", linkTag: "link"),
                          RSS(name: "Ray Wenderlich", link: "https://www.raywenderlich.com/ios/feed", dateFormat: "yyyy-MM-dd'T'HH:mm:ss'Z'", startTag: "entry", titleTag: "title", dateTag: "updated", linkTag: "id")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Cell 등록
        let nibName = UINib(nibName: "FeedTableViewCell", bundle: nil)
        tblNews.register(nibName, forCellReuseIdentifier: "FeedCell")
        tblNews.rowHeight = UITableView.automaticDimension
        
        // Navigation 설정
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = .label
        self.navigationItem.backBarButtonItem = backBarButtonItem
        
        DispatchQueue.global().async {
            for index in 1..<self.rssList.count {
                self.rssList[index].feed = self.rssParser.parse(rss: self.rssList[index])
            }
            DispatchQueue.main.async {
                self.tblNews.reloadData()
            }
        }
    }
    
    // MARK: - UICollectionViewDelegate
    
    /* cell 개수 */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rssList.count
    }
    
    /* cell 그리기 */
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubscribeCell", for: indexPath) as! SubscribeCell
        // Favicon 불러오기
        if indexPath.row != 0 {
            let url = URL(string: "https://www.google.com/s2/favicons?sz=64&domain=" + "\(rssList[indexPath.row].link)")
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
            addRSSVC.rssList = rssList.filter { $0.link.isEmpty == false }
            present(addRSSVC, animated: true, completion: nil)
        } else {
            guard let feedVC = self.storyboard?.instantiateViewController(identifier: "NewsFeed") as? FeedViewController else { return }
            feedVC.rss = rssList[indexPath.row]
            self.navigationController?.pushViewController(feedVC, animated: true)
        }
    }
    
    // MARK: - UITableViewDelegate
    
    /* cell 개수 */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    /* cell 그리기 */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as! FeedTableViewCell
        if rssList[indexPath.section+1].feed.count > indexPath.row {
            let feed = rssList[indexPath.section+1].feed[indexPath.row]
            cell.updateValue(feed: feed)
            return cell
        }
        
        return UITableViewCell()
    }
    
    /* section 개수 */
    func numberOfSections(in tableView: UITableView) -> Int {
        return rssList.count - 1
    }
    
    /* section 타이틀 */
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return rssList[section+1].name
    }
}


