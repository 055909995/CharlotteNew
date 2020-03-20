//
//  InputUserDataViewController.swift
//  VideoChat
//
//  Created by Vardan Sargsyan on 3/14/20.
//  Copyright © 2020 Vardan. All rights reserved.
//

import UIKit

class InputUserDataViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var txtFields: [UITextField]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for i in txtFields {
            setUnderline(textField: i)
            i.delegate = self
            i.layer.cornerRadius = i.frame.height/2
        }
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
          switch textField {
              case txtFields[0]:
                  txtFields[1].becomeFirstResponder()
                  return true
              case txtFields[1]:
                  txtFields[2].becomeFirstResponder()
                  return true
              case txtFields[3]:
                  self.countinue()
                  return true
              default:
                  return true
              }
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

    func setUnderline(textField : UITextField) {
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.white.cgColor
        border.frame = CGRect(x: 0, y: textField.frame.size.height - width, width:  textField.frame.size.width, height: textField.frame.size.height)
        
        border.borderWidth = width
        textField.layer.addSublayer(border)
        textField.layer.masksToBounds = true
    }
    
    
    func setNewUserData(){
        newUser.userName = txtFields[1].text
        newUser.email = txtFields[0].text!
        newUser.password = txtFields[2].text!
    }
    
    func countinue(){
        for txtfield in txtFields {
            if txtfield.text == ""{
                displayErrorMessage(message: "Complete all fields!")
                return
            }
        }
        setNewUserData()
        if newUser.gender == "1"{
            let femaleVC = self.storyboard?.instantiateViewController(withIdentifier: "FemaleCompleteRegistartonViewController") as! FemaleCompleteRegistartonViewController
            self.navigationController?.pushViewController(femaleVC, animated: true)
        }else{
            let maleVC = self.storyboard?.instantiateViewController(withIdentifier: "MaleCompleteRegistartionViewController") as! MaleCompleteRegistartionViewController
            self.navigationController?.pushViewController(maleVC, animated: true)
        }
    }
    
    @IBAction func continoueBtnTapped(_ sender: Any) {
        self.countinue()

    }
    
    @IBAction func gstrTapped(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    
    

}
