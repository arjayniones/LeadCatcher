//
//  NotesPopUpController.swift
//  PlannerApp
//
//  Created by Alkuino Robert John Matias on 18/09/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import UIKit

class NotesPopUpController: UIView {
    
    fileprivate let tField = UITextView()
    fileprivate var didSetupConstraints = false

    override init (frame: CGRect) {
        super.init(frame: frame)
        
        tField.textColor = .black
        tField.backgroundColor = UIColor(rgb:0xFFFFCC)
        addSubview(tField)
        
        updateConstraintsIfNeeded()
    }
    
    override func updateConstraints() {
        if !didSetupConstraints {
            tField.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            didSetupConstraints = true
            
        }
        super.updateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
