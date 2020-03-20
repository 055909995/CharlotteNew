//
//  UserAuthModel.swift
//  VideoChat
//
//  Created by Vardan Sargsyan on 3/13/20.
//  Copyright © 2020 Vardan. All rights reserved.
//

import Foundation


class UserAuthModel: Codable {
    var userName: String?
    var gender: String?
    var bDay: String?
    var email: String
    var password: String
    
    init(userName: String?, gender: String? , bDay: String?, email: String, password: String) {
        self.userName = userName
        self.gender = gender
        self.bDay = bDay
        self.email = email
        self.password = password
    }
    
    init(email: String, password: String){
        self.email = email
        self.password = password
        self.bDay = nil
        self.gender = nil
        self.userName = nil
    }
    
    
}

