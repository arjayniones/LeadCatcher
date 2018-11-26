//
//  LogsTableViewCell.swift
//  PlannerApp
//
//  Created by Niones Arjay Orcullo on 25/10/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import UIKit

class LogsTableViewCell: UITableViewCell, UITextFieldDelegate {



fileprivate var didSetupContraints = false
fileprivate let iconImage = UIImageView()
let labelTitle = UILabel()
let labelDesc = UILabel()
let labelDate = UILabel()
let cellStackView = UIStackView()

let nextIcon:UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "next-icon")
    return imageView
}()

var leftIcon:String = "" {
    didSet {
        iconImage.image = UIImage(named: leftIcon)
    }
}

var title:String = "" {
    didSet {
        labelTitle.text = title
    }
}

var desc:String = "" {
    didSet {
        labelDesc.text = desc
    }
}

var date:String = "" {
    didSet {
        labelDate.text = date
    }
    
}

var textFieldsCallback:((String) -> ())?

//override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
//    super.init(style: style, reuseIdentifier: reuseIdentifier)
//
//    contentView.addSubview(iconImage)
//
//    labelTitle.font = UIFont.ofSize(fontSize: 18, withType: .bold)
//    labelTitle.textColor = .black
//    labelTitle.textAlignment = .left
//
//    labelDesc.font = UIFont.ofSize(fontSize: 12, withType: .bold)
//    labelDesc.textColor = .gray
//    labelDesc.textAlignment = .left
//
//    labelDate.font = UIFont.ofSize(fontSize: 12, withType: .bold)
//    labelDate.textColor = .lightGray
//    labelDate.textAlignment = .left
//
//    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(iconImage)
        
        labelTitle.font = UIFont.ofSize(fontSize: 14, withType: .bold)
        //labelTitle.returnKeyType = .done
        labelTitle.textColor = .lightGray
        //labelTitle.delegate = self
        labelTitle.isEnabled = false
        contentView.addSubview(labelTitle)
        
        contentView.addSubview(nextIcon)
        
        needsUpdateConstraints()
        setNeedsUpdateConstraints()
    

    
    //        contentView.addSubview(labelTitle)
    //        contentView.addSubview(labelDesc)
    contentView.addSubview(nextIcon)
    
    cellStackView.addArrangedSubview(labelTitle)
    cellStackView.addArrangedSubview(labelDesc)
    cellStackView.addArrangedSubview(labelDate)
    cellStackView.alignment = .leading
    cellStackView.axis = .vertical
    
    contentView.addSubview(cellStackView)
    
    
    needsUpdateConstraints()
    setNeedsUpdateConstraints()
}


required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
}

func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if let callback = textFieldsCallback {
        if let text = textField.text {
            callback(text)
        }
    }
    endEditing(true)
    
    return true
}

func textFieldDidEndEditing(_ textField: UITextField) {
    if let callback = textFieldsCallback {
        if let text = textField.text {
            callback(text)
        }
    }
    endEditing(true)
}


override func updateConstraints() {
    
    if !didSetupContraints {
        
        iconImage.snp.makeConstraints { make in
            make.width.height.equalTo(32)
            make.left.top.bottom.equalTo(contentView).inset(10)
        }
        
        //            labelTitle.snp.makeConstraints { make in
        //                make.left.equalTo(iconImage.snp.right).offset(10)
        //                make.right.equalTo(nextIcon.snp.left).offset(10)
        //                make.centerY.equalTo(iconImage.snp.centerY)
        //            }
        //
        //            labelDesc.snp.makeConstraints { make in
        //                make.left.equalTo(iconImage.snp.right).offset(10)
        //                make.right.equalTo(nextIcon.snp.left).offset(10)
        //                make.top.equalTo(labelTitle.snp.bottom).offset(5)
        //                make.centerY.equalTo(iconImage.snp.centerY)
        //            }
        //
        
        cellStackView.snp.makeConstraints { make in
            make.left.equalTo(iconImage.snp.right).offset(10)
            make.right.equalTo(nextIcon.snp.left).offset(10)
            make.top.equalTo(contentView)
            make.bottom.equalTo(contentView)
            make.centerY.equalTo(iconImage.snp.centerY)
            
        }
        nextIcon.snp.makeConstraints { make in
            make.width.height.equalTo(15)
            make.right.equalTo(contentView).inset(10)
            make.centerY.equalTo(iconImage.snp.centerY)
        }
        
        didSetupContraints = true
    }
    
    super.updateConstraints()
}

}


