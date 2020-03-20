//
//  AppDelegate.swift
//  VideoChat
//
//  Created by Vardan on 08.04.2018.
//  Copyright © 2018 Vardan. All rights reserved.
//

import UIKit
import Sinch
import Quickblox
import QuickbloxWebRTC
//import ConnectyCube

struct CredentialsConstant {
    static let applicationID:UInt = 80744
    static let authKey = "KpENqpZrfvxW7E-"
    static let authSecret = "raYGEvueq74w4jU"
    static let accountKey = "xSwkXGSzzV_eH9FBumGa"
}

struct TimeIntervalConstant {
    static let answerTimeInterval: TimeInterval = 60.0
    static let dialingTimeInterval: TimeInterval = 5.0
}

struct AppDelegateConstant {
    static let enableStatsReports: UInt = 1
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, SINClientDelegate {
    
    var client: SINClient?
    var window: UIWindow?
    



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        //self.requestUserNotificationPermission()
        
        QBSettings.applicationID = CredentialsConstant.applicationID;
        QBSettings.authKey = CredentialsConstant.authKey
        QBSettings.authSecret = CredentialsConstant.authSecret
        QBSettings.accountKey = CredentialsConstant.accountKey
        QBSettings.autoReconnectEnabled = true
        QBSettings.logLevel = QBLogLevel.debug
        QBSettings.enableXMPPLogging()
        QBRTCConfig.setAnswerTimeInterval(TimeIntervalConstant.answerTimeInterval)
        QBRTCConfig.setDialingTimeInterval(TimeIntervalConstant.dialingTimeInterval)
        QBRTCConfig.setLogLevel(QBRTCLogLevel.verbose)
        
        if AppDelegateConstant.enableStatsReports == 1 {
            QBRTCConfig.setStatsReportTimeInterval(1.0)
        }
        
        QBRTCClient.initializeRTC()
        
        
        if UserDefaults.standard.string(forKey: "uId") != nil {
            let id = UserDefaults.standard.string(forKey: "uId")
            //QBChat.instance.connect(withUserID: UInt(id!)!, password: id!, completion: nil)
            if QBChat.instance.isConnected == false {
                print(QBChat.instance.currentUser?.id ?? "")
            }
            self.initSinchClientwithUserId(userId: UserDefaults.standard.string(forKey: "uId"))
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let tabBarController  = storyboard.instantiateViewController(withIdentifier: "HomeTabBarController") as! UITabBarController
            window?.rootViewController = tabBarController
            window?.makeKeyAndVisible()
            tabBarController.tabBar.unselectedItemTintColor = UIColor.lightText.withAlphaComponent(0.5)
            tabBarController.tabBar.backgroundImage = UIImage()
            tabBarController.tabBar.shadowImage = UIImage()
            tabBarController.tabBar.selectionIndicatorImage = UIImage()
            tabBarController.tabBar.layer.borderWidth = 0.0
            tabBarController.tabBar.layer.borderColor = UIColor.clear.cgColor
            tabBarController.tabBar.clipsToBounds = true
            NotificationCenter.default.post(name: NSNotification.Name("UserDidLoginNotification"), object: nil, userInfo: ["userId": UserDefaults.standard.string(forKey: "uId") ?? ""])
            
        }
        NotificationCenter.default.addObserver(forName: NSNotification.Name("UserDidLoginNotification"), object: nil, queue: nil, using: { note in
            self.initSinchClientwithUserId(userId: note.userInfo?["userId"] as? String)})
        NotificationCenter.default.addObserver(forName: NSNotification.Name("UserDidLogOutNotification "), object: nil, queue: nil, using: { note in
            self.clientDidStop(self.client)})
        return true
    }
    

//    func requestUserNotificationPermission() {
//        if UIApplication.shared.responds(to: #selector(UIApplication.registerUserNotificationSettings(_:))) {
//            let types: UIUserNotificationType = [.alert, .sound]
//            let settings = UIUserNotificationSettings(types: types, categories: nil)
//            UIApplication.shared.registerUserNotificationSettings(settings)
//        }
//    }
    
    
    func clientDidStart(_ client: SINClient!) {
        print("Sinch client started successfully")
    }
    
    func clientDidFail(_ client: SINClient!, error: Error!) {
        print("Sinch client error")
    }
    
    func callDidEnd(_ call: SINCall!) {
        print("call end")
    }
    
    func clientDidStop(_ client: SINClient!) {
        print("Sinch client stopped")
    }
//    func handleLocalNotification(_ notification: UILocalNotification?) {
//        if notification != nil {
//            let result: SINNotificationResult? = client!.relay(notification)
//            if result?.isCall() != nil &&  result?.call()?.isTimedOut != nil {
//                var alert: UIAlertView? = nil
//                if let remote = result?.call()?.remoteUserId {
//                    alert = UIAlertView(title: "Missed call", message: "Missed call from \(remote)", delegate: nil, cancelButtonTitle: "", otherButtonTitles: "OK")
//                }
//                alert?.show()
//            }
//        }
//    }
    
//    func handleNotification(notification: UILocalNotification?) {
//
//        if notification != nil {
//
//            let result: SINNotificationResult = (self.client?.relay(notification))!
//
//            if result.isCall() && result.call().isTimedOut {
//                let alert: UIAlertController = UIAlertController(title: "Missed Call", message: String(format: "Missed Call from %@", arguments: [result.call().remoteUserId]), preferredStyle: .alert)
//                let okAction = UIAlertAction(title: "Ok", style: .default, handler: {_ -> Void in
//                    alert.dismiss(animated: true, completion: nil)
//                } )
//
//                alert.addAction(okAction)
//
//                self.window?.rootViewController?.present(alert, animated: true, completion: nil)
//            }
//        }
//    }
    
    //Mark : - Init Sinch
    func initSinchClientwithUserId (userId: String?) {
        if !(client != nil) {
            client = Sinch.client(withApplicationKey: "03efe147-4e3a-4b7e-8a1a-2d0f17a91866",
                                  applicationSecret: "ICo9tD0fWEG2AIwsWS+Zww==",
                                  environmentHost: "clientapi.sinch.com",
                                  userId: userId)
            client!.delegate = self
            client?.setSupportCalling(true)
//            client?.setSupportActiveConnectionInBackground(true)
            client!.start()
            client!.startListeningOnActiveConnection()
            print(userId ?? "")
        }
    }

    

    func applicationWillResignActive(_ application: UIApplication) {
        userStatus = statuses.offline
//        HTTPClient.shared.setStatus{ (response, error) in
//            if response != nil {
//                print(response as Any)
//            } else {
////                print(error as Any)
//            }
//        }
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
    }
//
//    private func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
//       // self.handleNotification(notification: notification)
//    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
       // HTTPClient.shared.setStatus(status: "online")
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
            sleep(2)
        userStatus = statuses.offline
//        HTTPClient.shared.setStatus{ (response, error) in
//            if response != nil {
//                print(response as Any)
//                print("offilne")
//            } else {
//                print(error as Any)
//            }
//        }
            print("closed")
    }
    
    


}

