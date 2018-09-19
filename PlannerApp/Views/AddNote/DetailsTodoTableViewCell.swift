//
//  DetailsTodoTableViewCell.swift
//  PlannerApp
//
//  Created by Alkuino Robert John Matias on 18/09/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import UIKit

class DetailsTodoTableViewCell: UITableViewCell,UITextFieldDelegate {
    
    fileprivate var didSetupContraints = false
    fileprivate let iconImage = UIImageView()
    let labelTitle = UITextField()
    
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
    
    var subjectCallback:((String) -> ())?

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(iconImage)
        
        labelTitle.font = UIFont.ofSize(fontSize: 14, withType: .bold)
        labelTitle.returnKeyType = .done
        labelTitle.textColor = .lightGray
        labelTitle.isEnabled = false
        contentView.addSubview(labelTitle)
        
        contentView.addSubview(nextIcon)
        
        needsUpdateConstraints()
        setNeedsUpdateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let callback = subjectCallback {
            if let text = textField.text {
                callback(text)
            }
        }
        endEditing(true)
        
        return true
    }
    
    
    override func updateConstraints() {
        
        if !didSetupContraints {
            
            iconImage.snp.makeConstraints { make in
                make.width.height.equalTo(32)
                make.left.top.bottom.equalTo(contentView).inset(10)
            }
            
            labelTitle.snp.makeConstraints { make in
                make.left.equalTo(iconImage.snp.right).offset(10)
                make.right.equalTo(nextIcon.snp.left).offset(10)
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
