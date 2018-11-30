//
//  HomeTableViewCell.swift
//  PlannerApp
//
//  Created by Alkuino Robert John Matias on 26/11/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    
    fileprivate var didSetupConstraints: Bool = false
    
    let leftImageView:UIImageView = {
        let imV = UIImageView()
        imV.image = UIImage(named: "dashboard-task-icon2")
        imV.contentMode = .center
        imV.layer.cornerRadius = 30
        imV.layer.masksToBounds = true
        return imV
    }()
    
    let stackView:UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 3
        stackView.backgroundColor = .lightGray
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.setContentCompressionResistancePriority(UILayoutPriority.required, for: .vertical)
        return stackView
    }()
    
    let titleLabel:UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.ofSize(fontSize: 18, withType: .bold)
        return label
    }()
    
    let descriptionLabel:UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.ofSize(fontSize: 15, withType: .bold)
        return label
    }()
    
    let descriptionLabel2:UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.ofSize(fontSize: 15, withType: .bold)
        return label
    }()
    
    let descriptionLabel3:UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.ofSize(fontSize: 15, withType: .bold)
        return label
    }()
    
    let bgView = GradientView()
    
    var leftImageAppearance: String = "" {
        didSet{
            switch leftImageAppearance.lowercased() {
            case "customer birthday":
                self.leftImageView.backgroundColor = CommonColor.redColor
            case "appointment":
                self.leftImageView.backgroundColor = CommonColor.turquoiseColor
            default:
                self.leftImageView.backgroundColor = CommonColor.purpleColor
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        bgView.colors = [CommonColor.lightGrayColor.cgColor,UIColor.white.cgColor]
        contentView.addSubview(bgView)
        selectionStyle = .none
        
        addSubview(leftImageView)
        contentView.addSubview(stackView)
        
        stackView.addArrangedSubview(titleLabel)
        
        stackView.addArrangedSubview(descriptionLabel)
        
        stackView.addArrangedSubview(descriptionLabel2)
        
        stackView.addArrangedSubview(descriptionLabel3)
        
        setNeedsUpdateConstraints()
        updateConstraintsIfNeeded()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func updateConstraints(){
        if !didSetupConstraints {
            bgView.snp.makeConstraints{ make in
                make.center.equalTo(stackView)
                make.size.equalTo(stackView)
            }
            
            leftImageView.snp.makeConstraints{ make in
                make.size.equalTo(CGSize(width: 60, height: 60))
                make.left.equalToSuperview().inset(10)
                make.centerY.equalTo(self.snp.centerY)
            }
            
            stackView.snp.makeConstraints{ make in
                make.right.top.bottom.equalTo(contentView).inset(10)
                make.left.equalTo(leftImageView.snp.right).offset(10)
            }
            
            didSetupConstraints = true
        }
        super.updateConstraints()
    }
}
