//
//  HistoryTableViewCell.swift
//  VideoChat
//
//  Created by Vardan Sargsyan on 9/12/19.
//  Copyright © 2019 Vardan. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var imgFriendView: UIView!
    @IBOutlet weak var lblFriendsName: UILabel!
    @IBOutlet weak var imgFriend: UIImageView!
    @IBOutlet weak var btnAddToFriends: UIButton!
    
    
    
    
    func setInfo(_ model: FriendModel) {
        lblFriendsName.text = model.userName
        imgFriend.download(from:URL.init(string: model.avatar)!)

        
        
    }

}
