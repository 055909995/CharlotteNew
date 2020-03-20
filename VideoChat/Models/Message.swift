//
//  MessageModel.swift
//  VideoChat
//
//  Created by Vardan Sargsyan on 3/19/20.
//  Copyright © 2020 Vardan. All rights reserved.
//

import Foundation

struct Message {
    var text: String
    var type : MessageType
}

enum MessageType {
    case incoming
    case outgoing
}
