//
//  BookStatusView.swift
//  BookManagement
//
//  Created by yoshino1010 on 2019/02/22.
//  Copyright © 2019 yoshino1010. All rights reserved.
//

import UIKit
import SnapKit

class BookStatusView: UIView {
    let title: UILabel
    let tableView: UITableView
    var didUpdateConstraints = false

    override init(frame: CGRect) {
        title = UILabel(frame: .zero)
        tableView = UITableView()
        super.init(frame: .zero)

        backgroundColor = .white
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = false
        
        addSubview(title)
        addSubview(tableView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func updateConstraints() {
        if !didUpdateConstraints {
            title.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.left.equalToSuperview().offset(15)
                make.height.equalTo(50)
            }
            tableView.snp.makeConstraints { make in
                make.top.equalTo(title.snp.bottom)
                make.bottom.greaterThanOrEqualToSuperview()
                make.left.right.equalToSuperview()
            }
            didUpdateConstraints = true
        }
        super.updateConstraints()
    }
}
