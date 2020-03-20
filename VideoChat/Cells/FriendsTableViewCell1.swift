//
//  FriendsTableViewCell.swift
//  VideoChat
//
//  Created by Goga on 09.04.2018.
//  Copyright © 2018 Vardan. All rights reserved.
//

import UIKit

class FriendsTableViewCell1: UITableViewCell {

    @IBOutlet weak var imgFriend: UIImageView!
    @IBOutlet weak var lblFriendsName: UILabel!
    @IBOutlet weak var imgFriendView: UIView!
    //var id = String()
    
    
    @IBOutlet weak var callButton: UIButton!
 
    func setInfo(_ model: FriendModel) {
        lblFriendsName.text = model.userName
        imgFriend.download(from:URL.init(string: model.avatar)!)
        imgFriendView.layer.borderWidth = 2
        imgFriendView.layer.masksToBounds = false
        if model.userStatus == 1 {
            imgFriendView.layer.borderColor = UIColor.green.cgColor
            self.callButton.isEnabled = true
        }else{
            imgFriendView.layer.borderColor = UIColor.red.cgColor
            self.callButton.isEnabled = false
        }
        //self.id = String(model.userID!)


    }
    @IBAction func btmCallTapped(_ sender: Any) {
       //self.call = self.client()?.call()?.callUserVideo(withId: HTTPClient.shared.remoteUserId)
    }
    
    
}
