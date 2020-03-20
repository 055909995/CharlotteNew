//
//  Constants.swift
//  VideoChat
//
//  Created by Vardan Sargsyan on 3/13/20.
//  Copyright © 2020 Vardan. All rights reserved.
//

import Foundation
import Quickblox
import QuickbloxWebRTC

var globalSession : QBRTCSession?
var newUser = UserAuthModel(email: "", password: "")
var currentUser: UserModel?
var remoteUser: UserModel?
var language = "en"
var userStatus: String?
var gifts = [#imageLiteral(resourceName: "1111"),#imageLiteral(resourceName: "222"),#imageLiteral(resourceName: "333"),#imageLiteral(resourceName: "444"),#imageLiteral(resourceName: "6666")]
var giftForShow = #imageLiteral(resourceName: "1111")
var cameFrom : CameFrom?
var showPresenter = true

var statuses = (
    online: "online",
    offline: "offline",
    busy: "busy",
    onlineff: "onlineff",
    onlinefp: "onlinefp",
    onfilnefd: "onlinefd"
)

enum CameFrom {
    case incomigCall
    case homeTabBar
    case outgoingCall
}






