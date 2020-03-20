//
//  ChangingViewController.swift
//  VideoChat
//
//  Created by Vardan Sargsyan on 9/3/19.
//  Copyright © 2019 Vardan. All rights reserved.
//

import UIKit

class ChangingViewController: UIViewController {
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var txt1: UITextField!
    @IBOutlet weak var txt2: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var lbl1Title: UILabel!
    @IBOutlet weak var lbl2Title: UILabel!
    var alertTitle = ""
    var alertDescription = ""
    var alertAction1 = ""
    var alertAction2 = ""
    var sucAlertTitle = ""
    var sucAlertDescription = ""
    var sucAlertAction = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.applyDesign()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.applyDesign()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height/2.7
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    func applyDesign(){
        txt1.layer.cornerRadius = txt1.frame.height/2
        txt2.layer.cornerRadius = txt2.frame.height/2
        switch HTTPClient.shared.changable {
        case "username":
            switch UserDefaults.standard.string(forKey: "language") {
            case "ru":
                alertTitle = "Внимание"
                alertDescription = "Вы действительно хотите поменять имя пользователя?"
                alertAction1 = "Да"
                alertAction2 = "Нет"
                sucAlertTitle = "Успешно"
                sucAlertDescription = "Вы успешно поменяли имя пользователя"
                sucAlertAction = "Хорошо"
                txt1.placeholder = "Новое имя пользователя"
                txt2.placeholder = "Пароль"
                lblHeader.text = "Сменить имя пользователя"
                lbl1Title.text = "Новое имя пользователя"
                lbl2Title.text = "Пароль"
            case "en":
                alertTitle = "Attention"
                alertDescription = "Do You want to change username?"
                alertAction1 = "Yes"
                alertAction2 = "No"
                sucAlertTitle = "Success"
                sucAlertDescription = "The username has changed"
                sucAlertAction = "OK"
                txt1.placeholder = "New Username"
                txt2.placeholder = "Password"
                lblHeader.text = "Change username"
                lbl1Title.text = "New Username"
                lbl2Title.text = "Password"
            default:
                return
            }
        case "password":
            switch UserDefaults.standard.string(forKey: "language") {
            case "ru":
                alertTitle = "Внимание"
                alertDescription = "Вы действительно хотите поменять пароль?"
                alertAction1 = "Да"
                alertAction2 = "Нет"
                sucAlertTitle = "Успешно"
                sucAlertDescription = "Вы успешно поменяли пароль"
                sucAlertAction = "Хорошо"
                txt1.placeholder = "Старый пароль"
                txt2.placeholder = "Новый пароль"
                lblHeader.text = "Сменить пароль"
                lbl1Title.text = "Старый пароль"
                lbl2Title.text = "Новый пароль"
            case "en":
                alertTitle = "Attention"
                alertDescription = "Do You want to change password?"
                alertAction1 = "Yes"
                alertAction2 = "No"
                sucAlertTitle = "Success"
                sucAlertDescription = "The password has changed"
                sucAlertAction = "OK"
                txt1.placeholder = "Old Password"
                txt2.placeholder = "New Password"
                lblHeader.text = "Change password"
                lbl1Title.text = "Old Password"
                lbl2Title.text = "New Password"

            default:
                return
            }
            
        case "email":
            switch UserDefaults.standard.string(forKey: "language") {
            case "ru":
                alertTitle = "Внимание"
                alertDescription = "Вы действительно хотите поменять ел.адрес?"
                alertAction1 = "Да"
                alertAction2 = "Нет"
                sucAlertTitle = "Успешно"
                sucAlertDescription = "Вы успешно поменяли ел.адрес"
                sucAlertAction = "Хорошо"
                txt1.placeholder = "Новый эл.адрес"
                txt2.placeholder = "Пароль"
                lblHeader.text = "Сменить эл.адрес"
                lbl1Title.text = "Новый эл.адрес"
                lbl2Title.text = "Пароль"
            case "en":
                alertTitle = "Attention"
                alertDescription = "Do You want to e-mail?"
                alertAction1 = "Yes"
                alertAction2 = "No"
                sucAlertTitle = "Success"
                sucAlertDescription = "The e-mail has changed"
                sucAlertAction = "OK"
                txt1.placeholder = "New e-mail"
                txt2.placeholder = "Password"
                lblHeader.text = "Change e-mail"
                lbl1Title.text = "New e-mail"
                lbl2Title.text = "Password"
            default:
                return
            }
            
        default:
            break
        }
        
        switch UserDefaults.standard.string(forKey: "language") {
        case "ru":
            self.btnSubmit.setTitle("Подтвердить", for: .normal)
        case "en":
            self.btnSubmit.setTitle("Submit", for: .normal)
        default:
            return
        }
        
    }
    
    func showAlert(){
        let alertView = UIAlertController(title: sucAlertTitle, message: sucAlertDescription, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: sucAlertAction, style: .default) { (action:UIAlertAction) in
            self.dismiss(animated: true, completion: nil)
        }
        alertView.addAction(OKAction)
        if let presenter = alertView.popoverPresentationController {
            presenter.sourceView = self.view
            presenter.sourceRect = self.view.bounds
        }
        self.present(alertView, animated: true, completion:nil)
    }
    
    
    
    func changeUsername(){
        let alertView = UIAlertController(title: self.alertTitle, message: self.alertDescription, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: self.alertAction1, style: .default) { (action:UIAlertAction) in
            let md5Data = HTTPClient.shared.MD5(string: self.txt2.text! )
            let md5Hex =  md5Data.map { String(format: "%02hhx", $0) }.joined()
            HTTPClient.shared.changeUsername(username: self.txt1.text!, password: self.txt2.text!) { (response) in
                if response != nil {
                    self.showAlert()
                    
                    print(response?.message as Any)
                } else {
                    print(response?.error as Any)
                }
            }
        }
        
        let CancelAction = UIAlertAction(title: self.alertAction2, style: .default) { (action:UIAlertAction) in
        }
        alertView.addAction(OKAction)
        alertView.addAction(CancelAction)
        if let presenter = alertView.popoverPresentationController {
            presenter.sourceView = self.view
            presenter.sourceRect = self.view.bounds
        }
        self.present(alertView, animated: true, completion:nil)
    }
    
    
    func changePassword(){
        let alertView = UIAlertController(title: self.alertTitle, message: self.alertDescription, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: self.alertAction1, style: .default) { (action:UIAlertAction) in
            let md5Data1 = HTTPClient.shared.MD5(string: self.txt2.text! )
            let md5Data2 = HTTPClient.shared.MD5(string: self.txt1.text! )
            let newPass =  md5Data1.map { String(format: "%02hhx", $0) }.joined()
            let OldPass =  md5Data2.map { String(format: "%02hhx", $0) }.joined()
            HTTPClient.shared.changePassword(newPassword: self.txt2.text!, oldPassword: self.txt1.text!) { (response) in
                if response != nil {
                    self.showAlert()
                    print(response?.message as Any)
                } else {
                    print(response as Any)
                }
            }
        }
        
        let CancelAction = UIAlertAction(title: self.alertAction2, style: .default) { (action:UIAlertAction) in
        }
        alertView.addAction(OKAction)
        alertView.addAction(CancelAction)
        if let presenter = alertView.popoverPresentationController {
            presenter.sourceView = self.view
            presenter.sourceRect = self.view.bounds
        }
        self.present(alertView, animated: true, completion:nil)
    }
    
    func changeEmail(){
        let alertView = UIAlertController(title: self.alertTitle, message: self.alertDescription, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: self.alertAction1, style: .default) { (action:UIAlertAction) in
            HTTPClient.shared.changeEmail(email: self.txt1.text! , password: self.txt2.text!) { (response) in
                if response != nil {
                    self.showAlert()
                    print(response?.message as Any)
                } else {
                    print(response)
                }
            }
        }
        
        let CancelAction = UIAlertAction(title: self.alertAction2, style: .default) { (action:UIAlertAction) in
        }
        alertView.addAction(OKAction)
        alertView.addAction(CancelAction)
        if let presenter = alertView.popoverPresentationController {
            presenter.sourceView = self.view
            presenter.sourceRect = self.view.bounds
        }
        self.present(alertView, animated: true, completion:nil)
    }
    
    
    @IBAction func btnSubmitTapped(_ sender: Any) {
        switch HTTPClient.shared.changable {
        case "username":
            self.changeUsername()
        case "password":
            self.changePassword()
        case "email":
            self.changeEmail()
        default:
            break
        }
    }
    
    @IBAction func btnBackTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func hideKeyboardGstr(_ sender: Any) {
        self.view.endEditing(true)
    }
    
}
