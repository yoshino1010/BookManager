//
//  Volume.swift
//  BookManagement
//
//  Created by yoshino1010 on 2019/01/04.
//  Copyright © 2019年 yoshino1010. All rights reserved.
//

import Foundation
import RealmSwift

class Volume: Object {
    @objc dynamic var first: Int = 0
    @objc dynamic var end: Int = 0
}
