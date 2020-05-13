//
//  Alert.swift
//  Demograph
//
//  Created by iMac on 7/5/20.
//  Copyright © 2020 Frederick Holland. All rights reserved.
//

import Foundation
import UIKit
import EzPopup

class DGAlert {
    
    public static func alert(withTitle: String, message: String, controller: UIViewController) {
        let alert = AlertViewController.instantiate()
        alert.titleString = withTitle
        alert.messageString = message
        alert.view.backgroundColor = UIColor.white
        
        let popupVC = PopupViewController(contentController: alert, popupWidth: 300, popupHeight: 200)
        popupVC.backgroundAlpha = 1
        popupVC.backgroundColor = UIColor.white
        popupVC.canTapOutsideToDismiss = true
        popupVC.shadowEnabled = false
        
        controller.present(popupVC, animated: true, completion: nil)
    }
    
    public static func errorAlert(with: Int, controller: UIViewController) {
        let alert = AlertViewController.instantiate()
        alert.titleString = "An error occurred: \(with)"
        alert.messageString = DGError.errormsg(id: with)
        alert.view.backgroundColor = UIColor.white
        
        let popupVC = PopupViewController(contentController: alert, popupWidth: 300, popupHeight: 200)
        popupVC.backgroundAlpha = 1
        popupVC.backgroundColor = UIColor.white
        popupVC.canTapOutsideToDismiss = true
        popupVC.shadowEnabled = false
        
        controller.present(popupVC, animated: true, completion: nil)
    }
    
    public static func optionalAlert(withTitle: String, message: String, button: String, controller: UIViewController) {
        let alert = AlertViewController.instantiate()
        alert.titleString = withTitle
        alert.messageString = message
        alert.returnButton.titleLabel?.text = button
    }
    
}
