//
//  SelectGenderViewController.swift
//  VideoChat
//
//  Created by Vardan Sargsyan on 3/14/20.
//  Copyright © 2020 Vardan. All rights reserved.
//

import UIKit


class SelectGenderViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var btnMale: UIButton!
    @IBOutlet weak var btnFemale: UIButton!
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnMale.layer.cornerRadius = btnMale.frame.height/2
        btnFemale.layer.cornerRadius = btnFemale.frame.height/2


    }

    

    

    @IBAction func btnMaleTapped(_ sender: Any) {
        newUser.gender = "2"
        let birthDayVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectBirthDateViewController") as! SelectBirthDateViewController
        self.navigationController?.pushViewController(birthDayVC, animated: true)
    }
    
    @IBAction func btnFemaleTapped(_ sender: Any) {
        newUser.gender = "1"
        let birthDayVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectBirthDateViewController") as! SelectBirthDateViewController
        self.navigationController?.pushViewController(birthDayVC, animated: true)
    }
    @IBAction func btnTest(_ sender: Any) {
        

        
//        if self.bottomSheetController.isTotallyExpanded{
//            self.bottomSheetController.expand()
//        }else{
//            self.bottomSheetController.collapse()
//        }
    }
    
}


