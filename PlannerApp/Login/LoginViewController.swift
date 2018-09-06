//
//  LoginViewController.swift
//  PlannerApp
//
//  Created by Lim Ai Zhi on 06/09/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    let loginUsernameField = UITextField()
    let passwordField = UITextField()
    
    let loginButton = UIButton()
    let signUpButton = UIButton()
    
    let labelBottomRight = UILabel();
    let labelBottomLeft = UILabel();
    let viewTest = UIView();
    let bottomBorderLoginID = UIView();
    let bottomBorderPassword = UIView();
    
    var didSetupConstraints = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        edgesForExtendedLayout=[];
        view.backgroundColor = .white
        
        loginUsernameField.placeholder = "Login ID";
        loginUsernameField.font = UIFont(name: "SFTextPro-Regular", size: 17)
        loginUsernameField.textAlignment = NSTextAlignment.left
        view.addSubview(loginUsernameField)
        
        passwordField.placeholder = "Password";
        passwordField.font = UIFont(name: "SFTextPro-Regular", size: 17)
        passwordField.textAlignment = NSTextAlignment.left
        view.addSubview(passwordField)
        
        loginButton.setTitle("Login", for: .normal)
        loginButton.titleLabel?.font = UIFont(name: "SFProText-Bold", size: 17)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.layer.borderWidth   =    1
        loginButton.backgroundColor = CommonColor.buttonBlackColor;
        loginButton.addTarget(self, action: #selector(loginButtonTouched), for: .touchUpInside)
        view.addSubview(loginButton)
        
        bottomBorderLoginID.backgroundColor = UIColor.lightGray;
        bottomBorderPassword.backgroundColor = UIColor.lightGray;
        
        loginUsernameField.addSubview(bottomBorderLoginID);
        passwordField.addSubview(bottomBorderPassword);
        
        signUpButton.setTitle("Sign Up", for: .normal);
        signUpButton.setTitleColor(.white, for: .normal);
        signUpButton.titleLabel?.font = UIFont(name: "SFProText-Bold", size: 17);
        signUpButton.backgroundColor = CommonColor.buttonBlackColor;
        signUpButton.addTarget(self, action: #selector(signUpButtonTap(_:)), for: .touchUpInside);
        view.addSubview(signUpButton);
        
        labelBottomRight.text = "Testing";
        labelBottomRight.textColor = .black;
        view.addSubview(labelBottomRight);
        
        labelBottomLeft.text = "Testing";
        labelBottomLeft.textColor = .black;
        view.addSubview(labelBottomLeft);
        
        viewTest.backgroundColor = .black;
        view.addSubview(viewTest);
        
        
        view.setNeedsUpdateConstraints()
        
    }
    
    @objc func loginButtonTouched() {
        self.present(BaseViewController(), animated: true, completion: nil)
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
                
                make.top.equalTo(view).inset(150)
                make.left.right.equalTo(view).inset(10)
                make.height.equalTo(40)
            }
            
            bottomBorderLoginID.snp.makeConstraints{
                make in
                make.top.equalTo(loginUsernameField.snp.bottom);
                make.height.equalTo(1);
                make.left.right.equalTo(loginUsernameField).inset(0)
            }
            
            passwordField.snp.makeConstraints { make in
                
                make.top.equalTo(loginUsernameField.snp.bottom).offset(30)
                make.left.right.equalTo(view).inset(10)
                make.height.equalTo(40)
            }
            
            bottomBorderPassword.snp.makeConstraints{
                make in
                make.top.equalTo(passwordField.snp.bottom);
                make.height.equalTo(1);
                make.left.right.equalTo(passwordField).inset(0)
            }
            
            loginButton.snp.makeConstraints { make in
                
                make.top.equalTo(passwordField.snp.bottom).offset(30)
                make.width.equalTo(view.snp.width).multipliedBy(0.3)
                make.height.equalTo(40)
                make.centerX.equalTo(passwordField.snp.centerX)
            }
            
            signUpButton.snp.makeConstraints{
                make in
                make.top.equalTo(loginButton.snp.bottom).offset(30);
                make.width.equalTo(view.snp.width).multipliedBy(0.3);
                make.height.equalTo(40);
                make.centerX.equalTo(passwordField.snp.centerX);
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
    
    @objc func signUpButtonTap(_ sender : UIButton)
    {
        let vc = RegisterViewController();
        self.present(vc, animated: true, completion: nil)
        
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
