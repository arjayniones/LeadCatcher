//
//  LoginViewController.swift
//  PlannerApp
//
//  Created by Lim Ai Zhi on 06/09/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    let loginUsernameField = UILabel()
    let passwordField = UILabel()
    
    let button = UIButton()
    let labelBottomRight = UILabel();
    let labelBottomLeft = UILabel();
    let viewTest = UIView();
    
    var didSetupConstraints = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        edgesForExtendedLayout=[];
        view.backgroundColor = .yellow
        
        loginUsernameField.layer.borderWidth = 1
        loginUsernameField.backgroundColor = .black
        loginUsernameField.layer.borderColor = UIColor.black.cgColor
        view.addSubview(loginUsernameField)
        
        passwordField.layer.borderWidth = 1
        passwordField.backgroundColor = .green
        passwordField.layer.borderColor = UIColor.black.cgColor
        view.addSubview(passwordField)
        
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.green, for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth   =    1
        button.backgroundColor = .blue
        view.addSubview(button)
        
        labelBottomRight.text = "Testing";
        labelBottomRight.textColor = .black;
        view.addSubview(labelBottomRight);
        
        labelBottomLeft.text = "Testing";
        labelBottomLeft.textColor = .black;
        view.addSubview(labelBottomLeft);
        
        viewTest.backgroundColor = .black;
        view.addSubview(viewTest);
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        let navHeight = navigationController?.navigationBar.height
//
//        loginUsernameField.anchorToEdge(.top, padding: navHeight! + 60, width: view.width-40, height: 40)
//
//    }
//
    override func updateViewConstraints() {
        
        if !didSetupConstraints {
            loginUsernameField.snp.makeConstraints { make in
                
                make.top.equalTo(view).inset(100)
                make.left.right.equalTo(view).inset(10)
                make.height.equalTo(40)
            }
            
            passwordField.snp.makeConstraints { make in
                
                make.top.equalTo(loginUsernameField.snp.bottom).offset(30)
                make.left.right.equalTo(view).inset(10)
                make.height.equalTo(40)
            }
            
            button.snp.makeConstraints { make in
                
                make.top.equalTo(passwordField.snp.bottom).offset(30)
                make.width.equalTo(view.snp.width).multipliedBy(0.3)
                make.height.equalTo(40)
                make.centerX.equalTo(passwordField.snp.centerX)
            }
            
            labelBottomRight.snp.makeConstraints{ make in
                make.bottom.equalTo(view).inset(40 + 10);
                make.right.equalTo(view).inset(10);
            }
            
            labelBottomLeft.snp.makeConstraints{ make in
                make.bottom.equalTo(view).inset(40 + 10);
                make.left.equalTo(view).inset(10);
            }
            
            viewTest.snp.makeConstraints{
                make in
                make.height.equalTo(60);
                make.width.equalTo(60);
                make.bottom.equalTo(labelBottomLeft.snp.top).offset(-10);
                make.left.equalTo(labelBottomLeft.snp.left)
                //make.left.greaterThanOrEqualTo(labelBottomLeft);
            }
            
            
            didSetupConstraints = true
        }
        
        
        super.updateViewConstraints()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
