//
//  BooktatusViewController.swift
//  BookManagement
//
//  Created by yoshino1010 on 2019/01/05.
//  Copyright © 2019年 yoshino1010. All rights reserved.
//

import UIKit
import RealmSwift

class BookStatusViewController: UIViewController {
    fileprivate let realm = RealmAccesser.share
    fileprivate var book: Book?
    fileprivate var changeStatusHistory: [changeStatus] = []
    fileprivate var isChangeStatus = false
    fileprivate var notificationToken: NotificationToken? = nil
    var id: Int = -1

    var tableView: UITableView? {
        return (view as? BookStatusView)?.tableView
    }

    fileprivate struct changeStatus {
        var index = 0
        var first = 0
        var end = 0
    }

    override func loadView() {
        super.loadView()
        view = BookStatusView()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if isChangeStatus {
            guard let book = book else { return }
            realm.updateBooktatus(update: {
                for history in changeStatusHistory {
                    book.notHaveBook[history.index].first = history.first
                    book.notHaveBook[history.index].end = history.end
                }
                return book
            })
        }
    }

    override func viewDidLoad() {
        guard id != -1 else { return }
        book = realm.searchBook(id: id)
        notificationToken = book?.notHaveBook.observe({ [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                tableView.beginUpdates()
                tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                tableView.endUpdates()
            case .error(let error):
                ErrorAlert(message: "データの取得に失敗しました").show()
                fatalError("\(error)")
            }
        })
        guard let tableView = tableView else { return }
        tableView.register(RegistBookViewVolumeCell.self, forCellReuseIdentifier: RegistBookViewVolumeCell.className)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension

        guard let view = view as? BookStatusView else { return }
        view.title.text = "持っていない巻"

        edgesForExtendedLayout = []

        navigationItem.title = book?.title
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.isTranslucent = false
        view.updateConstraintsIfNeeded()
    }

    func setupInputAccessory(textField: UITextField) {
        let toolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.sizeToFit()

        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTaped))
        toolbar.items = [space, doneButton]
        textField.inputAccessoryView = toolbar
    }
    
    deinit {
        notificationToken?.invalidate()
    }
}

// MARK: - Table view data source
extension BookStatusViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return book?.notHaveBook.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RegistBookViewVolumeCell.className, for: indexPath) as! RegistBookViewVolumeCell
        guard let volume = book?.notHaveBook[indexPath.row] else {
            return UITableViewCell()
        }
        
        cell.setUp(first: volume.first, end: volume.end)
        cell.delegate = self
        setupInputAccessory(textField: cell.first)
        setupInputAccessory(textField: cell.end)
        return cell
    }
}

// MARK: - Table view delegate
extension BookStatusViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteButton: UITableViewRowAction = UITableViewRowAction(style: .default, title: "削除") {(action, index) -> Void in
            if self.realm.deleteVolume(id: self.book!.id, index: index.row) {
                for i in 0..<self.changeStatusHistory.count {
                    if self.changeStatusHistory[i].index == index.row {
                        self.changeStatusHistory.remove(at: i)
                        break
                    }
                }
            } else {
                ErrorAlert(message: "データの削除に失敗しました").show()
            }
        }
        deleteButton.backgroundColor = .red
        return [deleteButton]
    }
}

// MARK: - RegistBookView textfield delegate
extension BookStatusViewController: RegistBookDelegate {
    func textFieldDidEndEditing(cell: RegistBookViewVolumeCell) {
        guard let tableView = tableView,
              let indexPath = tableView.indexPath(for: cell) else {
                return
        }
        
        var changeIndex = -1
        for i in 0..<changeStatusHistory.count {
            if changeStatusHistory[i].index == indexPath.row {
                changeIndex = i
                break
            }
        }
        if changeIndex != -1 {
            changeStatusHistory[changeIndex].first = cell.first.textNonNull.toInt
            changeStatusHistory[changeIndex].end = cell.end.textNonNull.toInt
            return
        }
        
        var history = changeStatus()
        history.index = indexPath.row
        history.first = cell.first.textNonNull.toInt
        history.end = cell.end.textNonNull.toInt
        changeStatusHistory.append(history)
        isChangeStatus = true
    }
}

// MARK: - Action
extension BookStatusViewController {
    @objc func doneButtonTaped() {
        dismissKeyBoard()
    }

    private func dismissKeyBoard() {
        view.endEditing(true)
    }
}
