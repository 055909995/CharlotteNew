//
//  AccountViewController.swift
//  VideoChat
//
//  Created by Vardan Sargsyan on 8/5/19.
//  Copyright © 2019 Vardan. All rights reserved.
//

import UIKit


class AccountViewController: UIViewController, UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    

    

    // MARK: - Outlets
    
    @IBOutlet weak var btnStatusMale: UIButton!
    @IBOutlet weak var btnBalanceMale: UIButton!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnBalanceWoman: UIButton!
    @IBOutlet weak var btnDemo: UIButton!
    @IBOutlet weak var btnTariffs: UIButton!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userImageView: UIView!

    @IBOutlet weak var tabbarBackground: UIImageView!
    @IBOutlet weak var bottonViewHeight: NSLayoutConstraint!
    @IBOutlet weak var searchFilterSegmentController: UISegmentedControl!
    @IBOutlet weak var stackViewFemale: UIStackView!
    
    // MARK: - Variables
    
    private var progressObject: Progress?
    private var isSuccess: Bool?
    var selfBalance = ""
    var demo = ""
    
    
    // MARK: - LyfeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        UserDefaults.standard.set("en", forKey: "language")
        applyDesign()
    }
    
   
    
   

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        cameFrom = .homeTabBar
        showPresenter = true
        self.tabBarController?.tabBar.isHidden = false
        if self.tabBarController?.viewControllers?.count == 6 {
            self.tabBarController?.viewControllers?.remove(at: 5)
            self.tabBarController?.reloadInputViews()
        }
        //self.getUserBalance()
        self.getUserData()
        if currentUser?.demo == 1 && UserDefaults.standard.string(forKey: "language") == "en"{
            self.demo = "demo"
        }else if currentUser?.demo == 1 && UserDefaults.standard.string(forKey: "language") == "ru"{
            self.demo = "демо"
        }else if currentUser?.demo == 0 && UserDefaults.standard.string(forKey: "language") == "ru"{
            self.demo = "премиум"
        }else if currentUser?.demo == 0 && UserDefaults.standard.string(forKey: "language") == "en"{
            self.demo = "premium"
        }

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
//        if searchFilterSegmentController.selectedSegmentIndex == 0 {
//            HTTPClient.shared.status = "online"
//            HTTPClient.shared.selectedStatus = "online"
//        } else if searchFilterSegmentController.selectedSegmentIndex == 1 {
//            HTTPClient.shared.status = "onlinefd"
//            HTTPClient.shared.selectedStatus = "onlinefd"
//        } else if searchFilterSegmentController.selectedSegmentIndex == 2{
//            HTTPClient.shared.status = "onlinefp"
//            HTTPClient.shared.selectedStatus = "onlinefp"
//        }else{
//            HTTPClient.shared.status = "online"
//            HTTPClient.shared.selectedStatus = "online"
//        }
    }
    
    
    // MARK: - Funcionality
    
//    func encrypt(key: String){
//        do {
//            let key: [UInt8] = Array(key.utf8) as [UInt8]
//            let aes2 = try AES(key: key, blockMode: ECB() as BlockMode)
//            let aes = try AES(key: "Qub13JikM95R4nj8", iv: "1234567890123456") // aes128
//            let ciphertext = try aes2.encrypt(Array("Vardan".utf8))
//            let ciphertext1 = try aes.encrypt(Array("Vardan".utf8))
//            print(ciphertext.toBase64()!)
//            print(ciphertext1.toBase64()!)
//        } catch {
//            print(error)
//        }
//    }
    
    
    
    func updateInfo(){
        switch UserDefaults.standard.string(forKey: "language") {
        case "en":
            self.btnBalanceWoman.setTitle(" Balance: " + String(currentUser!.minutes!) + " min.",for: .normal)
            self.btnTariffs.setTitle( " Tariffs: (Current: 0.14$. Next: 0.18$ per/min.)", for: .normal)
            self.btnDemo.setTitle(" Minutes with demo per today: " + String(currentUser!.demoCount!) + " min.", for: .normal)
            self.searchFilterSegmentController.setTitle("All", forSegmentAt: 0)
            self.searchFilterSegmentController.setTitle("Demo", forSegmentAt: 1)
            self.searchFilterSegmentController.setTitle("Premium", forSegmentAt: 2)
            self.btnBalanceMale.setTitle(" Balance: " + String(currentUser!.minutes!) + " min.",for: .normal)
            self.btnStatusMale.setTitle(" Account status: " + self.demo ,for: .normal)
        case "ru":
            self.btnBalanceWoman.setTitle(" Баланс: " + String(currentUser!.minutes!) + " мин.",for: .normal)
            self.btnTariffs.setTitle( " Тарифф: (тек.: 0.14$. след.: 0.18$ за/мин.)", for: .normal)
            self.btnDemo.setTitle(" Минуты с демо за сегодня: " + String(currentUser!.demoCount!) + " мин.", for: .normal)
            self.searchFilterSegmentController.setTitle("Все", forSegmentAt: 0)
            self.searchFilterSegmentController.setTitle("Демо", forSegmentAt: 1)
            self.searchFilterSegmentController.setTitle("Премиум", forSegmentAt: 2)
            self.btnBalanceMale.setTitle(" Баланс: " + String(currentUser!.minutes!) + " мин.",for: .normal)
            self.btnStatusMale.setTitle(" Статус аккаунта: " + self.demo ,for: .normal)
        default:
            self.btnBalanceWoman.setTitle(" Balance: " + String(currentUser!.minutes!) + " min.",for: .normal)
            self.btnTariffs.setTitle( " Tariffs: (Current: 0.14$. Next: 0.18$ per/min.)", for: .normal)
            self.btnDemo.setTitle(" Minutes with demo per today: " + String(currentUser!.demoCount!) + " min.", for: .normal)
            self.searchFilterSegmentController.setTitle("All", forSegmentAt: 0)
            self.searchFilterSegmentController.setTitle("Demo", forSegmentAt: 1)
            self.searchFilterSegmentController.setTitle("Premium", forSegmentAt: 2)
            self.btnStatusMale.setTitle(" Account status: " + self.demo ,for: .normal)
        }
        lblName.text = currentUser?.userName
        userImage.image = currentUser?.userImage?.image
        if currentUser?.gender == 2 {
            self.stackViewFemale.isHidden = true
            self.btnBalanceMale.isHidden = false
            self.btnStatusMale.isHidden = false
            
            userStatus = statuses.online
            //            HTTPClient.shared.setStatus{ (response, error) in
            //                if response != nil {
            //                    print(response as Any)
            //                } else {
            //                    print(error as Any)
            //                }
            //            }
        }
    }
    
    
    func applyDesign(){
        if self.view.frame.height / self.view.frame.width >= 2 {
            self.bottonViewHeight.constant = 145
        }else{
            self.bottonViewHeight.constant = 90
        }
        self.userImage.layer.cornerRadius = self.userImage.frame.height/2
        self.userImageView.layer.cornerRadius = self.userImageView.frame.height/2
    
    }
    

    

    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImage: UIImage?
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage]   as? UIImage {
            selectedImage = editedImage
        }
        let resizedImage = self.resizeImage(image: selectedImage!, targetSize: CGSize(width: 250.0, height: 250.0))
        let img = resizedImage.jpegData(compressionQuality:1.0)
        HTTPClient.shared.uploadImage(imgData: img) { (response) in
            picker.dismiss(animated: true, completion: {
            sleep(1)
            self.getUserData()});
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

    func getUserData(){
        let sv = UIViewController.displaySpinner(onView: self.view)
        HTTPClient.shared.getUserData(id: UserDefaults.standard.string(forKey: "uId")!) { respnse in
            if (respnse?.userID) != nil{
                let user = respnse!
                if currentUser?.userImage == nil {
                    self.userImage.download(from: URL.init(string: user.avatar!)!)
                    currentUser?.userImage?.image = self.userImage.image
                }
                currentUser = user
                QBChatConnectionClient.shared.login(login: currentUser!.userName!, password: "quickblox")
                self.updateInfo()
                UIViewController.removeSpinner(spinner: sv)
            }else{
                print(respnse?.message as Any)
            }
        }
     }


    
    
    // MARK: - Actions
    
    @IBAction func btnChangeAvatarTapped(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true)
    }
    
    @IBAction func searchFilterSegmentTapped(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            userStatus = statuses.onlineff
        } else if sender.selectedSegmentIndex == 1 {
            userStatus = statuses.onfilnefd
        } else if sender.selectedSegmentIndex == 2{
            userStatus = statuses.onlinefp
        }else{
            userStatus = statuses.onlineff
        }
    }
}

// MARK: - Extensions







