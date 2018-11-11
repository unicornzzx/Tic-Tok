//
//  AlertMessage.swift
//  Tic-Tac
//
//  Created by Zhixiang.Zhang on 2018/5/14.
//  Copyright © 2018 Echo. All rights reserved.
//

import UIKit

class AlertMessage {
    static func alertOnlyConfirm(viewController : UIViewController, title : String, message : String){
        let alertController:UIAlertController=UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Confirm", style: UIAlertActionStyle.default))
        viewController.present(alertController, animated: true, completion: nil)
    }
}
