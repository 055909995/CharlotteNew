//
//  LaunchViewController.swift
//  VideoChat
//
//  Created by Vardan Sargsyan on 9/30/19.
//  Copyright © 2019 Vardan. All rights reserved.
//

import UIKit
import ARSLineProgress

class LaunchViewController: UIViewController {
    private var progressObject: Progress?
    private var isSuccess: Bool?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.startAnimation()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        progressDemoHelper(success: true)
    }
    
    func startAnimation() {
        ARSLineProgressConfiguration.blurStyle = .regular
        ARSLineProgressConfiguration.backgroundViewStyle = .simple
        ARSLineProgressConfiguration.backgroundViewColor = UIColor.clear.cgColor
        ARSLineProgressConfiguration.showSuccessCheckmark = false
        ARSLineProgressConfiguration.circleColorInner = UIColor.white.cgColor
        ARSLineProgressConfiguration.circleColorOuter = UIColor.white.cgColor
        ARSLineProgressConfiguration.circleColorMiddle = UIColor.white.cgColor
        ARSLineProgressConfiguration.circleRotationDurationOuter = 3
        ARSLineProgressConfiguration.circleRotationDurationMiddle = 1.5
        ARSLineProgressConfiguration.circleRotationDurationInner = 1
        progressObject = Progress(totalUnitCount: 2)
        ARSLineProgressConfiguration.successCircleColor = UIColor.white.cgColor
        ARSLineProgressConfiguration.successCircleAnimationDrawDuration = 0.5
     //   ARSLineProgressConfiguration.showSuccessCheckmark = true
        ARSLineProgress.showWithProgressObject(progressObject!, completionBlock: {
            print("Success completion block")
            let signUpVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectGenderViewController") as! SelectGenderViewController
            self.navigationController?.pushViewController(signUpVC, animated: true)
        })
    }
    

 

}

extension LaunchViewController  {
    fileprivate func progressDemoHelper(success: Bool) {
        self.isSuccess = success
        self.ars_launchTimer()
    }
    
    fileprivate func ars_launchTimer() {
        let dispatchTime = DispatchTime.now() + Double(Int64(0.001 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC);
        
        DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
            self.progressObject!.completedUnitCount += Int64(arc4random_uniform(300))
            
            if self.isSuccess == false && self.progressObject?.fractionCompleted >= 0.5 {
                ARSLineProgress.cancelProgressWithFailAnimation(true, completionBlock: {
                    print("Hidden with completion block")
                })
                return
            } else {
                if self.progressObject?.fractionCompleted >= 1.0 { return }
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
