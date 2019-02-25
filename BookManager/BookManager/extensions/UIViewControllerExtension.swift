//
//  UIViewController + extension.swift
//  BookManagement
//
//  Created by yoshino1010 on 2019/01/03.
//  Copyright © 2019年 yoshino1010. All rights reserved.
//

import UIKit

extension UIViewController: UIViewControllerTransitioningDelegate {
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return PopUpPresentation(presentedViewController: presented, presenting: presenting)
    }
}
