//
//  SelectBirthDateViewController.swift
//  VideoChat
//
//  Created by Vardan Sargsyan on 3/14/20.
//  Copyright © 2020 Vardan. All rights reserved.
//

import UIKit

class SelectBirthDateViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var birthDateDatePicker: UIDatePicker!
    @IBOutlet weak var dateView: UIView!
    
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        birthDateDatePicker.setValue(UIColor.white, forKey: "textColor")
        dateView.layer.cornerRadius = 20
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    @IBAction func continueBtnTapped(_ sender: Any) {
        dateFormatter.dateFormat = "YYY-MM-dd"
        let bday = dateFormatter.string(from: birthDateDatePicker.date)
        newUser.bDay = bday
        let inputDataVC = self.storyboard?.instantiateViewController(withIdentifier: "InputUserDataViewController") as! InputUserDataViewController
        self.navigationController?.pushViewController(inputDataVC, animated: true)
    }
    

}
