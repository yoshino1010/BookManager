//
//  UITextField + extension.swift
//  BookManagement
//
//  Created by yoshino1010 on 2019/02/22.
//  Copyright © 2019 yoshino1010. All rights reserved.
//

import UIKit

extension UITextField {
    var textNonNull: String {
        return text ?? ""
    }
    
    func addBorderBottom(height: CGFloat, color: UIColor) {
        let border = CALayer()
        border.frame = CGRect(x: 0, y: self.frame.height - height, width: self.frame.width, height: height)
        border.backgroundColor = color.cgColor
        self.layer.addSublayer(border)
    }
}
