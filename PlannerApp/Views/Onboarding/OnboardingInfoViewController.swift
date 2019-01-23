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
        OnboardingItemInfo(informationImage: UIImage(named:"landing1")!,
                           title: "_",
                           description: "_",
                           pageIcon: UIImage(named:"clear")!,
                           color: .clear,
                           titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont),
        
        OnboardingItemInfo(informationImage: UIImage(named:"landing2")!,
                           title: "_",
                           description: "_",
                           pageIcon: UIImage(named:"clear")!,
                           color: UIColor.clear,
                           titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont),
        
        OnboardingItemInfo(informationImage: UIImage(named:"landing3")!,
                           title: "_",
                           description: "_",
                           pageIcon: UIImage(named:"clear")!,
                           color: UIColor.clear,
                           titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont),
        
        ]
    
    let nameTextField: UITextField = UITextField()
    let onboarding = PaperOnboarding()
    //let imageLastImageView = UIImageView(image:UIImage(named: "man-woman-icon"))
    //let welcomeLabel = UILabel()
    let pageControl = UIPageControl()
    let welcomeImg = UIImageView(image: UIImage(named: "welcome"))
    let bottomView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()

        //view.backgroundColor = UIColor(red: 0.33, green: 0.56, blue: 0.74, alpha: 1.00)
        view.backgroundColor = UIColor.white
        welcomeImg.contentMode = .scaleAspectFit
        bottomView.backgroundColor = .white
        view.addSubview(welcomeImg)
        view.addSubview(bottomView)
        
        pageControl.numberOfPages = 3
        pageControl.backgroundColor = .white
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.pageIndicatorTintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        bottomView.addSubview(pageControl)
        
        onboarding.delegate = self
        onboarding.dataSource = self
        onboarding.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(onboarding)
        
//        welcomeLabel.textAlignment = .center
//        welcomeLabel.text = "Welcome!"
//        welcomeLabel.font = OnboardingInfoViewController.titleFont
//        welcomeLabel.textColor = .white
//        welcomeLabel.isHidden = true
//        view.addSubview(welcomeLabel)
        
        nameTextField.delegate = self
        nameTextField.returnKeyType = .done
        nameTextField.keyboardType = .alphabet
        nameTextField.backgroundColor = .white
        nameTextField.backgroundColor?.withAlphaComponent(0.5)
        nameTextField.layer.borderColor = UIColor.white.cgColor
        nameTextField.layer.borderWidth = 1
        nameTextField.layer.cornerRadius = 10
        nameTextField.textAlignment = .center
        nameTextField.isHidden = true
        nameTextField.clipsToBounds = true
        nameTextField.textColor = CommonColor.darkGrayColor
        nameTextField.font = UIFont.systemFont(ofSize: 15)
        nameTextField.placeholder = "How should i address you?"
        //nameTextField.frame = CGRect(x: 70, y: 160, width: 195, height: <#T##Int#>)
        view.addSubview(nameTextField)
        
        //imageLastImageView.isHidden = true
        //view.addSubview(imageLastImageView)
        
        view.updateConstraintsIfNeeded()
        view.setNeedsUpdateConstraints()
    }
    
    override func updateViewConstraints() {
        
        if !didSetupConstraints {
            
            welcomeImg.snp.makeConstraints { (make) in
                make.top.bottom.left.right.equalTo(view).inset(0)
            }
            
//            welcomeLabel.snp.makeConstraints{ make in
//                make.top.equalTo(view.safeArea.top).inset(30)
//                make.centerX.equalToSuperview()
//            }
            
            onboarding.snp.makeConstraints {make in
                make.edges.equalToSuperview()
            }
//            imageLastImageView.snp.makeConstraints { make in
//                make.centerX.equalTo(nameTextField.snp.centerX)
//            }
            
            nameTextField.snp.makeConstraints { make in
                make.height.equalTo(40)
                make.centerY.equalToSuperview().inset(-135)
                //make.centerY.equalToSuperview().inset(-170)
                make.left.right.equalTo(view).inset(50)
                //make.top.equalTo(welcomeImg.snp.bottom).offset(20)
            }
            
            bottomView.snp.makeConstraints { (make) in
                make.left.right.top.bottom.equalTo(view).inset(0)
            }
            
            pageControl.snp.makeConstraints { (make) in
                make.left.right.equalTo(bottomView).inset(0)
                make.height.equalTo(30)
                make.centerX.equalTo(nameTextField.snp.centerX)
                make.bottom.equalTo(bottomView).inset(10)
            }
            
            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
    }

}

extension OnboardingInfoViewController: PaperOnboardingDelegate {
    
    func onboardingDidTransitonToIndex(_ index: Int) {
        
        pageControl.currentPage = index
        
        if index == self.items.count - 1{
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.onboarding.isHidden = true
                self.nameTextField.isHidden = false
                //self.imageLastImageView.isHidden = false
                //self.welcomeLabel.isHidden = false
                self.bottomView.isHidden = true
            }
        }
    }
    
    func onboardingConfigurationItem(_ item: OnboardingContentViewItem, index: Int) {
        //item.titleLabel?.backgroundColor = .redColor()
        //item.descriptionLabel?.backgroundColor = .redColor()
        //item.imageView = ...
        item.backgroundColor = .clear
        
        let screenSize: CGRect = UIScreen.main.bounds
        //item.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height - 40)
        if screenSize.height <= 670
        {
            item.imageView?.frame = CGRect(x: 0, y: 160, width: screenSize.width, height: screenSize.height)
//            if index == 0
//            {
//                item.imageView?.image = UIImage(named:"landing1")!
//            }
//            else if index == 1
//            {
//                item.imageView?.image = UIImage(named:"landing2")!
//            }
//            else
//            {
//                item.imageView?.image = UIImage(named:"landing3")!
//            }
        }
        else
        {
            item.imageView?.frame = CGRect(x: 0, y: 100, width: screenSize.width, height: screenSize.height)
//            if index == 0
//            {
//                item.imageView?.image = UIImage(named:"landingX1")!
//            }
//            else if index == 1
//            {
//                item.imageView?.image = UIImage(named:"landingX2")!
//            }
//            else
//            {
//                item.imageView?.image = UIImage(named:"landingX3")!
//            }
            
        }
        
        item.imageView?.contentMode = .scaleAspectFit
        item.imageView?.translatesAutoresizingMaskIntoConstraints = true
        
        item.informationImageWidthConstraint = item.imageView! >>>- {
            $0.attribute = NSLayoutConstraint.Attribute.width
            $0.constant = screenSize.width
            return
        }
        item.informationImageHeightConstraint = item.imageView! >>>- {
            $0.attribute = NSLayoutConstraint.Attribute.height
            $0.constant = screenSize.height
            return
        }
        
        //item.imageView?.backgroundColor = .red
        //item.imageView?.contentMode = .scaleAspectFit
        //item.imageView?.clipsToBounds = true
        //img.contentMode = .scaleAspectFill
        //img.clipsToBounds = true
        item.setNeedsUpdateConstraints()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if let name = textField.text {
            if name.count >= 4 && name.count <= 8{
                Defaults[.SessionUsername] = textField.text
                Defaults[.NeedOnboarding] = false
                self.view.window?.rootViewController = BaseViewController()
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
        func onboardingPageItemSelectedRadius() -> CGFloat {
            return 10
        }
        func onboardingPageItemColor(at index: Int) -> UIColor {
            return [UIColor.clear, UIColor.clear, UIColor.clear][index]
        }
    
    
}
