//
//  NSObjectExtension.swift
//  BookManagement
//
//  Created by yoshino1010 on 2019/02/22.
//  Copyright © 2019 yoshino1010. All rights reserved.
//

import Foundation

public protocol ClassNameProtocol {
    static var className: String { get }
    var className: String { get }
}

public extension ClassNameProtocol {
    public static var className: String {
        return String(describing: self)
    }
    
    public var className: String {
        return type(of: self).className
    }
}

extension NSObject: ClassNameProtocol {}
