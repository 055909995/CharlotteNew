//
//  HomeTabBarController.swift
//  VideoChat
//
//  Created by Vardan Sargsyan on 9/19/19.
//  Copyright © 2019 Vardan. All rights reserved.
//

import UIKit
import QuickbloxWebRTC
import Quickblox

class HomeTabBarController: UITabBarController, QBRTCClientDelegate {

    //var session : QBRTCSession?

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        HTTPClient.shared.view = self.view
        QBRTCClient.instance().add(self)
        self.modalPresentationStyle = .overFullScreen
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        NotificationCenter.default.addObserver(self, selector: #selector(callAccepted(notification:)), name: .callAccepted, object: nil)
        userStatus = statuses.onlineff
//        HTTPClient.shared.setStatus{ (response, error) in
//            if response != nil {
//                print(response as Any)
//            } else {
//                print(error as Any)
//            }
//        }
    }

    @objc func callAccepted(notification: NSNotification){
        globalSession?.acceptCall(nil)
        showPresenter = true
        self.selectedIndex = 2
        cameFrom = .incomigCall
    }
    
    func didReceiveNewSession(_ session: QBRTCSession, userInfo: [String : String]? = nil) {
        if selectedIndex != 2 {
            if globalSession != nil {
                session.rejectCall(userInfo)
            }
            else {
                globalSession = session
                performSegue(withIdentifier: "incomingVC", sender: session)
            }
        }
        
    }


    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        _ = segue.destination as? IncomingCallViewController
    }

    

}



class CustomTabBar: UITabBar {
 
    override func sizeThatFits(_ size: CGSize) -> CGSize {
          var size = super.sizeThatFits(size)
        if HTTPClient.shared.view.frame.height / HTTPClient.shared.view.frame.width >= 2 {
            size.height = 105
        }else{
            size.height = 72
        }
          return size
     }
}
