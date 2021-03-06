//
//  AddRSSViewController.swift
//  DevFeed
//
//  Created by yurim on 2020/10/20.
//  Copyright © 2020 yurim. All rights reserved.
//

import UIKit

class AddRSSViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tblRSS: UITableView!
    
    var searchController = UISearchController()
    var resultVC = UITableViewController()
    
    var rssList: [RSS] = []
    var filteredRSSList: [RSS] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Cell 등록
        let nibName = UINib(nibName: "RSSTableViewCell", bundle: nil)
        tblRSS.register(nibName, forCellReuseIdentifier: "RSSCell")
        resultVC.tableView.register(nibName, forCellReuseIdentifier: "RSSCell")
        
        // 검색 화면, 결과 화면 연결
        searchController = UISearchController(searchResultsController: resultVC)
        tblRSS.tableHeaderView = searchController.searchBar
        
        self.definesPresentationContext = true
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.delegate = self
        
        resultVC.tableView.delegate = self
        resultVC.tableView.dataSource = self
    }
    
    /* 추가 버튼 선택 시 동작 */
    func cellAddButtonDidTap(_ cell: RSSTableViewCell) {
        // Complete 값 변경
//        todoAnytime[indexPath.row].isCompleted.toggle()

        tblRSS.reloadData()
    }
    
    // MARK: - UITableViewDelegate
    
    /* cell 개수 */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView == resultVC.tableView ? filteredRSSList.count : rssList.count
    }
    
    /* cell 그리기 */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RSSCell", for: indexPath) as! RSSTableViewCell
        let rss: RSS = (tableView == resultVC.tableView) ? filteredRSSList[indexPath.row] : rssList[indexPath.row]
        
//                cell.updateValue(feed: feed[indexPath.row])
        
        // favicon 다운로드
        // TODO - protocol로 빼기
        let url = URL(string: "https://www.google.com/s2/favicons?sz=64&domain=" + "\(rss.link)")
        if let data = try? Data(contentsOf: url!) {
            cell.favicon.image = UIImage(data: data)
        }
        let rssLink = rss.link
        cell.title.text = rss.name
        cell.link.text = rssLink.replacingOccurrences(of: "https://", with: "")
        cell.addButtonAction = cellAddButtonDidTap(_:)
        
        return cell
    }
}

// MARK: - UISearch...

extension AddRSSViewController: UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    
    /* 검색 키워드 변경 시 결과 화면 업데이트 */
    func updateSearchResults(for searchController: UISearchController) {
        let searchKeyword = searchController.searchBar.text!.lowercased()
        filteredRSSList = rssList.filter({ (rss: RSS) -> Bool in
            return rss.name.lowercased().contains(searchKeyword) || rss.link.lowercased().contains(searchKeyword)
        })
        
        resultVC.tableView.reloadData()
    }
}
