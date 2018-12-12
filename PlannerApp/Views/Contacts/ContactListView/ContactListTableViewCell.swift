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
        img.backgroundColor = .lightGray
        img.layer.cornerRadius = 25
        img.layer.borderWidth = 0.2
        img.clipsToBounds = true
        
        return img
    }()
    let customerName: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.3254901961, green: 0.3607843137, blue: 0.4078431373, alpha: 1)
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.font = UIFont.boldSystemFont(ofSize: 20)
        
        return label
    }()
    var status = UILabel()
    
    let phoneNum: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.3254901961, green: 0.3607843137, blue: 0.4078431373, alpha: 1)
        label.font = UIFont.boldSystemFont(ofSize: 12)
        
        return label
    }()
    let email: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.3254901961, green: 0.3607843137, blue: 0.4078431373, alpha: 1)
        label.font = UIFont.boldSystemFont(ofSize: 10)
        
        return label
    }()
    
    
    let rating : UILabel = {
        let label = UILabel()

        //label.font = UIFont.boldSystemFont(ofSize: 15)
        //label.textColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)

        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = CommonColor.yellowColor
        return label
    }()
    var lastCom : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = .lightGray
        return label
    }()
    var toFollow : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        
        return label
    }()
    
    var cellView:  UIView = {
        let view = UIView()

        view.backgroundColor = .white
//        view.backgroundColor = CommonColor.darkerWhiteColor
//        view.layer.cornerRadius = 10
//        view.layer.borderWidth = 0.2
//        view.layer.shadowRadius = 5
//        view.layer.shadowOpacity = 0.5
      
        return view
    }()
     var didSetupConstraints = false
    
    var mainStackView = UIStackView()
    
    var stackView1 = UIStackView()
    var stackView2 = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(cellView)
        cellView.backgroundColor = #colorLiteral(red: 0.9450980392, green: 0.9490196078, blue: 0.9647058824, alpha: 1)
        self.backgroundColor = .clear
        imgUser.image = UIImage(named: "user-circle-big-icon")

        cellView.addSubview(imgUser)
        
        stackView1.axis = .vertical
        stackView1.spacing = 5

        cellView.addSubview(stackView1)
        
        stackView1.addArrangedSubview(customerName)
        stackView1.addArrangedSubview(status)
        stackView1.addArrangedSubview(phoneNum)
        stackView1.addArrangedSubview(email)
        
        
        
        stackView2.axis = .vertical
        stackView2.spacing = 3
        cellView.addSubview(stackView2)
        

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
            
            make.edges.equalTo(contentView).inset(UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
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
            make.left.equalTo(imgUser.snp.right).offset(20)
            make.width.equalTo(cellView.snp.width).multipliedBy(0.4);
            //make.right.equalTo(stackView2).offset(5)
        }
        
        stackView2.snp.makeConstraints { make in
          
            make.top.equalTo(cellView).inset(20)
            make.bottom.equalTo(cellView).inset(5)
            make.width.equalTo(cellView.snp.width).multipliedBy(0.35); //make.left.equalTo(stackView1.snp.right).offset(20)
            make.right.equalTo(cellView).inset(0)
        }


        }
        super.updateConstraints()
    }

}




extension UIFont {
    func withTraits(traits:UIFontDescriptor.SymbolicTraits) -> UIFont {
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
