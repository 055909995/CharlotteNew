//
//  ResponseModel.swift
//  VideoChat
//
//  Created by Vardan Sargsyan on 3/13/20.
//  Copyright © 2020 Vardan. All rights reserved.
//

import Foundation

// MARK: - ResponseModel
struct RegistrationResponseModel: Codable {
    let status, userID, gender: Int
    let message: String

    enum CodingKeys: String, CodingKey {
        case status
        case userID = "user_id"
        case gender, message
    }
}
