//
//  MainBooksListViewControllerTableViewController.swift
//  BookManagement
//
//  Created by yoshino1010 on 2018/12/19.
//  Copyright © 2018年 yoshino1010. All rights reserved.
//

import UIKit
import RealmSwift
import MaterialComponents.MaterialButtons

class MainBooksListViewController: UIViewController {
    private var notificationToken: NotificationToken? = nil
    private var flag = false
    fileprivate var tableView: UITableView? {
        return (view as? MainBookListView)?.tableView
    }
    
    fileprivate var button: MDCFloatingButton? {
        return (view as? MainBookListView)?.fButton
    }
    
    fileprivate let realm = RealmAccesser.share
    fileprivate var book: Results<Book>!
    
    var animation: BooksListToRegistBooksAnimation = BooksListToRegistBooksAnimation(duration: 1)
    
    override func loadView() {
        super.loadView()
        view = MainBookListView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let tableView = tableView else { return }
        if let indexPathForSelectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPathForSelectedRow, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "登録本一覧"
        
        book = realm.bookFetch()
        notificationToken = book.observe({ [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else {return}
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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.className)
        tableView.dataSource = self
        tableView.delegate = self
        
        guard let button = button else { return }
        button.addTarget(self, action: #selector(buttonTap), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)])
    }
    
    deinit {
        notificationToken?.invalidate()
    }
}

// MARK: - Table view data source
extension MainBooksListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return book.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.className, for: indexPath)
        cell.textLabel?.text = book[indexPath.row].title
        return cell
    }
}

// MARK: - Table view delegate
extension MainBooksListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteButton: UITableViewRowAction = UITableViewRowAction(style: .default, title: "削除") {(action, index) -> Void in
            if !self.realm.deleteBook(id: self.book[index.row].id) {
                ErrorAlert(message: "データの削除に失敗しました").show()
            }
        }
        deleteButton.backgroundColor = .red
        return [deleteButton]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = BookStatusViewController()
        vc.id = book[indexPath.row].id
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - Action
extension MainBooksListViewController {
    @objc func buttonTap() {
        let vc = RegistBooksPopUpViewController()
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = self
        present(vc, animated: true, completion: nil)
    }
}
