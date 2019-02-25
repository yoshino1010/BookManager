//
//  RegistBooksPopUpView.swift
//  BookManagement
//
//  Created by yoshino1010 on 2019/01/02.
//  Copyright © 2019年 yoshino1010. All rights reserved.
//

import UIKit
import SnapKit
import MaterialComponents.MaterialButtons
import MaterialComponents.MaterialButtons_ButtonThemer

class RegistBookPopUpView: UIView {
    let bookTitle: UITextField
    let tableView: UITableView
    let accept: MDCFlatButton
    let cancel: MDCFlatButton
    let haveVolume: UILabel
    let add: MDCButton
    let warningNote: UILabel
    var didUpdateConstraints = false

    override init(frame: CGRect) {
        tableView = UITableView(frame: .zero, style: .plain)
        bookTitle = UITextField(frame: .zero)
        accept = MDCFlatButton()
        cancel = MDCFlatButton()
        haveVolume = UILabel(frame: .zero)
        add = MDCButton()
        warningNote = UILabel(frame: .zero)
        super.init(frame: .zero)

        accept.setTitle("OK", for: .normal)
        cancel.setTitle("CANCEL", for: .normal)

        MDCOutlinedButtonThemer.applyScheme(MDCButtonScheme(), to: add)

        bookTitle.placeholder = "タイトル"
        bookTitle.font = UIFont.systemFont(ofSize: 20)
        

        tableView.allowsSelection = false
        tableView.tableFooterView = UIView()

        warningNote.textColor = .red
        warningNote.font = UIFont.systemFont(ofSize: 14)
        warningNote.isHidden = true

        add.setTitle("追加", for: .normal)
        add.setTitleColor(.black, for: .normal)

        haveVolume.text = "持っていない巻"

        addSubview(haveVolume)
        addSubview(add)
        addSubview(tableView)
        addSubview(accept)
        addSubview(cancel)
        addSubview(bookTitle)
        addSubview(warningNote)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bookTitle.addBorderBottom(height: 1, color: .gray)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func updateConstraints() {
        if !didUpdateConstraints {
            bookTitle.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(20)
                make.left.equalToSuperview().offset(15)
                make.right.equalToSuperview().inset(15)
                make.width.greaterThanOrEqualTo(1)
            }
            warningNote.snp.makeConstraints { make in
                make.top.equalTo(bookTitle.snp.bottom)
                make.left.equalTo(bookTitle.snp.left)
            }
            haveVolume.snp.makeConstraints { make in
                make.width.greaterThanOrEqualTo(1)
                make.left.equalToSuperview().offset(15)
                make.centerY.equalTo(add.snp.centerY)
            }
            add.snp.makeConstraints { make in
                make.right.equalToSuperview().inset(15)
                make.top.equalTo(warningNote.snp.bottom).offset(5)
            }
            accept.snp.makeConstraints { make in
                make.width.equalToSuperview().multipliedBy(0.5)
                make.height.equalToSuperview().multipliedBy(0.08)
                make.bottom.equalToSuperview()
                make.right.equalToSuperview()
            }
            cancel.snp.makeConstraints { make in
                make.width.equalToSuperview().multipliedBy(0.5)
                make.height.equalToSuperview().multipliedBy(0.08)
                make.bottom.equalToSuperview()
                make.left.equalToSuperview()
            }
            tableView.snp.makeConstraints { make in
                make.width.equalToSuperview()
                make.height.greaterThanOrEqualTo(1)
                //make.bottom.equalTo(accept.snp.top)
                make.bottom.equalToSuperview()
                make.top.equalTo(haveVolume.snp.bottom).offset(15)
            }
            didUpdateConstraints = true
        }
        super.updateConstraints()
    }
}
