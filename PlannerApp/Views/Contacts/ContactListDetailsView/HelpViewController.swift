//
//  HelpViewController.swift
//  PlannerApp
//
//  Created by Lim Ai Zhi on 16/01/2019.
//  Copyright © 2019 SICMSB. All rights reserved.
//

import UIKit

class HelpViewController:ViewControllerProtocol {
    let backgroundImageView = UIImageView()
    var imageName:String = ""
    let naviBarLeftButton = UIButton()
    
    override func viewDidLoad() {
        self.view.backgroundColor  = .white
        backgroundImageView.image = UIImage(named: imageName)
        backgroundImageView.contentMode = .scaleAspectFit
        view.addSubview(backgroundImageView)
        
        naviBarLeftButton.setTitle("Close", for: .normal)
        naviBarLeftButton.contentHorizontalAlignment = .left
        naviBarLeftButton.backgroundColor = .clear
        naviBarLeftButton.setTitleColor(CommonColor.systemBlueColor, for: .normal)
        naviBarLeftButton.addTarget(self, action: #selector(dismissThisView), for: .touchUpInside)
        self.view.addSubview(naviBarLeftButton)
        
        view.needsUpdateConstraints()
        view.updateConstraintsIfNeeded()
    }
    
    @objc func dismissThisView()
    {
        self.dismiss(animated: false, completion: nil);
    }
    
    
    override func updateViewConstraints() {
        
        if !didSetupConstraints {
            naviBarLeftButton.snp.makeConstraints { (make) in
                make.left.equalTo(view).inset(10);
                make.top.equalTo(30)
                make.height.equalTo(50);
                make.width.equalTo(100);
            }
            
            backgroundImageView.snp.makeConstraints { (make) in
                make.top.equalTo(view).inset(60)
                make.left.right.bottom.equalTo(view).inset(0)
            }
            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
    }
    
}
