//
//  DashHeaderView.swift
//  PlannerApp
//
//  Created by Alkuino Robert John Matias on 23/11/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import UIKit

class DashHeaderView: UIView {
    
    let sideIcon: UIImageView = UIImageView()
    let labelCount = UILabel()
    let labelBelow = UILabel()
    var didSetupConstraints:Bool = false

    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        
        self.sideIcon.backgroundColor = .white
        self.addSubview(sideIcon)
        
        labelCount.font = UIFont.ofSize(fontSize: 40, withType: .bold)
        labelCount.text = "7"
        labelCount.textAlignment = .center
        self.addSubview(labelCount)
        
        labelBelow.font = UIFont.ofSize(fontSize: 20, withType: .regular)
        labelBelow.layer.cornerRadius = 10
        labelBelow.layer.masksToBounds = true
        labelBelow.text = "Birthday"
        labelBelow.backgroundColor = .darkGray
        labelBelow.textAlignment = .center
        labelBelow.textColor = .white
        self.addSubview(labelBelow)
        
        setNeedsUpdateConstraints()
        updateConstraintsIfNeeded()
    }
    
    override func updateConstraints() {
        if !didSetupConstraints {
            
            sideIcon.snp.makeConstraints{ make in
                make.size.equalTo(self.snp.height).multipliedBy(0.25)
                make.left.top.equalTo(self).inset(5)
            }
            
            labelCount.snp.makeConstraints{ make in
                make.top.equalTo(sideIcon.snp.bottom).offset(5)
                make.left.right.equalTo(self).inset(5)
            }
            
            labelBelow.snp.makeConstraints{ make in
                make.top.equalTo(labelCount.snp.bottom).offset(10)
                make.height.equalTo(self.snp.height).multipliedBy(0.25)
                make.left.right.bottom.equalTo(self).inset(0)
            }
            
            didSetupConstraints = true
        }
        
        super.updateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
