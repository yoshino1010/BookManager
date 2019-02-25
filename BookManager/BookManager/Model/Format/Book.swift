//
//  Books.swift
//  BookManagement
//
//  Created by yoshino1010 on 2018/12/19.
//  Copyright © 2018年 yoshino1010. All rights reserved.
//

import Foundation
import RealmSwift

class Book: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var title: String = ""
    @objc dynamic var isAll: Bool = true
    
    var notHaveBook: List<Volume> = List<Volume>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
