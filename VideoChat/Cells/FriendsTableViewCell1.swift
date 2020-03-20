//
//  FriendsTableViewCell.swift
//  VideoChat
//
//  Created by Goga on 09.04.2018.
//  Copyright © 2018 Vardan. All rights reserved.
//

import UIKit

class FriendsTableViewCell: UITableViewCell {

    @IBOutlet weak var imgFriend: UIImageView!
    @IBOutlet weak var lblFriendsName: UILabel!
    
    
    @IBOutlet weak var callButton: UIButton!
 
    func setInfo(_ model: FriendModel) {
        lblFriendsName.text = model.name
        imgFriend.download(from:URL.init(string: model.avatar)!)
    }

    
}
