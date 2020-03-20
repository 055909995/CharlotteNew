//
//  PresentationViewController.swift
//  VideoChat
//
//  Created by Vardan Sargsyan on 3/19/20.
//  Copyright © 2020 Vardan. All rights reserved.
//

import UIKit

class PresentationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if showPresenter{
            self.performSegue(withIdentifier: "callScreen", sender: nil)
        }else{
            self.tabBarController?.selectedIndex = 0
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        _ = segue.destination as? CallScreenViewController
    }

}
