//
//  IncomingCallViewController.swift
//  VideoChat
//
//  Created by Vardan Sargsyan on 9/19/19.
//  Copyright © 2019 Vardan. All rights reserved.
//

import UIKit
import AVFoundation
import Quickblox
import QuickbloxWebRTC

class IncomingCallViewController: SINUIViewController {
    
    
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    let path = Bundle.main.path(forResource: "incoming.wav", ofType:nil)!
    var bombSoundEffect: AVAudioPlayer?
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.getUserData()
        self.userImageView.layer.cornerRadius = self.userImageView.frame.height/2

        let url = URL(fileURLWithPath: self.path)
        do {
            bombSoundEffect = try AVAudioPlayer(contentsOf: url)
            bombSoundEffect?.play()
        } catch {
            // couldn't load file :(
        }
    }
    
    
    
//    func setSession(_ session: QBRTCSession) {
//        self.session = session
//    }


    
    func getUserData(){
        QBChatConnectionClient.shared.getQBUserByQBId(userID: globalSession!.initiatorID as! UInt) { (user) in
            let id = String(user!.externalUserID)
            HTTPClient.shared.getUserData(id: String(id)) { (response) in
                if let user = response {
                    self.userImageView.download(from: URL.init(string: user.avatar! )!)
                    self.lblUserName.text = user.userName
                    remoteUser = user
                }else{
                    print(response as Any)
                }
            }
        }
    }
    
    @IBAction func btnAcceptTapped(_ sender: Any) {
        //self.session?.acceptCall(nil)
        //performSegue(withIdentifier: "callView", sender: session)
        self.bombSoundEffect?.stop()
        self.dismiss()
        NotificationCenter.default.post(name: .callAccepted, object: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //let callViewController = segue.destination as? CallViewController
        //callViewController!.setSession(self.session!)
        
    }
    
    @IBAction func btnCancelTapped(_ sender: Any) {
        globalSession!.rejectCall(nil)
        globalSession = nil
        self.dismiss()
    }
    
    
//    func callDidEnd(_ call: SINCall!) {
//        self.dismiss()
//        self.bombSoundEffect?.stop()
//    }

}
