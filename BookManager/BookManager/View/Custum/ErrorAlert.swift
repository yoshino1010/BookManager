//
//  ErrorAlert.swift
//  BookManagement
//
//  Created by 吉野瑠 on 2019/02/25.
//  Copyright © 2019 吉野瑠. All rights reserved.
//

import UIKit

class ErrorAlert {
    private var rootViewController: UIViewController? {
        if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
            return navigationController.visibleViewController
        }
        return nil
    }
    private var alert: UIAlertController
    
    init(message: String) {
        alert = UIAlertController(title: "エラー", message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(defaultAction)
    }
    
    func show() {
        rootViewController?.present(alert, animated: true, completion: nil)
    }
}
