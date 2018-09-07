//
//  RegisterViewController.swift
//  PlannerApp
//
//  Created by Lim Ai Zhi on 06/09/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    let continueButton = UIButton();
    let cancelButton = UIButton();
    let loginIDTextField = UITextField();
    let passwordTextField = UITextField();
    let confirmPasswordTextField = UITextField();
    let bottomBorder1 = UIView();
    let bottomBorder2 = UIView();
    let bottomBorder3 = UIView();
    var didSetupConstraints = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white;
        
        loginIDTextField.placeholder = "Login ID";
        loginIDTextField.font = UIFont(name: "SFProText-Regular", size: 17);
        loginIDTextField.textAlignment = NSTextAlignment.left;
        view.addSubview(loginIDTextField);
        
        passwordTextField.placeholder = "Password";
        passwordTextField.font = UIFont(name: "SFProText-Regular", size: 17);
        passwordTextField.textAlignment = NSTextAlignment.left;
        view.addSubview(passwordTextField);
//
        confirmPasswordTextField.placeholder = "Confirm Password";
        confirmPasswordTextField.font = UIFont(name: "SFProText-Regular", size: 17);
        confirmPasswordTextField.textAlignment = NSTextAlignment.left;
        view.addSubview(confirmPasswordTextField);
//
        bottomBorder1.backgroundColor = UIColor.lightGray;
        loginIDTextField.addSubview(bottomBorder1);
//
        bottomBorder2.backgroundColor = UIColor.lightGray;
        passwordTextField.addSubview(bottomBorder2);
//
        bottomBorder3.backgroundColor = UIColor.lightGray;
        confirmPasswordTextField.addSubview(bottomBorder3);
        
        continueButton.backgroundColor = CommonColor.buttonBlackColor;
        continueButton.titleLabel?.font = CommonFontType.sfProTextBold;
        
        // Do any additional setup after loading the view.
        view.setNeedsUpdateConstraints()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func updateViewConstraints() {
        
        if !didSetupConstraints {
            loginIDTextField.snp.makeConstraints{
                make in
                make.top.equalTo(view).inset(150);
                make.left.right.equalTo(view).inset(10);
            }
            
            bottomBorder1.snp.makeConstraints{
                make in
                make.top.equalTo(loginIDTextField.snp.bottom);
                make.left.right.equalTo(loginIDTextField).inset(0);
                make.height.equalTo(1);
            }
            
            passwordTextField.snp.makeConstraints{
                make in
                make.top.equalTo(loginIDTextField.snp.bottom).offset(30);
                make.left.right.equalTo(view).inset(10);
            }
            
            bottomBorder2.snp.makeConstraints{
                make in
                make.top.equalTo(passwordTextField.snp.bottom);
                make.left.right.equalTo(passwordTextField).inset(0);
                make.height.equalTo(1);
            }
            
            confirmPasswordTextField.snp.makeConstraints{
                make in
                make.top.equalTo(passwordTextField.snp.bottom).offset(30);
                make.left.right.equalTo(view).inset(10);
            }
            
            bottomBorder3.snp.makeConstraints{
                make in
                make.top.equalTo(confirmPasswordTextField.snp.bottom);
                make.left.right.equalTo(confirmPasswordTextField).inset(0);
                make.height.equalTo(1);
            }
            
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
