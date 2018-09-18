//
//  DetailsTodoTableViewCell.swift
//  PlannerApp
//
//  Created by Alkuino Robert John Matias on 18/09/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import UIKit

class DetailsTodoTableViewCell: UITableViewCell {
    
    fileprivate var didSetupContraints = false
    fileprivate let iconImage = UIImageView()
    fileprivate let labelTitle = UILabel()
    fileprivate let nextIcon = UIImageView()
    
    var leftIcon:String = "" {
        didSet {
            iconImage.image = UIImage(named: leftIcon)
        }
    }
    
    var rightIcon:String = "" {
        didSet {
            iconImage.image = UIImage(named: rightIcon)
        }
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        iconImage.backgroundColor = .red
        addSubview(iconImage)
        
        labelTitle.font = UIFont.ofSize(fontSize: 15, withType: .bold)
        labelTitle.text = "Alert date time"
        addSubview(labelTitle)
        
        addSubview(nextIcon)
        
        
        needsUpdateConstraints()
        setNeedsUpdateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        
        if !didSetupContraints {
            
            iconImage.snp.makeConstraints { make in
                make.width.height.equalTo(50)
                make.left.top.bottom.equalTo(self).offset(10)
            }
            
            labelTitle.snp.makeConstraints { make in
                make.left.equalTo(iconImage.snp.right).offset(10)
                make.right.equalTo(nextIcon.snp.left).offset(10)
            }
            
            nextIcon.snp.makeConstraints { make in
                make.width.height.equalTo(20)
                make.centerY.equalTo(iconImage.snp.centerY)
            }
            
            
            
            didSetupContraints = true
        }
        
        super.updateConstraints()
    }

}
