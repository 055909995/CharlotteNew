//
//  CallScreenViewController.swift
//  VideoChat
//
//  Created by Vardan Sargsyan on 3/18/20.
//  Copyright © 2020 Vardan. All rights reserved.
//

import UIKit
import BottomSheetController
import ARSLineProgress
import Quickblox
import QuickbloxWebRTC

class CallScreenViewController: UIViewController, UIGestureRecognizerDelegate {

//MARK:- Outlets

    @IBOutlet weak var waitingView: UIView!
    @IBOutlet weak var remoteVideoView: QBRTCRemoteVideoView!
    @IBOutlet weak var localVideoView: UIView!
    @IBOutlet weak var imgGiftView: UIImageView!
    @IBOutlet weak var outgoingCallView: UIView!
    @IBOutlet weak var outgoingCallUserImageView: UIImageView!
    @IBOutlet weak var waitingImageView: UIImageView!
    
//MARK:- Variables
    
    enum CallHangupReason {
        case nextBtnTapped
        case endcallBtnTabbed
        case rejectedByRemoteUser
    }
    
    var isExpanded = true
    var bottomSheetController: BottomSheetController!
    var keyboardIsShown = false
    private var progressObject: Progress?
    private var isSuccess: Bool?
    var videoCapture: QBRTCCameraCapture?
    var callHangUpReason: CallHangupReason?
    
    
//MARK:- Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = true
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "BottomSheetViewController") as! BottomSheetViewController
        self.bottomSheetController = BottomSheetController(main: self, sheet: vc)
        self.addObservers()
        self.view.addBlurView(view: waitingView)
        QBRTCClient.instance().add(self)
        QBRTCAudioSession.instance().addDelegate(self)
        
        self.remoteVideoView.contentMode = .scaleAspectFill
        self.localVideoView.contentMode = .scaleAspectFill

        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        switch cameFrom {
        case .incomigCall:
            print("incomingCall")
            self.loadIncomingCallScreen()
        case .homeTabBar:
            print("homeTabBar")
            self.loadWaitingCallScreen()
        case .outgoingCall:
            print("OutgoingCall")
            self.loadOutgoingCallScreen()
        default:
            print("homeTabBar")
            self.loadWaitingCallScreen()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.stopAnimation()
    }
    

    override func viewDidAppear(_ animated: Bool) {
        if cameFrom == .homeTabBar {
            self.startAnimation()
        }
    }
    
    

//MARK:-Functions
    
    func loadOutgoingCallScreen(){
        outgoingCallView.isHidden = false
        self.bottomSheetController.collapse()
    }
    
    func loadWaitingCallScreen(){
        self.bottomSheetController.middle()
        outgoingCallView.isHidden = true
        remoteUser = nil
        self.getOnlineUser()
        self.waitingView.isHidden = false
        self.waitingImageView.isHidden = false
        
        
        if globalSession != nil {
            globalSession = nil
        }
    }
    
    func loadIncomingCallScreen(){
        outgoingCallView.isHidden = true
        self.bottomSheetController.middle()
    }
    
//MARK:-Actions
    @IBAction func hideKeyboardGstr(_ sender: Any) {
        if keyboardIsShown {
            self.view.endEditing(true)
            keyboardIsShown = false
        }else {
            if isExpanded {
                       self.bottomSheetController.collapse()
                       self.isExpanded = false
                   }else{
                       self.bottomSheetController.middle()
                       self.isExpanded = true
            }
        }
    }
    @IBAction func cancelOutgoingCallBtn(_ sender: Any) {
        globalSession?.hangUp(nil)
        
    }
    
    
//MARK:- Notification Observers
    
    func addObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(nextBtnTapped(notification:)), name: .nextBtnTappet, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(endCallBtnTapped(notification:)), name: .endCallBtnTapped, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(muteBtnTapped(notification:)), name: .muteBtnTapped, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showGift(notification:)), name: .showGift, object: nil)
    }

//MARK:- Notification Actions
    
    @objc func showGift(notification: NSNotification) {
        self.imgGiftView.image = giftForShow
        UIView.animate(withDuration: 2.0, delay: 0.0,
                       usingSpringWithDamping: 0.25,
                       initialSpringVelocity: 0.0,
                       options: [],
                       animations: {
                        self.imgGiftView.isHidden = false
                        self.imgGiftView.layer.transform = CATransform3DMakeScale(6.5, 6.5, 0.2)
        }, completion: {(finished:Bool) in
            UIView.animate(withDuration: Double(3.0),
                           delay: 0,
                           options: [],
                           animations: {
                            self.imgGiftView.layer.transform = CATransform3DMakeScale(0.5, 0.5, 0.2)
                            self.imgGiftView.isHidden = true})
            
        })
    }
    
    @objc func nextBtnTapped(notification: NSNotification){
        if globalSession == nil {
            globalSession?.hangUp(nil)
            callHangUpReason = .nextBtnTapped
        }
    }
    
    @objc func endCallBtnTapped(notification: NSNotification){
        if globalSession == nil {
            self.dismiss(animated: true, completion: nil)
            showPresenter = false
        }else{
            globalSession!.hangUp(nil)
            callHangUpReason = .endcallBtnTabbed
        }
    }
    
    @objc func muteBtnTapped(notification: NSNotification){
        print("mute")
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
        self.keyboardIsShown = true
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }

}

//MARK:-QBFunctions

extension CallScreenViewController : QBRTCClientDelegate, QBRTCAudioSessionDelegate {
    
    func videoConfig(){
        let videoFormat = QBRTCVideoFormat.init()
        videoFormat.frameRate = 30
        videoFormat.pixelFormat = QBRTCPixelFormat.formatARGB
        videoFormat.width = 640
        videoFormat.height = 480
        self.videoCapture = QBRTCCameraCapture.init(videoFormat: videoFormat, position: AVCaptureDevice.Position.front)
        globalSession!.localMediaStream.videoTrack.videoCapture = self.videoCapture
        globalSession!.localMediaStream.audioTrack.isEnabled = true;
        globalSession!.localMediaStream.videoTrack.isEnabled = true
        self.videoCapture!.previewLayer.frame = self.localVideoView.bounds
        self.videoCapture!.startSession()
        //self.localVideoView.contentMode = .top
        self.localVideoView.layer.cornerRadius = 5
        self.localVideoView.layer.insertSublayer(self.videoCapture!.previewLayer, at: 0)
    }
    
    func audioConfig(){
        let audioSession = QBRTCAudioSession.instance()
        if audioSession.isInitialized == false {
            audioSession.initialize { configuration in
                // adding blutetooth support
                configuration.categoryOptions.insert(.allowBluetooth)
                configuration.categoryOptions.insert(.allowBluetoothA2DP)
                configuration.categoryOptions.insert(.duckOthers)
                // adding airplay support
                configuration.categoryOptions.insert(.allowAirPlay)
                guard let session = globalSession else { return }
                if session.conferenceType == .video {
                    // setting mode to video chat to enable airplay audio and speaker only
                    configuration.mode = AVAudioSession.Mode.videoChat.rawValue
                }
            }
        }
    }

    
    
    func session(_ session: QBRTCSession, acceptedByUser userID: NSNumber, userInfo: [String : String]? = nil) {
        self.outgoingCallView.isHidden = true
        
    }
    
    func session(_ session: QBRTCSession, rejectedByUser userID: NSNumber, userInfo: [String : String]? = nil) {
        globalSession?.hangUp(nil)
        callHangUpReason = .rejectedByRemoteUser
    }
    
    
    
    func sessionDidClose(_ session: QBRTCSession) {
        switch callHangUpReason {
        case .endcallBtnTabbed:
            showPresenter = false
            remoteUser = nil
            globalSession = nil
            self.dismiss(animated: true, completion: nil)
            print("End Call Button Tapped")
        case .nextBtnTapped:
            remoteUser = nil
            globalSession = nil
            self.waitingView.isHidden = false
            self.getOnlineUser()
            self.startAnimation()
            print("Next Button Tapped")
        case .rejectedByRemoteUser:
            remoteUser = nil
            globalSession = nil
            self.waitingView.isHidden = false
            self.getOnlineUser()
            self.startAnimation()
            print("Rejected by Remote User")
        default:
            showPresenter = false
            remoteUser = nil
            globalSession = nil
            self.dismiss(animated: true, completion: nil)
            print("Other Reason")
        }
    }
    
    func session(_ session: QBRTCBaseSession, connectedToUser userID: NSNumber) {
        self.bottomSheetController.middle()
        self.videoConfig()
        self.audioConfig()
    }
    
    func session(_ session: QBRTCBaseSession, disconnectedFromUser userID: NSNumber) {
        globalSession?.hangUp(nil)
        callHangUpReason = .rejectedByRemoteUser
    }
    
    func session(_ session: QBRTCBaseSession, receivedRemoteVideoTrack videoTrack: QBRTCVideoTrack, fromUser userID: NSNumber) {
        self.remoteVideoView.contentMode = .scaleAspectFill
        self.remoteVideoView.videoGravity = AVLayerVideoGravity.resizeAspect.rawValue
        self.remoteVideoView?.setVideoTrack(videoTrack)
        self.remoteVideoView.layoutIfNeeded()
    }
    
    func session(_ session: QBRTCBaseSession, receivedRemoteAudioTrack audioTrack: QBRTCAudioTrack, fromUser userID: NSNumber) {
        audioTrack.isEnabled = true
        
    }
    
    func didReceiveNewSession(_ session: QBRTCSession, userInfo: [String : String]? = nil) {
        globalSession = session
        globalSession?.acceptCall(nil)
        self.progressDemoHelper(success: true)
    }
    
    
}

//MARK: - BottomSheet Configuration

extension CallScreenViewController: BottomSheetConfiguration {
    func initialY(_ bottomSheetController: BottomSheetController) -> CGFloat {
        return UIScreen.main.bounds.height - 100
    }
    func minYBound(_ bottomSheetController: BottomSheetController) -> CGFloat {
        return UIScreen.main.bounds.height / 2
    }
    func maxYBound(_ bottomSheetController: BottomSheetController) -> CGFloat {
        return UIScreen.main.bounds.height
    }
    func scrollableView(_ bottomSheetController: BottomSheetController) -> UIScrollView? {
        return nil
    }
    func disableBackground(_ bottomSheetController: BottomSheetController) -> Bool {
        return false
    }
    func maxAlphaBackground(_ bottomSheetController: BottomSheetController) -> CGFloat {
        return 0.5
    }
    func nextY(_ bottomSheetController: BottomSheetController, from currentY: CGFloat, panDirection direction: BottomSheetPanDirection) -> CGFloat {
        let screenMidY = UIScreen.main.bounds.height - 100
        //let porc =
        //
        //self.isExpanded = true
        switch direction {
        case .up: return currentY < screenMidY ? minYBound(bottomSheetController) : screenMidY
        case .down: return currentY > screenMidY ? maxYBound(bottomSheetController) : screenMidY
        }
    }
}

//MARK: - WaitingViewConfiguration

extension CallScreenViewController {
    
    func getOnlineUser() {

        //self.progressDemoHelper(success: true)
            if currentUser?.gender == 1 {
                //self.session?.acceptCall(nil)
                return
            }else{
                HTTPClient.shared.searchOnlineUser { response in
                    if (response?.userID) != nil {
                        remoteUser = response
                        QBChatConnectionClient.shared.getQBUserById(userID: remoteUser!.userID) { (qbUser) in
                            let ids = [qbUser?.id]
                            let session = QBRTCClient.instance().createNewSession(withOpponents: ids as! [NSNumber], with: .video)
                            globalSession = session
                            if globalSession != nil {
                                globalSession!.startCall(nil)
                                self.progressDemoHelper(success: true)
                            }else {
                                self.getOnlineUser()
                            }
                            
                        }
                        
                    }else{
                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
                            self.getOnlineUser()
                            print(response as Any)
                        })
                    }
                }
            }
    }
    
    
    func startAnimation(){
        DispatchQueue.main.async {
            ARSLineProgressConfiguration.blurStyle = .regular
            ARSLineProgressConfiguration.backgroundViewStyle = .simple
            ARSLineProgressConfiguration.backgroundViewColor = UIColor.clear.cgColor
            ARSLineProgressConfiguration.showSuccessCheckmark = false
            ARSLineProgressConfiguration.circleColorInner = UIColor.white.cgColor
            ARSLineProgressConfiguration.circleColorOuter = UIColor.white.cgColor
            ARSLineProgressConfiguration.circleColorMiddle = UIColor.white.cgColor
            ARSLineProgressConfiguration.circleRotationDurationOuter = 3
            ARSLineProgressConfiguration.circleRotationDurationMiddle = 2
            ARSLineProgressConfiguration.circleRotationDurationInner = 1.5
            self.progressObject = Progress(totalUnitCount: 2)
            ARSLineProgress.showWithProgressObject(self.progressObject!, completionBlock: {
                print("Success completion block")
                self.waitingView.isHidden = true
                self.waitingImageView.isHidden = true
                
            })
        }
    }
    
        func stopAnimation(){
            ARSLineProgress.hide()
            if currentUser?.gender == 1 {
                userStatus = statuses.offline
            }
        }
    
    
    fileprivate func progressDemoHelper(success: Bool) {
        self.isSuccess = success
        self.ars_launchTimer()
    }
    
    fileprivate func ars_launchTimer() {
        let dispatchTime = DispatchTime.now() + Double(Int64(0.01 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC);
        
        DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
            self.progressObject!.completedUnitCount += Int64(arc4random_uniform(30))
            
            if self.isSuccess == false && self.progressObject!.fractionCompleted >= 0.7 {
                ARSLineProgress.cancelProgressWithFailAnimation(true, completionBlock: {
                    print("Hidden with completion block")
                })
                return
            } else {
                if self.progressObject!.fractionCompleted >= 1.0 { return }
            }
            
            self.ars_launchTimer()
        })
    }
}

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):    return l < r
    case (nil, _?):        return true
    default:            return false
    }
}

fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):    return l >= r
    default:            return !(lhs < rhs)
    }
}





