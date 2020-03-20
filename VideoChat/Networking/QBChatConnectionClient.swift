//
//  QBChatConnectionClient.swift
//  VideoChat
//
//  Created by Vardan Sargsyan on 3/14/20.
//  Copyright © 2020 Vardan. All rights reserved.
//

import Foundation
import Quickblox
import QuickbloxWebRTC


class QBChatConnectionClient {
    
    static let shared = QBChatConnectionClient()
    
    
    let defaultPassword = "quickblox"
    
    func signUp(login: String, externalID: Int) {
        let newUser = QBUUser()
        newUser.login = login  + "quickblox"
        newUser.password = "quickblox"
        newUser.externalUserID = UInt(externalID)
        QBRequest.signUp(newUser, successBlock: { [weak self] response, user in
            print(response)
            print(user)
            self?.login(login: newUser.login!, password: newUser.password!)
        }) { response in
            if response.status == QBResponseStatusCode.validationFailed {
                return
            }
        }
    }

    
    
    func login(login: String, password: String) {
        let login = login + "quickblox"
        QBRequest.logIn(withUserLogin: login,
                        password: password,
                        successBlock: { [weak self] response, user in
                            user.password = password
                            self?.connectToChat(user: user)
            }, errorBlock: { [weak self] response in
                if response.status == QBResponseStatusCode.unAuthorized {
                    // Clean profile
                    print(response as Any)
                }
        })
    }
    
    
    private func connectToChat(user: QBUUser) {
        QBChat.instance.connect(withUserID: user.id, password: user.password!, completion: nil)
    }
    
    func getQBUserById(userID: Int, complition: @escaping (_ response: QBUUser?) -> Void){
        QBRequest.user(withExternalID: UInt(userID), successBlock: { (response, user) in
            complition(user)
        }) { (error) in
            print(error as Any)
        }
    }
    
    func getQBUserByQBId(userID: UInt, complition: @escaping (_ response: QBUUser?) -> Void){
        QBRequest.user(withID: userID, successBlock: { (response, user) in
             complition(user)
        }) { (error) in
            print(error as Any)
        }
    }
   
}
