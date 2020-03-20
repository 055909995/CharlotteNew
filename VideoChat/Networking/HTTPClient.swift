//
//  HTTPClient.swift
//  VideoChat
//
//  Created by Vardan on 16/12/2018.
//  Copyright © 2018 Vardan. All rights reserved.
//

import Foundation
import Alamofire
import var CommonCrypto.CC_MD5_DIGEST_LENGTH
import func CommonCrypto.CC_MD5
import typealias CommonCrypto.CC_LONG

class HTTPClient {
    
    static let shared: HTTPClient = HTTPClient()
    let baseURL = "https://crm.s2s.host/video_api/"
      var selectedStatus = "online"
      var paymentCost = "0"
      var changable = ""
      var view = UIView()
      var outgoingCallViewIsHidden = true

    func request(url: String, complition: @escaping (_ response: ResponseModel?) -> Void){
        
    }
    
    func register(newUser: UserAuthModel , complition: @escaping (_ response: ResponseModel?) -> Void) {
        let username = newUser.userName
        let bDay = newUser.bDay
        let email = newUser.email
        let gender = String(newUser.gender!)
        let password = newUser.password
        let url: String = baseURL + "s2s__add_user?" + "uid=54f8da6118919cd09151c90f622a6337&" + "user_name=" + username! + "&" + "b_day=" + bDay! + "&" + "email=" + email + "&" + "gender=" + gender + "&" + "password=" + password
        AF.request(url, method: .post).responseDecodable(of: ResponseModel.self) { response in
            guard let response = response.value else { return }
            complition(response)
            
        }
    }
    
    
    func logIn(currentUser: UserAuthModel  ,complition: @escaping (_ response: ResponseModel?) -> Void){
        let email = currentUser.email
        let password = currentUser.password
        let url: String = baseURL + "s2s__login?uid=54f8da6118919cd09151c90f622a6337&email=" + email + "&password=" + password
           AF.request(url, method: .get).responseDecodable(of: ResponseModel.self) { response in
                 guard let response = response.value else { return }
                 complition(response)
             }
    }
    
    
    func getUserData(id: String , complition: @escaping (_ response: UserModel?) -> Void){
        let url: String = baseURL + "s2s__get_user_info?uid=54f8da6118919cd09151c90f622a6337&user_id=" + id
        AF.request(url, method: .get).responseDecodable(of: UserModel.self) { response in
            guard let response = response.value else { return }
            complition(response)
        }
    }
    
    
    func searchOnlineUser(complition: @escaping (_ response: UserModel?) -> Void){
        let url :String = baseURL + "s2s__get_user?uid=54f8da6118919cd09151c90f622a6337"

           AF.request(url, method: .get).responseDecodable(of: UserModel.self) { response in
                guard let response = response.value else { return }
                complition(response)
            }
        
    }
    
    func addToFriends(complition: @escaping (_ response: ResponseModel?) -> Void) {
        let id = String(currentUser!.userID)
        let remoteId = String(remoteUser!.userID)
        let url: String = baseURL + "s2s__add_friend?uid=54f8da6118919cd09151c90f622a6337&user_id=" + id + "&friend_id=" + remoteId
         AF.request(url, method: .post).responseDecodable(of: ResponseModel.self) { (response) in
             guard let response = response.value else { return }
             complition(response)
         }
     }
    
    
    func getFriendList(complition: @escaping (_ response: Friends? ) -> Void) {
        let id = String(currentUser!.userID)
        let url: String = baseURL + "s2s__get_friends?uid=54f8da6118919cd09151c90f622a6337&user_id=" + id 
           AF.request(url, method: .get).responseDecodable(of: Friends.self) { response in
                     guard let response = response.value else { return }
                     complition(response)
                 }
    }
    

    
    func changeUsername(username: String ,password: String ,complition: @escaping (_ response: ResponseModel?) -> Void) {
        let id = String(currentUser!.userID)
        let url: String = baseURL + "s2s__change_name?uid=54f8da6118919cd09151c90f622a6337&user_id=" + id + "&name=" + username + "&password=" + password
        AF.request(url, method: .post).responseDecodable(of: ResponseModel.self) { (response) in
            guard let response = response.value else { return }
            complition(response)
        }
        
    }
    
    func changeEmail(email: String ,password: String ,complition: @escaping (_ response: ResponseModel?) -> Void) {
        let id = String(currentUser!.userID)
        let url: String = baseURL + "s2s__change_b_day?uid=54f8da6118919cd09151c90f622a6337&user_id=" + id + "&b_day=" + email + "&password=" + password
        AF.request(url, method: .post).responseDecodable(of: ResponseModel.self) { (response) in
            guard let response = response.value else { return }
            complition(response)
        }
    }
    
    
    
    func changePassword(newPassword: String , oldPassword: String ,complition: @escaping (_ response: ResponseModel?) -> Void) {
        let id = String(currentUser!.userID)
        let url: String = baseURL + "s2s__change_password?uid=54f8da6118919cd09151c90f622a6337&user_id=" + id + "&old_pass=" + oldPassword + "&password=" + newPassword
        AF.request(url, method: .post).responseDecodable(of: ResponseModel.self) { (response) in
            guard let response = response.value else { return }
            complition(response)
        }
    }
    
    
//    func getHistory(complition: @escaping (_ response: AnyObject?, _ error: AnyObject?) -> Void) {
//        let id = String(HTTPClient.shared.user.userID)
//        let url: String = baseURL + "/api/call_history?" + "id=" + id
//        AF.request(URL(string: url )! , method: .get, encoding: JSONEncoding.default).responseJSON { (response) in
//            if response.result.value != nil {
//                complition(response.result.value as AnyObject, nil)
//            } else {
//                complition(nil, response.result.error as AnyObject)
//            }
//        }
//    }
//
//
//
//
//    func payment(complition: @escaping (_ response: AnyObject?, _ error: AnyObject?) -> Void) {
//        let id = String(HTTPClient.shared.user.userID)
//        let url: String = baseURL + "/api/pay?id=" + id + "&tarif=" + paymentCost
//        AF.request(URL(string: url )! , method: .post, encoding: JSONEncoding.default).responseJSON { (response) in
//            if response.result.value != nil {
//                complition(response.result.value as AnyObject, nil)
//            } else {
//                complition(nil, response.result.error as AnyObject)
//            }
//        }
//    }
//
//
//    func sendGift(complition: @escaping (_ response: AnyObject?, _ error: AnyObject?) -> Void) {
//        let id = String(HTTPClient.shared.user.userID)
//        let remoteId = String(HTTPClient.shared.remoteUser.userID)
//        let url: String = baseURL + "/api/gift?manid=" + id + "&girl_id=" + remoteId + "&cost=" + cost
//        AF.request(URL(string: url )! , method: .post, encoding: JSONEncoding.default).responseJSON { (response) in
//            if response.result.value != nil {
//                complition(response.result.value as AnyObject, nil)
//            } else {
//                complition(nil, response.result.error as AnyObject)
//            }
//        }
//    }
//
//
//    func endCall(complition: @escaping (_ response: AnyObject?, _ error: AnyObject?) -> Void) {
//        let id = String(HTTPClient.shared.user.userID)
//        let remoteId = String(HTTPClient.shared.remoteUser.userID)
//        let url: String = baseURL + "/api/endcall?self_id=" + id + "&remote_id=" + remoteId + "&demo=" + demo
//        AF.request(URL(string: url )! , method: .get, encoding: JSONEncoding.default).responseJSON { (response) in
//            if response.result.value != nil {
//                complition(response.result.value as AnyObject, nil)
//            } else {
//                complition(nil, response.result.error as AnyObject)
//            }
//        }
//    }
//
//
//
//
//
//
//
//
//    func setStatus(complition: @escaping (_ response: AnyObject?, _ error: AnyObject?) -> Void) {
//        let id = String(HTTPClient.shared.user.userID)
//        let url: String = baseURL + "/api/changestat?id=" + id + "&status=" + status
//        AF.request(URL(string: url )! , method: .post, encoding: JSONEncoding.default).responseJSON { (response) in
//            if response.result.value != nil {
//                complition(response.result.value as AnyObject, nil)
//            } else {
//                complition(nil, response.result.error as AnyObject)
//            }
//        }
//    }
    
    
        func uploadImage(imgData: Data! ,complition: @escaping (_ response: AnyObject?) -> Void) {
            
            let url = "https://crm.s2s.host/video_api/s2s__upload_avatar?uid=54f8da6118919cd09151c90f622a6337&user_id=" + String(currentUser!.userID)
            
            AF.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(imgData, withName: "photo", fileName: "swift_file.jpeg", mimeType: "image/jpeg")
            }, to: url ).response { resp in
                 complition(resp as AnyObject)
            }
                
            
    //
    //        AF.upload(multipartFormData: { multipartFormData in
    //            multipartFormData.append(imgData, withName: "photo", fileName: "swift_file.jpeg", mimeType: "image/jpeg")
    //        }, to: url, encodingCompletion: { result in
    //            switch result {
    //            case .success(let upload, _, _):
    //                upload.responseJSON { response in
    //                    if response.result.isSuccess {
    //                        print("is Success true")
    //                    }
    //                }
    //            case .failure(let encodingError):
    //                // hide progressbas here
    //                print("ERROR RESPONSE: \(encodingError)")
    //            }
    //        })
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






