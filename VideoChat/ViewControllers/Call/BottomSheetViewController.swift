//
//  BottomSheetViewController.swift
//  VideoChat
//
//  Created by Vardan Sargsyan on 3/15/20.
//  Copyright © 2020 Vardan. All rights reserved.
//

import UIKit

class BottomSheetViewController : UIViewController {

    
    @IBOutlet weak var messagesTableView: UITableView!
    @IBOutlet weak var txtMessage: UITextField!
    @IBOutlet weak var giftsCollectionView: UICollectionView!
    @IBOutlet weak var giftsView: UIView!
    
    
     var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.messagesTableView.delegate = self
        self.messagesTableView.dataSource = self
        self.giftsCollectionView.delegate = self
        self.giftsCollectionView.dataSource = self
        self.messagesTableView.backgroundColor = UIColor.clear
        txtMessage.attributedPlaceholder =  NSAttributedString(string: "Write yoyr message here", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
//        var incoming = false
//        for _ in 0..<10{
//            incoming = !incoming
//            if incoming {
//                let message = Message(text: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has", type: .incoming)
//                self.messages.append(message)
//            }else{
//                let message = Message(text: "Lorem Ipsum is simply dummy text of the printing and typesetting", type: .outgoing)
//                self.messages.append(message)
//            }
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
       prepare()
    }

    
    func prepare(){
        self.messagesTableView.scrollTableViewToBottom(animated: false)
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2)
        self.view.frame = frame
        self.view.addBlurView(view: view)
    }
    
//MARK:- Actions
    
    @IBAction func sendMessageBtn(_ sender: Any) {
        if self.txtMessage.text?.isEmpty == false{
            let message = Message(text: self.txtMessage.text!, type: .outgoing)
            self.messages.append(message)
            self.messagesTableView.reloadData()
            self.txtMessage.text = ""
            self.messagesTableView.scrollTableViewToBottom(animated: true)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
                var incomingMessage = message
                incomingMessage.type = .incoming
                self.messages.append(incomingMessage)
                self.messagesTableView.reloadData()
                self.messagesTableView.scrollTableViewToBottom(animated: true)
            })
        }
    }
    
    @IBAction func btnEndCallTapped(_ sender: Any) {
        NotificationCenter.default.post(name: .endCallBtnTapped, object: nil)
        self.messages = []
        self.messagesTableView.reloadData()
    }
    @IBAction func btnMuteTapped(_ sender: Any) {
        NotificationCenter.default.post(name: .muteBtnTapped, object: nil)
    }
    @IBAction func btnNextTapped(_ sender: Any) {
        remoteUser = nil
        NotificationCenter.default.post(name: .nextBtnTappet, object: nil)
        self.messages = []
        self.messagesTableView.reloadData()
    }
    
    
    @IBAction func btnSendGiftTapped(_ sender: UIButton) {
        if self.giftsView.isHidden{
            self.giftsView.isHidden = false
            self.messagesTableView.isHidden = true
            sender.setImage(#imageLiteral(resourceName: "chatingIcon"), for: .normal)
        }else{
            self.giftsView.isHidden = true
            self.messagesTableView.isHidden = false
            sender.setImage(#imageLiteral(resourceName: "giftBtn"), for: .normal)
        }
    }
    
    @IBAction func btnAddToFriendsTapped(_ sender: Any) {
    }
    
    
    
    
}





//MARK: - UITableViewDataSource & UITableViewDelegate
extension BottomSheetViewController : UITextFieldDelegate , UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
            return self.messages.count
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1

        }
        
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 0.1
        }
        func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
            return UITableView.automaticDimension
        }
        
     
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            let oneMessage = self.messages[indexPath.section]
            if oneMessage.type == .incoming {
                let cellHeight = oneMessage.text.getEstimatedFrame(250).height + 42
                return cellHeight
            }else if oneMessage.type == .outgoing{
                let cellHeight = oneMessage.text.getEstimatedFrame(250).height + 42
                return cellHeight
            } else {
                return 100.0
            }
        }
        
        
        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let view = UIView()
            //view.backgroundColor = UIColor.clear
            return view
        }
    
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            var oneMessage = self.messages[indexPath.section]
            if oneMessage.type == .incoming {
                let cell = tableView.dequeueReusableCell(withIdentifier: "IncomingMessageTableViewCell", for: indexPath) as! IncomingMessageTableViewCell
                cell.setMessage(&oneMessage.text)
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "OutgoingMessageTableViewCell", for: indexPath) as! OutgoingMessageTableViewCell
                cell.setMessage(&oneMessage.text)
                return cell
            }
            
        }
    }

//MARK: - UICollectionViewDataSource & UICollectionViewDelegate
extension BottomSheetViewController :  UICollectionViewDelegate , UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gifts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GiftsCollectionViewCell", for: indexPath) as! GiftsCollectionViewCell
        cell.imgGift.image = gifts[indexPath.row]
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        giftForShow = gifts[indexPath.row]
        NotificationCenter.default.post(name: .showGift, object: nil)
        //    switch indexPath.row {
        //    case 0:
        //       self.sendMessage(message: "giftId=firstGift")
        //    case 1:
        //        self.sendMessage(message: "giftId=secondGift")
        //    case 2:
        //        self.sendMessage(message: "giftId=thirdGift")
        //    case 3:
        //        self.sendMessage(message: "giftId=fourthGift")
        //    case 4:
        //        self.sendMessage(message: "giftId=fifthGift")
        //    default:
        //        break
        //    }
    }
}











