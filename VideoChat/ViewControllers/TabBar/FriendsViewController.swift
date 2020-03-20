//
//  FriendsViewController.swift
//  VideoChat
//
//  Created by Goga on 09.04.2018.
//  Copyright © 2018 Vardan. All rights reserved.
//

import UIKit
//import Sinch
import QuickbloxWebRTC
import Quickblox


class FriendsViewController: SINUIViewController, QBRTCClientDelegate {

    // MARK: - Outlets
    @IBOutlet weak var lblFriends: UILabel!
    @IBOutlet weak var friendsTable: UITableView!
    @IBOutlet weak var bottomViewHeight: NSLayoutConstraint!
    var friendList = [FriendModel]()
    //var call : SINCall?
    //var session : QBRTCSession?
  

    // MARK: - LyfeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        QBRTCClient.instance().add(self)
    }
    
    override func viewWillLayoutSubviews() {
        if self.view.frame.height / self.view.frame.width >= 2 {
            self.bottomViewHeight.constant = 145
            self.view.layoutIfNeeded()
        }else{
            self.bottomViewHeight.constant = 90
            self.view.layoutIfNeeded()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.getFriends()
             print(self.bottomViewHeight.constant)
        switch UserDefaults.standard.string(forKey: "language") {
        case "ru":
            self.lblFriends.text = "Друзья"
        case "en":
            self.lblFriends.text = "Friends"
        default:
            return
        }
     
        
      
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.friendList.removeAll()
    }
    
    // MARK: - Functionality
    
    
    func getFriends() {
        HTTPClient.shared.getFriendList{ response in
            if response?.status == 1 {
                print(response as Any)
                self.friendList = (response?.friends)!
                self.friendsTable.reloadData()
            } else {
                print(response?.message as Any)
            }
        }
    }

    func getUserData(id: Int){
        HTTPClient.shared.getUserData(id: String(id)) { response in
            if (response?.userID) != nil{
                let user = response
                remoteUser = user
                QBChatConnectionClient.shared.getQBUserById(userID: remoteUser!.userID) { (qbUser) in
                    let ids = [qbUser?.id]
                    let session = QBRTCClient.instance().createNewSession(withOpponents: ids as! [NSNumber], with: .video)
                    session.startCall(nil)
                    globalSession = session
                    cameFrom = .outgoingCall
                    showPresenter = true
                    self.tabBarController?.selectedIndex = 2
                }
            }else{
                print(response?.message as Any)
            }
            

        }
        
  
    }
    

    
    func goToCallVC(userID: Int){
        self.getUserData(id: userID)
    }



  
}

// MARK: - Extensions TableView

extension FriendsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        self.goToCallVC(userID: self.friendList[indexPath.row].userID)
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = friendsTable.dequeueReusableCell(withIdentifier:"FriendsTableViewCell1") as! FriendsTableViewCell1
        let oneItem = self.friendList[indexPath.row]
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
