//
//  SummaryCollectionViewCell.swift
//  PlannerApp
//
//  Created by Niones Arjay Orcullo on 02/10/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import UIKit

class SummaryCollectionViewCell: UICollectionViewCell {
    
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = UIColor.white
        label.text = "label name"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    let numberLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 30)
        label.text = "100"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
 
    
    let outerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.red
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    

    let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis  = UILayoutConstraintAxis.vertical
        sv.alignment = UIStackViewAlignment.center
        sv.distribution = UIStackViewDistribution.fillProportionally
        sv.translatesAutoresizingMaskIntoConstraints = false;
        return sv
    }()

    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addViews()
        
        updateConstraintsIfNeeded()
    }
    
    
    override func updateConstraints() {
        
        outerView.snp.makeConstraints { make in
            make.edges.equalTo(self).inset(3)
            
        }
        
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(outerView).offset(1)
            
        }
        
        super.updateConstraints()
    }
    
    func addViews(){
       
        backgroundColor = .clear
        addSubview(textLabel)
        addSubview(numberLabel)
        addSubview(outerView)
      
        stackView.addArrangedSubview(textLabel)
        stackView.addArrangedSubview(numberLabel)
        outerView.addSubview(stackView)
        outerView.layer.cornerRadius = 10
        outerView.layer.borderWidth = 1
        outerView.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 5.0)
        self.layer.shadowRadius = 8.0
        self.layer.shadowOpacity = 0.5
        self.layer.masksToBounds = false
        
       
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
