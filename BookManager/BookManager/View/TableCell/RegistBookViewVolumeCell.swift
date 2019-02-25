//
//  RegistBookViewVolumeCell.swift
//  BookManagement
//
//  Created by yoshino1010 on 2018/12/29.
//  Copyright © 2018年 yoshino1010. All rights reserved.
//

import UIKit
import SnapKit

protocol RegistBookDelegate {
    func textFieldDidEndEditing(cell: RegistBookViewVolumeCell)
}

class RegistBookViewVolumeCell: UITableViewCell {
    let first: UITextField
    let end: UITextField
    let fUnit: UILabel
    let eUnit: UILabel

    var delegate: RegistBookDelegate?
    var didUpdateConstraints = false

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        first = UITextField(frame: .zero)
        end = UITextField(frame: .zero)
        fUnit = UILabel(frame: .zero)
        eUnit = UILabel(frame: .zero)
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        first.keyboardType = .numberPad
        end.keyboardType = .numberPad

        first.delegate = self
        end.delegate = self

        contentView.addSubview(first)
        contentView.addSubview(end)
        contentView.addSubview(fUnit)
        contentView.addSubview(eUnit)
    }

    func setUp(first: Int, end: Int) {
        fUnit.text = "巻 〜 "
        eUnit.text = "巻"
        self.first.text = "\(first)"
        self.end.text = "\(end)"
        updateConstraintsIfNeeded()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func updateConstraints() {
        if !didUpdateConstraints {
            fUnit.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
            first.snp.makeConstraints { make in
                make.right.equalTo(fUnit.snp.left).inset(2)
                make.centerY.equalToSuperview()
            }
            end.snp.makeConstraints { make in
                make.left.equalTo(fUnit.snp.right).offset(2)
                make.centerY.equalToSuperview()
            }
            eUnit.snp.makeConstraints { make in
                make.left.equalTo(end.snp.right)
                make.centerY.equalToSuperview()
            }
            didUpdateConstraints = true
        }
        super.updateConstraints()
    }
}

extension RegistBookViewVolumeCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.textFieldDidEndEditing(cell: self)
    }
}
