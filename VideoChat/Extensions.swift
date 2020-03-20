//
//  Extensions.swift
//  VideoChat
//
//  Created by Vardan Sargsyan on 3/19/20.
//  Copyright © 2020 Vardan. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    class func displaySpinner(onView : UIView) -> UIView {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        return spinnerView
    }
    
    class func removeSpinner(spinner :UIView) {
        DispatchQueue.main.async {
            spinner.removeFromSuperview()
        }
    }
    
    func displayErrorMessage(message:String) {
        let alertView = UIAlertController(title: "Error!", message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
        }
        alertView.addAction(OKAction)
        if let presenter = alertView.popoverPresentationController {
            presenter.sourceView = self.view
            presenter.sourceRect = self.view.bounds
        }
        self.present(alertView, animated: true, completion:nil)
    }
    
    func displayAlert(message: String, header: String, Action1: String, Action2: String) {
        let alertView = UIAlertController(title: header, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: Action1, style: .default) { (action:UIAlertAction) in
        }
        alertView.addAction(OKAction)
        if let presenter = alertView.popoverPresentationController {
            presenter.sourceView = self.view
            presenter.sourceRect = self.view.bounds
        }
        self.present(alertView, animated: true, completion:nil)
        
    }
}





extension UIImageView {
    func download(from url: URL,contentMode: UIView.ContentMode = .scaleAspectFit, placeholder: UIImage? = nil, completionHandler: ((UIImage?) -> Void)? = nil) {
        
        image = placeholder
        self.contentMode = contentMode
        URLSession.shared.dataTask(with: url) { (data, response, _) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data,
                let image = UIImage(data: data)
                else {
                    completionHandler?(nil)
                    return
            }
            DispatchQueue.main.async { [unowned self] in
                self.image = image
                completionHandler?(image)
            }
        }.resume()
    }
}




extension String {
    func getEstimatedFrame(_ width:CGFloat) -> CGRect {
        let size = CGSize(width: width, height: 100000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let estimatedFrame = NSString(string: self).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)], context: nil)
        return estimatedFrame
    }
    
    
}




extension UITableView {
    func scrollTableViewToBottom(animated: Bool) {
        guard let dataSource = dataSource else { return }
        var lastSectionWithAtLeasOneElements = (dataSource.numberOfSections?(in: self) ?? 1) - 1
        while dataSource.tableView(self, numberOfRowsInSection: lastSectionWithAtLeasOneElements) < 1 {
            lastSectionWithAtLeasOneElements -= 1
        }
        let lastRow = dataSource.tableView(self, numberOfRowsInSection: lastSectionWithAtLeasOneElements) - 1
        guard lastSectionWithAtLeasOneElements > -1 && lastRow > -1 else { return }
        let bottomIndex = IndexPath(item: lastRow, section: lastSectionWithAtLeasOneElements)
        scrollToRow(at: bottomIndex, at: .bottom, animated: animated)
    }
}




extension Notification.Name {
    static let nextBtnTappet = Notification.Name("nextBtnTappet")
    static let endCallBtnTapped = Notification.Name("endCallBtnTapped")
    static let muteBtnTapped = Notification.Name("muteBtnTapped")
    static let showGift = Notification.Name("showGift")
    static let callAccepted = Notification.Name("callAccepted")
    static let reloadTableView = Notification.Name("reloadTableView")
}




extension UIView {
    func addBlurView(view: UIView){
        if !UIAccessibility.isReduceTransparencyEnabled {
            view.backgroundColor = .clear
            if #available(iOS 13.0, *) {
                let blurEffect = UIBlurEffect(style: .systemChromeMaterialDark)
                let blurEffectView = UIVisualEffectView(effect: blurEffect)
                //always fill the view
                blurEffectView.frame = view.bounds
                blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                blurEffectView.clipsToBounds = true
                blurEffectView.layer.cornerRadius = 30
                blurEffectView.alpha = 0.75
                
                view.addSubview(blurEffectView)
                view.sendSubviewToBack(blurEffectView)
            } else {
                let blurEffect = UIBlurEffect(style: .dark)
                let blurEffectView = UIVisualEffectView(effect: blurEffect)
                //always fill the view
                blurEffectView.frame = view.bounds
                blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                blurEffectView.clipsToBounds = true
                blurEffectView.layer.cornerRadius = 30
                blurEffectView.alpha = 0.75
                
                view.addSubview(blurEffectView)
                view.sendSubviewToBack(blurEffectView)
            }
        } else {
            view.backgroundColor = .black
        }
    }
}
