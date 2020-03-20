//
//  ChatTableViewCell.swift
//  VideoChat
//
//  Created by Vardan Sargsyan on 6/30/19.
//  Copyright © 2019 Vardan. All rights reserved.
//

import UIKit
//import Sinch

class OutgoingMessageTableViewCell: UITableViewCell {

    @IBOutlet weak var bubbleBackgroung: UIView!
    @IBOutlet weak var lblOutgoingMessage: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.bubbleBackgroung.layer.cornerRadius = 15
        self.userImage.layer.cornerRadius = self.userImage.frame.height/2

    }


    
    func setMessage(_ model: inout String) {
        //model.removeFirst()
        lblOutgoingMessage.text = model

    }
    


}

class IncomingMessageTableViewCell: UITableViewCell {

    @IBOutlet weak var bubbleBackgroung: UIView!
    @IBOutlet weak var lblIncomingMessage: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.bubbleBackgroung.layer.cornerRadius = 15
        self.userImage.layer.cornerRadius = self.userImage.frame.height/2
     
    }
    
    func setMessage(_ model: inout String) {
        //model.removeFirst()
        lblIncomingMessage.text = model
    }
    

}
