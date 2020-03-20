//
//  FriendModel.swift
//  VideoChat
//
//  Created by Vardan Sargsyan on 9/11/19.
//  Copyright © 2019 Vardan. All rights reserved.
//

import UIKit
import Foundation



// MARK: - Friend
struct FriendModel: Codable {
    let userName: String
    let userID, gender: Int
    let avatar: String
    let bDay: String
    let userStatus: Int

    enum CodingKeys: String, CodingKey {
        case userName = "user_name"
        case userID = "user_id"
        case gender, avatar
        case bDay = "b_day"
        case userStatus = "user_status"
    }
}
// MARK: - Friends
struct Friends: Codable {
    let status: Int
    let message: String
    let friends: [FriendModel]
    let count: Int
}





