//
//  User.swift
//  VideoChat
//
//  Created by Vardan Sargsyan on 6/30/19.
//  Copyright © 2019 Vardan. All rights reserved.
//

import UIKit
import var CommonCrypto.CC_MD5_DIGEST_LENGTH
import func CommonCrypto.CC_MD5
import typealias CommonCrypto.CC_LONG


struct CurrentUserModel: Codable {
    let status: Int
    let userName: String
    let userID, gender: Int
    let avatar: String
    let bDay: String
    let userStatus, approve, demoCount, demo: Int
    let message: String
    let minutes: Int

    enum CodingKeys: String, CodingKey {
        case status
        case userName = "user_name"
        case userID = "user_id"
        case gender, avatar
        case bDay = "b_day"
        case userStatus = "user_status"
        case approve
        case demoCount = "demo_count"
        case demo, message, minutes
    }
    
    func MD5(string: String) -> Data {
        let length = Int(CC_MD5_DIGEST_LENGTH)
        let messageData = string.data(using:.utf8)!
        var digestData = Data(count: length)

        _ = digestData.withUnsafeMutableBytes { digestBytes -> UInt8 in
            messageData.withUnsafeBytes { messageBytes -> UInt8 in
                if let messageBytesBaseAddress = messageBytes.baseAddress, let digestBytesBlindMemory = digestBytes.bindMemory(to: UInt8.self).baseAddress {
                    let messageLength = CC_LONG(messageData.count)
                    CC_MD5(messageBytesBaseAddress, messageLength, digestBytesBlindMemory)
                }
                return 0
            }
        }
        return digestData
    }
}



class UserModel1: NSObject {
    var status = 0
    var userName = ""
    var userID = 0
    var gender = 0
    var avatar = ""
    var bDay = ""
    var userStatus = 0
    var approve = 0
    var minutes = 0
    var demoCount = 0
    var message = ""
    var demo = 0
    var email = ""
    var password = ""
    var userImage = UIImageView()
    
    override init(){
        
    }

    convenience init(email: String, password: String) {
        self.init()
        self.email = email
        let md5Data = self.MD5(string: password )
        let md5Hex =  md5Data.map { String(format: "%02hhx", $0) }.joined()
        self.password = md5Hex
    }
    convenience init(email: String, password: String, bday: String, gender: Int, username: String ) {
        self.init()
        self.email = email
        self.bDay = bday
        self.gender = gender
        self.userName = username
        let md5Data = self.MD5(string: password )
        let md5Hex =  md5Data.map { String(format: "%02hhx", $0) }.joined()
        self.password = md5Hex
        
    }

    convenience init(dict: [String : Any]) {
        self.init()
        
        //userImage.download(from: URL.init(string: dict["avatar"] as! String)!)
        self.status = dict["status"] as? Int ?? 0
        self.userName = dict["user_name"] as? String ?? ""
        self.userID = dict["user_id"] as? Int ?? 0
        self.gender = dict["gender"] as? Int ?? 0
        self.avatar = dict["avatar"] as? String ?? ""
        self.bDay = dict["b_day"] as? String ?? ""
        self.userStatus = dict["user_status"] as? Int ?? 0
        self.approve = dict["approve"] as? Int ?? 0
        self.minutes = dict["minutes"] as? Int ?? 0
        self.demoCount = dict["demo_count"] as? Int ?? 0
        self.message = dict["message"] as? String ?? ""
        self.demo = dict["demo"] as? Int ?? 0
        
    }
    
    
    func MD5(string: String) -> Data {
        let length = Int(CC_MD5_DIGEST_LENGTH)
        let messageData = string.data(using:.utf8)!
        var digestData = Data(count: length)

        _ = digestData.withUnsafeMutableBytes { digestBytes -> UInt8 in
            messageData.withUnsafeBytes { messageBytes -> UInt8 in
                if let messageBytesBaseAddress = messageBytes.baseAddress, let digestBytesBlindMemory = digestBytes.bindMemory(to: UInt8.self).baseAddress {
                    let messageLength = CC_LONG(messageData.count)
                    CC_MD5(messageBytesBaseAddress, messageLength, digestBytesBlindMemory)
                }
                return 0
            }
        }
        return digestData
    }
}
