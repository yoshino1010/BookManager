//
//  MainBooksListController.swift
//  BookManagement
//
//  Created by yoshino1010 on 2019/01/02.
//  Copyright © 2019年 yoshino1010. All rights reserved.
//

import UIKit
import SnapKit
import MaterialComponents.MaterialButtons
import MaterialComponents.MaterialButtons_ButtonThemer

class MainBookListView: UIView {
    let tableView: UITableView
    let fButton: MDCFloatingButton
    var didUpdateConstraints = false

    override init(frame: CGRect) {
        tableView = UITableView(frame: .zero, style: .plain)
        fButton = MDCFloatingButton()
        super.init(frame: .zero)

        backgroundColor = .blue
        fButton.translatesAutoresizingMaskIntoConstraints = false
        let buttonScheme = MDCButtonScheme()
        MDCFloatingActionButtonThemer.applyScheme(buttonScheme, to: fButton)
        
        tableView.tableFooterView = UIView()

        addSubview(tableView)
        addSubview(fButton)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func updateConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
        }
        fButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 66, height: 66))
        }
        super.updateConstraints()
    }
}
