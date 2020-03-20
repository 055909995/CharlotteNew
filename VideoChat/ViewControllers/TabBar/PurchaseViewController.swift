//
//  PurchaseViewController.swift
//  VideoChat
//
//  Created by Vardan Sargsyan on 8/29/19.
//  Copyright © 2019 Vardan. All rights reserved.
//

import UIKit
import StoreKit

class PurchaseViewController: UIViewController {
    
    
    @IBOutlet var purchaseBtns: [UIButton]!
    var productsArray = [SKProduct]()
    let productIDs = ["VS.Charlotte.15minutes","VS.Charlotte.30minutes","VS.Charlotte.60minutes","VS.Charlotte.120minutes","VS.Charlotte.180minutes"]

    override func viewDidLoad() {
        super.viewDidLoad()
        PKIAPHandler.shared.setProductIds(ids: self.productIDs)
        let sv = UIViewController.displaySpinner(onView: self.view)
        PKIAPHandler.shared.fetchAvailableProducts { [weak self](products)   in
            guard let sSelf = self else {return}
            sSelf.productsArray = products
            print(sSelf.productsArray)
            UIViewController.removeSpinner(spinner: sv)
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func closeBtnTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func purchase(product : SKProduct){
        
        PKIAPHandler.shared.purchase(product: product) { (alert, product, transaction) in
            if let tran = transaction, let prod = product {
                let payment = SKPayment(product: prod)
                SKPaymentQueue.default().add(payment)
//                HTTPClient.shared.payment{ (response, error) in
//                    if response != nil {
//                        print(response as Any)
//                    } else {
//                        print("error")
//                    }
//                }
                
            }
        }
    }
    

    @IBAction func btnPurchaseTapped(_ sender: UIButton) {
        switch sender {
        case purchaseBtns[0]:
            print("15")
            self.purchase(product: self.productsArray[1])
            HTTPClient.shared.paymentCost = "15"
        case purchaseBtns[1]:
            print("30")
            self.purchase(product: self.productsArray[3])
            HTTPClient.shared.paymentCost = "30"
        case purchaseBtns[2]:
            print("60")
            self.purchase(product: self.productsArray[4])
            HTTPClient.shared.paymentCost = "60"
        case purchaseBtns[3]:
            print("120")
            self.purchase(product: self.productsArray[0])
            HTTPClient.shared.paymentCost = "120"
        case purchaseBtns[4]:
            print("180")
            self.purchase(product: self.productsArray[2])
            HTTPClient.shared.paymentCost = "180"
        default:
            return
        }
        
    }
    

}
