//
//  SettingsViewController.swift
//  VideoChat
//
//  Created by Vardan Sargsyan on 9/1/19.
//  Copyright © 2019 Vardan. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var bottomViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var lblLanguage: UILabel!
    @IBOutlet weak var lblSecurity: UILabel!
    @IBOutlet weak var lblAccountSettings: UILabel!
    @IBOutlet weak var btnChangePassword: UIButton!
    @IBOutlet weak var btnShowAll: UIButton!
    @IBOutlet weak var btnChangeEmail: UIButton!
    @IBOutlet weak var btnChangeUsername: UIButton!
    @IBOutlet weak var lblSettings: UILabel!
    @IBOutlet weak var btnDeleteCallHistory: UIButton!
    @IBOutlet weak var btnLogOut: UIButton!
    @IBOutlet weak var langSelectSegment: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.applyDesign()
    }
    
    func applyDesign(){
        if self.view.frame.height / self.view.frame.width >= 2 {
            self.bottomViewHeight.constant = 145
        }else{
            self.bottomViewHeight.constant = 90
        }
        
        switch UserDefaults.standard.string(forKey: "language") {
        case "ru":
            self.lblLanguage.text = "Язык"
            self.lblSecurity.text = "Безопасность"
            self.lblSettings.text = "Настройки"
            self.lblAccountSettings.text = "Настройки Профиля"
            self.btnChangeEmail.setTitle("Изменить эл.адрес", for: .normal)
            self.btnLogOut.setTitle("Выйти", for: .normal)
            self.btnChangePassword.setTitle("Изменить пароль", for: .normal)
            self.btnShowAll.setTitle("Показать все", for: .normal)
            self.btnDeleteCallHistory.setTitle("Удалить исторю вызовов", for: .normal)
            self.btnChangeUsername.setTitle("Изменить имя пользователя", for: .normal)
            self.langSelectSegment.selectedSegmentIndex = 1
        case "en":
            self.lblLanguage.text = "Language"
            self.lblSecurity.text = "Security"
            self.lblSettings.text = "Settings"
            self.lblAccountSettings.text = "Account settings"
            self.btnChangeEmail.setTitle("Change e.mail", for: .normal)
            self.btnLogOut.setTitle("Log Out", for: .normal)
            self.btnChangePassword.setTitle("Change password", for: .normal)
            self.btnShowAll.setTitle("Show All", for: .normal)
            self.btnDeleteCallHistory.setTitle("Delete call history", for: .normal)
            self.btnChangeUsername.setTitle("Change username", for: .normal)
            self.langSelectSegment.selectedSegmentIndex = 0
        default:
            return
        }
    }

    @IBAction func btnLogOutTapped(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "uId")
        let window = (UIApplication.shared.delegate as? AppDelegate)?.window
        let navigationController  = self.storyboard?.instantiateViewController(withIdentifier: "HomeNavigationController") as! UINavigationController
        window?.rootViewController = navigationController
        let nvc = window?.rootViewController as! UINavigationController
        let signInvc = self.storyboard?.instantiateViewController(withIdentifier: "SelectGenderViewController") as! SelectGenderViewController
        nvc.pushViewController(signInvc, animated: true)
        //(UIApplication.shared.delegate as? AppDelegate)?.client = nil
        userStatus = statuses.offline
//        HTTPClient.shared.setStatus{ (response, error) in
//            if response != nil {
//                print(response as Any)
//            } else {
//                print(error as Any)
//            }
//        }
    }
    @IBAction func changeLanguageTapped(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex  {
        case 0:
            UserDefaults.standard.set("en", forKey: "language")
        case 1:
            UserDefaults.standard.set("ru", forKey: "language")
        default:
            UserDefaults.standard.set("en", forKey: "language")
        }
        self.applyDesign()
    }
    
    @IBAction func btnChangeUsernameTapped(_ sender: Any) {
        HTTPClient.shared.changable = "username"
    }
    @IBAction func btnChangeEmailTapped(_ sender: Any) {
        HTTPClient.shared.changable = "email"
    }
    @IBAction func btnChangePasswordTapped(_ sender: Any) {
        HTTPClient.shared.changable = "password"
    }
    
    
    
}
