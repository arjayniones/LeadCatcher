//
//  OnboardingInfoViewController.swift
//  PlannerApp
//
//  Created by Alkuino Robert John Matias on 13/11/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import UIKit
import PaperOnboarding
import SwiftyUserDefaults

class OnboardingInfoViewController: ViewControllerProtocol ,UITextFieldDelegate{
    
    private static let titleFont = UIFont.ofSize(fontSize: 36, withType: .bold)
    private static let descriptionFont = UIFont.ofSize(fontSize: 14, withType: .regular)
    
    fileprivate let items = [
        OnboardingItemInfo(informationImage: UIImage(named:"onboarding-one-icon")!,
                           title: "Agent",
                           description: "We help Agents to organize their tasks by Category and Priority.",
                           pageIcon: UIImage(named:"onboarding-one-icon")!,
                           color: UIColor(red: 0.40, green: 0.56, blue: 0.71, alpha: 1.00),
                           titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont),
        
        OnboardingItemInfo(informationImage: UIImage(named:"onboarding-two-icon")!,
                           title: "Business",
                           description: "We have all features which Agents needed to fullfil and maximize his/her Business Management.",
                           pageIcon: UIImage(named:"onboarding-two-icon")!,
                           color: UIColor(red: 0.40, green: 0.69, blue: 0.71, alpha: 1.00),
                           titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont),
        
        OnboardingItemInfo(informationImage: UIImage(named:"onboarding-three-icon")!,
                           title: "Customer",
                           description: "Make the Customers happy and satisfied.",
                           pageIcon: UIImage(named:"onboarding-three-icon")!,
                           color: UIColor(red: 0.61, green: 0.56, blue: 0.74, alpha: 1.00),
                           titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont),
        
        ]
    
    let nameTextField: UITextField = UITextField()
    let onboarding = PaperOnboarding()
    let imageLastImageView = UIImageView(image:UIImage(named: "man-woman-icon"))
    let welcomeLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(red: 0.33, green: 0.56, blue: 0.74, alpha: 1.00)
        
        onboarding.delegate = self
        onboarding.dataSource = self
        onboarding.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(onboarding)
        
        welcomeLabel.textAlignment = .center
        welcomeLabel.text = "Welcome!"
        welcomeLabel.font = OnboardingInfoViewController.titleFont
        welcomeLabel.textColor = .white
        welcomeLabel.isHidden = true
        view.addSubview(welcomeLabel)
        
        nameTextField.delegate = self
        nameTextField.returnKeyType = .done
        nameTextField.keyboardType = .alphabet
        nameTextField.layer.borderColor = UIColor.white.cgColor
        nameTextField.layer.borderWidth = 1
        nameTextField.layer.cornerRadius = 10
        nameTextField.textAlignment = .center
        nameTextField.isHidden = true
        nameTextField.clipsToBounds = true
        nameTextField.textColor = .white
        nameTextField.placeholder = "What should I call you?"
        view.addSubview(nameTextField)
        
        imageLastImageView.isHidden = true
        view.addSubview(imageLastImageView)
        
        view.updateConstraintsIfNeeded()
        view.setNeedsUpdateConstraints()
    }
    
    override func updateViewConstraints() {
        
        if !didSetupConstraints {
            
            welcomeLabel.snp.makeConstraints{ make in
                make.top.equalTo(view.safeArea.top).inset(30)
                make.centerX.equalToSuperview()
            }
            
            onboarding.snp.makeConstraints {make in
                make.edges.equalToSuperview()
            }
            imageLastImageView.snp.makeConstraints { make in
                make.centerX.equalTo(nameTextField.snp.centerX)
            }
            
            nameTextField.snp.makeConstraints { make in
                make.height.equalTo(40)
                make.centerY.equalToSuperview()
                make.left.right.equalTo(view).inset(20)
                make.top.equalTo(imageLastImageView.snp.bottom).offset(20)
            }
            
            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
    }

}

extension OnboardingInfoViewController: PaperOnboardingDelegate {
    
    func onboardingDidTransitonToIndex(_ index: Int) {
        if index == self.items.count - 1{
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.onboarding.isHidden = true
                self.nameTextField.isHidden = false
                self.imageLastImageView.isHidden = false
                self.welcomeLabel.isHidden = false
            }
        }
    }
    
    func onboardingConfigurationItem(_ item: OnboardingContentViewItem, index: Int) {
        //item.titleLabel?.backgroundColor = .redColor()
        //item.descriptionLabel?.backgroundColor = .redColor()
        //item.imageView = ...
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if let name = textField.text {
            if name.count >= 4 && name.count <= 8{
                Defaults[.SessionUsername] = textField.text
                Defaults[.NeedOnboarding] = false
                self.dismiss(animated: true, completion: nil)
            } else {
                self.alert()
            }
        } else {
            self.alert()
        }
        
        return true
    }
    
    func alert() {
        let alert = UIAlertController(title: "Info", message: "Name must be in 4 to 8 characters.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style:.cancel, handler: nil));
        present(alert, animated: true, completion: nil)
    }
}



extension OnboardingInfoViewController: PaperOnboardingDataSource {
    
    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        return items[index]
    }
    
    func onboardingItemsCount() -> Int {
        return items.count
    }
    
    //    func onboardinPageItemRadius() -> CGFloat {
    //        return 2
    //    }
    //
    //    func onboardingPageItemSelectedRadius() -> CGFloat {
    //        return 10
    //    }
    //    func onboardingPageItemColor(at index: Int) -> UIColor {
    //        return [UIColor.white, UIColor.red, UIColor.green][index]
    //    }
    
    
}
