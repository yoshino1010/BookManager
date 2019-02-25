//
//  RegistBooksViewController.swift
//  BookManagement
//
//  Created by yoshino1010 on 2018/12/30.
//  Copyright © 2018年 yoshino1010. All rights reserved.
//

import UIKit
import MaterialComponents

class RegistBooksPopUpViewController: UIViewController {
    fileprivate var volumes: [Volume] = []
    fileprivate var realm = RealmAccesser.share
    fileprivate var state: State = .initial

    var tableView: UITableView? {
        return (view as? RegistBookPopUpView)?.tableView
    }

    fileprivate enum State {
        case initial
        case update
    }

    override func loadView() {
        super.loadView()
        self.view = RegistBookPopUpView()
        view.setNeedsUpdateConstraints()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let tableView = tableView else { return }
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(RegistBookViewVolumeCell.self, forCellReuseIdentifier: RegistBookViewVolumeCell.className)

        guard let view = view as? RegistBookPopUpView else { return }
        view.accept.addTarget(self, action: #selector(acceptTap), for: .touchUpInside)
        view.cancel.addTarget(self, action: #selector(cancelTap), for: .touchUpInside)

        view.add.addTarget(self, action: #selector(addTap), for: .touchUpInside)

        setupInputAccessory(textField: view.bookTitle)
        reload()
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
}

// MARK: - Action
extension RegistBooksPopUpViewController {
    @objc func doneButtonTaped() {
        dismissKeyBoard()
    }

    fileprivate func dismissKeyBoard() {
        view.endEditing(true)
    }

    @objc func cancelTap() {
        dismissKeyBoard()
        dismiss(animated: true, completion: nil)
    }

    @objc func addTap() {
        volumes.append(Volume())
        state = .update
        reload(row: volumes.count - 1)
    }

    @objc func acceptTap() {
        print("accept")
        if !isValid() {
            return
        }
        let book = Book()
        for volume in volumes {
            book.notHaveBook.append(volume)
        }
        let view = self.view as! RegistBookPopUpView
        if let title = view.bookTitle.text {
            book.title = title
        }
        realm.newBook(book: book)
        dismissKeyBoard()
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Logic
extension RegistBooksPopUpViewController {
    fileprivate func isValid() -> Bool {
        let view = self.view as! RegistBookPopUpView
        guard let title = view.bookTitle.text else { return false }
        if title.isEmpty {
            view.warningNote.text = "タイトルを入力してください"
            view.warningNote.isHidden = false
            return false
        }
        return true
    }

    fileprivate func reload(row: Int = 0) {
        let index = IndexPath(row: row, section: 0)
        let view = self.view as! RegistBookPopUpView
        switch state {
        case .initial:
            view.tableView.reloadData()
        case .update:
            view.tableView.beginUpdates()
            view.tableView.insertRows(at: [index], with: .automatic)
            view.tableView.endUpdates()
        }
    }
}

// MARK: - Table view data source
extension RegistBooksPopUpViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return volumes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RegistBookViewVolumeCell.className, for: indexPath) as! RegistBookViewVolumeCell
        cell.setUp(first: 0, end: 0)
        setupInputAccessory(textField: cell.first)
        setupInputAccessory(textField: cell.end)
        cell.delegate = self
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            volumes.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
}

// MARK: - Table view delegate
extension RegistBooksPopUpViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteButton: UITableViewRowAction = UITableViewRowAction(style: .default, title: "削除") { (action, index) -> Void in
            self.volumes.remove(at: index.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [index], with: .automatic)
            tableView.endUpdates()
        }
        deleteButton.backgroundColor = .red
        return [deleteButton]
    }
}

// MARK: - RegistBookViewVolumeCell textfield delegate
extension RegistBooksPopUpViewController: RegistBookDelegate {
    func textFieldDidEndEditing(cell: RegistBookViewVolumeCell) {
        guard let tableView = tableView,
              let indexPath = tableView.indexPath(for: cell) else {
                return
        }
        volumes[indexPath.row].first = cell.first.textNonNull.toInt
        volumes[indexPath.row].end = cell.end.textNonNull.toInt
    }
}
