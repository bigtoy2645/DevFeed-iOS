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
    
    var rssList: [RSS] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Cell 등록
        let nibName = UINib(nibName: "RSSTableViewCell", bundle: nil)
        tblRSS.register(nibName, forCellReuseIdentifier: "RSSCell")
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rssList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RSSCell", for: indexPath) as! RSSTableViewCell
//                cell.updateValue(feed: feed[indexPath.row])
        
        // favicon 다운로드
        // TODO - protocol로 빼기
        let url = URL(string: "https://www.google.com/s2/favicons?sz=64&domain=" + "\(rssList[indexPath.row].link)")
        if let data = try? Data(contentsOf: url!) {
            cell.favicon.image = UIImage(data: data)
        }
        cell.title.text = rssList[indexPath.row].name
        cell.link.text = rssList[indexPath.row].link
        cell.addButton.addTarget(self, action: #selector(addButtonDidTap(_:)), for: .touchUpInside)
        
        return cell
    }
    
    /* 추가 버튼 선택 시 동작 */
    @objc func addButtonDidTap(_ sender: UIButton) {
        // TODO - cellForRowAt에서 버튼 이미지 변경
        // sender.setImage(UIImage(systemName:"checkmark"), for: .selected)
//        guard let indexPath = sender.indexPath else { return }
//
//        // Complete 값 변경
//        if indexPath.section == 0 {
//            todoScheduled[selectedDate]?[indexPath.row].isCompleted.toggle()
//        } else {
//            todoAnytime[indexPath.row].isCompleted.toggle()
//        }
//
//        tblTodo.reloadData()
    }
}
