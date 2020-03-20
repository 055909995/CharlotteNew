//
//  ResponseModel.swift
//  VideoChat
//
//  Created by Vardan Sargsyan on 3/13/20.
//  Copyright © 2020 Vardan. All rights reserved.
//

import Foundation

// MARK: - ResponseModel
class ResponseModel: Codable {
    let status, userID, gender: Int?
    let message, error: String?

    enum CodingKeys: String, CodingKey {
        case status
        case userID = "user_id"
        case gender, message, error
    }

    init(status: Int?, userID: Int?, gender: Int?, message: String?, error: String?) {
        self.status = status
        self.userID = userID
        self.gender = gender
        self.message = message
        self.error = error
    }
    
}
