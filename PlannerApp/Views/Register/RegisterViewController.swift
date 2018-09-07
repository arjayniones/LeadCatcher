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
    let backButton = UIButton();
    let loginIDTextField = UITextField();
    let passwordTextField = UITextField();
    let confirmPasswordTextField = UITextField();
    let bottomBorder1 = UIView();
    let bottomBorder2 = UIView();
    let bottomBorder3 = UIView();
    let naviBar = UIView();
    let titleLabel = UILabel();
    
    var didSetupConstraints = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white;
        
        naviBar.backgroundColor = CommonColor.naviBarBlackColor;
        view.addSubview(naviBar);
        
        titleLabel.text = "Sign Up";
        titleLabel.textAlignment = NSTextAlignment.center;
        titleLabel.font = CommonFontType.sfProTextBold;
        titleLabel.textColor = CommonColor.systemWhiteColor;
        naviBar.addSubview(titleLabel);
        
        backButton.backgroundColor = CommonColor.naviBarBlackColor;
        backButton.setTitle("Back", for: .normal);
        backButton.titleLabel?.textAlignment = NSTextAlignment.left;
        backButton.titleLabel?.font = CommonFontType.sfProTextRegular;
        backButton.titleLabel?.textColor = CommonColor.systemWhiteColor;
        backButton.addTarget(self, action: #selector(backToSignInVC), for: .touchUpInside);
        naviBar.addSubview(backButton);
        
        loginIDTextField.placeholder = "Login ID";
        loginIDTextField.font = UIFont(name: "SFProText-Regular", size: 17);
        loginIDTextField.textAlignment = NSTextAlignment.left;
        view.addSubview(loginIDTextField);
        
        passwordTextField.placeholder = "Password";
        passwordTextField.font = CommonFontType.sfProTextRegular;
        passwordTextField.textAlignment = NSTextAlignment.left;
        view.addSubview(passwordTextField);
//
        confirmPasswordTextField.placeholder = "Confirm Password";
        confirmPasswordTextField.font = CommonFontType.sfProTextRegular;
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
        
        continueButton.setTitle("Continue", for: .normal);
        continueButton.addTarget(self, action: #selector(navigateToDashBoard), for: .touchUpInside)
        continueButton.backgroundColor = CommonColor.buttonBlackColor;
        continueButton.titleLabel?.font = CommonFontType.sfProTextBold;
        view.addSubview(continueButton);
        // Do any additional setup after loading the view.
        view.setNeedsUpdateConstraints()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func updateViewConstraints() {
        
        if !didSetupConstraints {
            
            naviBar.snp.makeConstraints{
                make in
                make.top.equalTo(view).inset(0);
                make.width.equalTo(view).inset(0);
                make.height.equalTo(60);
            }
            
            titleLabel.snp.makeConstraints{
                make in
                make.center.equalTo(naviBar);
            }
            
            backButton.snp.makeConstraints{
                make in
                make.height.equalTo(44);
                make.width.equalTo(60);
                make.top.equalTo(naviBar.snp.top).offset(10);
                make.left.equalTo(naviBar).offset(10);
            }
            
            loginIDTextField.snp.makeConstraints{
                make in
                make.top.equalTo(naviBar.snp.bottom).offset(90);
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
            
            continueButton.snp.makeConstraints{
                make in
                make.top.equalTo(confirmPasswordTextField.snp.bottom).offset(30);
                make.width.equalTo(view).multipliedBy(0.3);
                make.height.equalTo(40);
                make.centerX.equalTo(confirmPasswordTextField.snp.centerX);
            }
            
        }
        
        super.updateViewConstraints()
        
    }
    
    // MARK: - selector
    @objc func navigateToDashBoard()
    {
        self.present(BaseViewController(), animated: true, completion: nil)
    }
    
    @objc func backToSignInVC()
    {
        self.dismiss(animated: true, completion: nil);
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
