//
//  HistoryViewController.swift
//  VideoChat
//
//  Created by Vardan Sargsyan on 8/23/19.
//  Copyright © 2019 Vardan. All rights reserved.
//

import UIKit


class HistoryViewController: UIViewController  {
    @IBOutlet weak var bottomViewHeight: NSLayoutConstraint!
    @IBOutlet weak var historyTableView: UITableView!
    var historyList = [FriendModel]()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        if self.view.frame.height / self.view.frame.width >= 2 {
            self.bottomViewHeight.constant = 145
        }else{
            self.bottomViewHeight.constant = 90
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.getHistory()
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.historyList.removeAll()
    }
    
    func loadTableView(dict: [[String: AnyObject]]){
//        for value in dict {
//            let oneItem = FriendModel(dict: value)
//            self.historyList.append(oneItem)
//        }
    }

    func getHistory() {
//        HTTPClient.shared.getHistory{ (response, error) in
//            if response != nil {
//                print(response as Any)
//                let arrayDict = response as! [[String:AnyObject]]
//                self.loadTableView(dict: arrayDict)
//                self.historyTableView.reloadData()
//            } else {
//                
//            }
//        }
    }
    

    
    


}


extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = historyTableView.dequeueReusableCell(withIdentifier:"HistoryTableViewCell") as! HistoryTableViewCell
        let oneItem = self.historyList[indexPath.row]
        cell.setInfo(oneItem)
        cell.imgFriend.clipsToBounds = true
        cell.imgFriend.layer.cornerRadius = cell.imgFriend.frame.height/2
        cell.imgFriendView.layer.cornerRadius = cell.imgFriendView.frame.height/2
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(70.0)
    }
}
