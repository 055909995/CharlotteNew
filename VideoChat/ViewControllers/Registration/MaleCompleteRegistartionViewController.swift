//
//  MaleCompleteRegistartionViewController.swift
//  VideoChat
//
//  Created by Vardan Sargsyan on 3/14/20.
//  Copyright © 2020 Vardan. All rights reserved.
//

import UIKit
import Quickblox
import QuickbloxWebRTC

class MaleCompleteRegistartionViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate {
    

    @IBOutlet weak var uploadImageImageView: UIImageView!
    @IBOutlet weak var btnCreateAccount: UIButton!
    var spinner: UIView?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uploadImageImageView.layer.cornerRadius = uploadImageImageView.frame.height/2

        self.btnCreateAccount.isUserInteractionEnabled = false
        self.btnCreateAccount.isEnabled = false
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImage: UIImage?
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage]   as? UIImage {
            selectedImage = editedImage
        }
        let resizedImage = self.resizeImage(image: selectedImage!, targetSize: CGSize(width: 250.0, height: 250.0))
        picker.dismiss(animated: true) {
            self.uploadImageImageView.image = resizedImage
            self.btnCreateAccount.isUserInteractionEnabled = true
            self.btnCreateAccount.isEnabled = true
        }
    }
    

     func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size

        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }

    
    @IBAction func uploadImgGestureTapped(_ sender: UITapGestureRecognizer) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true)
    }
    
    
    func window() -> UIWindow? {
        return (UIApplication.shared.delegate as? AppDelegate)?.window
    }

    func loadHomeScreen(){
        let tabBarController  = self.storyboard?.instantiateViewController(withIdentifier: "HomeTabBarController") as! UITabBarController
        tabBarController.tabBar.barTintColor = UIColor.clear
        tabBarController.tabBar.backgroundImage = UIImage()
        tabBarController.tabBar.shadowImage = UIImage()
        tabBarController.tabBar.selectionIndicatorImage = UIImage()
        window()?.rootViewController = tabBarController
        window()?.makeKeyAndVisible()
        let img = self.uploadImageImageView.image!.jpegData(compressionQuality:1.0)
        
    }

    func register() {
        HTTPClient.shared.register(newUser: newUser){ response in
            let response = response
            if let userID = response?.userID {
                UserDefaults.standard.set(userID, forKey: "uId")
                UserDefaults.standard.set(response?.gender, forKey: "gender")
                NotificationCenter.default.post(name: NSNotification.Name("UserDidLoginNotification"), object: nil, userInfo: ["userId": String(userID)])
                self.getUserData(userID: String(userID))
            } else {
                print(response?.error as Any)
            }
        }
    }
    
    
    func getUserData(userID: String){
        HTTPClient.shared.getUserData(id: userID, complition: {response in
            if (response?.userID) != nil {
                currentUser = response
                let img = self.uploadImageImageView.image!.jpegData(compressionQuality:1.0)
                HTTPClient.shared.uploadImage(imgData: img) { (resp) in
                    UIViewController.removeSpinner(spinner: self.spinner!)
                    self.loadHomeScreen()
                    QBChatConnectionClient.shared.signUp(login: currentUser!.userName!, externalID: currentUser!.userID)
                }
            }else{
                print(response?.message as Any)
            } 
        })
    }

    
    @IBAction func btnCreateAccountTapped(_ sender: Any) {
        self.register()
        spinner = UIViewController.displaySpinner(onView: self.view)
    }
    
    
    
 

}
