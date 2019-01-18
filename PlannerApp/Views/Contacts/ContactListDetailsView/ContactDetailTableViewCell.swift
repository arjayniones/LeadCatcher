//
//  ContactDetailTableViewCell.swift
//  PlannerApp
//
//  Created by Niones Arjay Orcullo on 26/09/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import UIKit

protocol ContactButtonDelegate {
    func clickToOpenContactHelpView(index:Int)
}

class ContactDetailTableViewCell: UITableViewCell,UITextFieldDelegate {
    
    var delegate:ContactButtonDelegate!
    
    fileprivate var didSetupContraints = false
    let iconImage = UIImageView()
    let labelTitle = UITextField()
    let btnOpenHelp = UIButton()
    let btnImage = UIImage(named: "information")
    
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
            //labelTitle.text = title
            labelTitle.placeholder = title
        }
    }
    
    var textFieldsCallback:((String) -> ())?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(iconImage)
        
        labelTitle.font = UIFont.ofSize(fontSize: 14, withType: .bold)
        labelTitle.returnKeyType = .done
        labelTitle.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        labelTitle.delegate = self
        labelTitle.isEnabled = false
        labelTitle.autocorrectionType = .no;
        
        btnOpenHelp.isHidden = true
        btnOpenHelp.setBackgroundImage(btnImage, for: .normal)
        btnOpenHelp.addTarget(self, action: #selector(openHelpViewAction(_:)), for: .touchUpInside)
        
        contentView.addSubview(labelTitle)
        contentView.addSubview(btnOpenHelp)
        contentView.addSubview(nextIcon)
        
        needsUpdateConstraints()
        setNeedsUpdateConstraints()
    }
    
    @IBAction func openHelpViewAction(_ sender: UIButton) {
        print("test 1234567")
        if self.delegate != nil
        {
            self.delegate?.clickToOpenContactHelpView(index: sender.tag)
        }
        
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
            
            labelTitle.snp.makeConstraints { make in
                make.left.equalTo(iconImage.snp.right).offset(10)
                make.right.equalTo(nextIcon.snp.left).offset(-20)
                make.centerY.equalTo(iconImage.snp.centerY)
            }
            
            btnOpenHelp.snp.makeConstraints { make in
                make.width.height.equalTo(32)
                make.right.equalTo(contentView).inset(10)
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

