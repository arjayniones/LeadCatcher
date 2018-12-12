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
    let iconImage = UIImageView()
    let labelTitle = UITextField()
    
    let nextIcon:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "next-icon")
        return imageView
    }()
    
    let addIcon:UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        imageView.image = UIImage(named: "add-icon")
        return imageView
    }()
    
    let stackView = UIStackView()
    
    var leftIcon:String = "" {
        didSet {
            iconImage.image = UIImage(named: leftIcon)
        }
    }
    
    let iconImage2 = UIImageView(image:UIImage(named: "check-iconx2"))
    
    var title:String = "" {
        didSet {
            labelTitle.placeholder = title
            //labelTitle.text = title
        }
    }
    
    var subjectCallback:((String) -> ())?
    var subjectCallback2:((String,Int) -> ())?
    var checkListCallback:(() -> ())?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = UITableViewCell.SelectionStyle.default
        labelTitle.font = UIFont.ofSize(fontSize: 14, withType: .bold)
        labelTitle.returnKeyType = .done
        labelTitle.delegate = self
        labelTitle.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        labelTitle.isEnabled = false
        labelTitle.autocorrectionType = .no;
        iconImage2.isHidden = true
       
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.addArrangedSubview(iconImage2)
        stackView.addArrangedSubview(iconImage)
        stackView.addArrangedSubview(labelTitle)
        contentView.addSubview(stackView)
        
        addIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addCheckList)))
        contentView.addSubview(addIcon)
        
        contentView.addSubview(nextIcon)
        
//        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeKeyboard)))
        
        needsUpdateConstraints()
        setNeedsUpdateConstraints()
    }
    @objc func closeKeyboard() {
        self.endEditing(true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func addCheckList() {
        if let callback = checkListCallback {
            callback()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print(textField);
        if textField.tag > 0
        {
            if let callback = subjectCallback2{
                if let text = textField.text
                {
                    callback(text,self.tag);
                }
            }
        }
        
        if let callback = subjectCallback {
            if let text = textField.text {
                callback(text)
            }
        }
        endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if let callback = subjectCallback2 {
            if let text = textField.text {
                callback(text,self.tag);
            }
        }
        
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
            }
            
            iconImage2.snp.makeConstraints { make in
                make.size.equalTo(CGSize(width: 20, height: 27))
            }
            
            stackView.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview().inset(10)
                make.left.equalToSuperview().inset(20)
            }
            
            nextIcon.snp.makeConstraints { make in
                make.size.equalTo(CGSize(width: 15, height: 15))
                make.right.equalTo(contentView).inset(10)
                make.centerY.equalTo(iconImage.snp.centerY)
                make.left.equalTo(stackView.snp.right).offset(10)
            }
            
            addIcon.snp.makeConstraints { make in
                make.center.equalTo(nextIcon)
                make.size.equalTo(CGSize(width: 30, height: 30))
            }
            
            didSetupContraints = true
        }
        
        super.updateConstraints()
    }

}
