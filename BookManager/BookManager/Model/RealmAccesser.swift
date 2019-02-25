//
//  RealmAccesser.swift
//  BookManagement
//
//  Created by yoshino1010 on 2018/12/19.
//  Copyright © 2018年 yoshino1010. All rights reserved.
//

import Foundation
import RealmSwift

class RealmAccesser {
    static let share = RealmAccesser()
    private var realmInstance: Realm? = nil
    private var maxId: Int {
        return try! Realm().objects(Book.self).sorted(byKeyPath: "id").last?.id ?? 0
    }
    private var realm: Realm {
        if let realm = realmInstance {
            return realm
        } else {
            // TODO: do migrate
            realmInstance = try! Realm()
            return realmInstance!
        }
    }

    private init() { }

    func deleteBook(id: Int) -> Bool {
        guard let book = searchBook(id: id) else { return false }
        try! realm.write {
            realm.delete(book)
        }
        return true
    }
    
    func deleteVolume(id: Int, index: Int) -> Bool {
        guard let book = searchBook(id: id) else { return false }
        try! realm.write {
            realm.delete(book.notHaveBook[index])
        }
        return true
    }

    func newBook(book: Book) {
        do {
            try realm.write {
                book.id = maxId + 1
                realm.add(book, update: true)
            }
        } catch {
            // TODO: do error message(登録に失敗しました。)
            return
        }
    }

    func addBook(id: Int, bookVolume: Volume) {
        if let book = searchBook(id: id) {
            try! realm.write {
                book.notHaveBook.append(bookVolume)
            }
        } else {
            // TODO: do error message(追加に失敗しました。)
            return
        }
    }

    func bookFetch() -> Results<Book> {
        return realm.objects(Book.self)
    }

    func bookInfoFetch(id: Int) -> List<Volume> {
        let book = searchBook(id: id)
        if let _book = book {
            return _book.notHaveBook
        } else {
            return List<Volume>()
        }
    }

    func updateBooktatus(update: () -> Book) {
        do {
            try realm.write {
                let book = update()
                realm.add(book, update: true)
            }
        } catch {
            // TODO: do error message(更新に失敗しました。)
            return
        }
    }

    func searchBook(id: Int) -> Book? {
        let book = realm.objects(Book.self).filter("id == %@", id).first
        return book
    }
}
