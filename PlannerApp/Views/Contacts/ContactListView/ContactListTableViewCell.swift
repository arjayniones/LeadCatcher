//
//  ContactListTableViewCell.swift
//  PlannerApp
//
//  Created by Niones Arjay Orcullo on 22/10/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import UIKit

class ContactListTableViewCell: UITableViewCell {

    let imgUser: UIImageView = {
        let img = UIImageView()
        img.backgroundColor = .red
        img.layer.cornerRadius = 25
        img.layer.borderWidth = 1
        img.layer.shadowRadius = 10
        img.layer.shadowOpacity = 0.5
        
        return img
    }()
    let customerName: UILabel = {
        let label = UILabel()
       
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.font = UIFont.boldSystemFont(ofSize: 20)
        
        return label
    }()
    var status = UILabel()
    
    let phoneNum: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        
        return label
    }()
    let email: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 10)
        
        return label
    }()
    
    
    let rating : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        //label.textAlignment = .center
        
        return label
    }()
    var lastCom : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 10)
        
        return label
    }()
    var toFollow = UILabel()
    var cellView:  UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.layer.shadowRadius = 10
        view.layer.shadowOpacity = 0.5
      
        return view
    }()
     var didSetupConstraints = false
    
    var mainStackView = UIStackView()
    
    var stackView1 = UIStackView()
    var stackView2 = UIStackView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(cellView)
       
        
        imgUser.backgroundColor = .red
//        mainStackView.axis = .horizontal
//        mainStackView.spacing = 5
//        mainStackView.distribution = .equalSpacing
//        mainStackView.alignment = .fill
   
        cellView.addSubview(imgUser)
//        mainStackView.addArrangedSubview(imgUser)
        
        stackView1.axis = .vertical
        stackView1.spacing = 5
//      mainStackView.addArrangedSubview(stackView1)
        cellView.addSubview(stackView1)
        
        stackView1.addArrangedSubview(customerName)
        stackView1.addArrangedSubview(status)
        stackView1.addArrangedSubview(phoneNum)
        stackView1.addArrangedSubview(email)
        
        
        
        stackView2.axis = .vertical
        stackView2.spacing = 5
        cellView.addSubview(stackView2)
        
//        mainStackView.addArrangedSubview(stackView2)
        stackView2.addArrangedSubview(rating)
        stackView2.addArrangedSubview(lastCom)
        stackView2.addArrangedSubview(toFollow)
     
       
        
        setNeedsUpdateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func updateConstraints(){
      if !didSetupConstraints {
        cellView.snp.makeConstraints { make in
            
            make.edges.equalTo(contentView).inset(UIEdgeInsetsMake(5, 5, 5, 5))
        }
        
//        mainStackView.snp.makeConstraints { make in
//
//            make.edges.equalTo(cellView).inset(UIEdgeInsetsMake(5, 5, 5, 5))
//            make.size.equalTo(CGSize(width: cellView.width, height: 150))
//        }
        
        
        imgUser.snp.makeConstraints { make in

            make.left.equalTo(cellView).inset(20)
            //make.top.bottom.equalTo(cellView).inset(30)
            make.size.equalTo(CGSize(width: 50, height: 50))
            make.centerY.equalTo(cellView.snp.centerY)

        }
        
        stackView1.snp.makeConstraints { make in

            make.top.bottom.equalTo(cellView).inset(5)
            make.left.equalTo(imgUser.snp.right).offset(10)
            make.right.equalTo(stackView2).offset(5)
        }
        
        stackView2.snp.makeConstraints { make in
          
            make.top.bottom.equalTo(cellView).inset(5)
            //make.left.equalTo(stackView1.snp.right).offset(5)
            make.right.equalTo(cellView).inset(5)
        }


        }
        super.updateConstraints()
    }

}




extension UIFont {
    func withTraits(traits:UIFontDescriptorSymbolicTraits) -> UIFont {
        let descriptor = fontDescriptor.withSymbolicTraits(traits)
        return UIFont(descriptor: descriptor!, size: 0) //size 0 means keep the size as it is
    }
    
    func bold() -> UIFont {
        return withTraits(traits: .traitBold)
    }
    
    func italic() -> UIFont {
        return withTraits(traits: .traitItalic)
    }
}
