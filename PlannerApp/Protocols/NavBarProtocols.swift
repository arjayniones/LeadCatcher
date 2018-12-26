//
//  NavBarProtocols.swift
//  PlannerApp
//
//  Created by Alkuino Robert John Matias on 13/09/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import UIKit

protocol NoNavbar {
    func updateNavbarAppear()
}

extension NoNavbar where Self: UIViewController {
    
    func updateNavbarAppear() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = CommonColor.systemWhiteColor
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.ofSize(fontSize: 17, withType: .bold),
            NSAttributedString.Key.foregroundColor: CommonColor.systemWhiteColor,
        ]
    }
}

protocol NativeNavbar {
    func updateNavbarAppear()
}

extension NativeNavbar where Self: UIViewController {
    
    func updateBlackNavBarAppear()
    {
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.barTintColor = .white //CommonColor.naviBarBlackColor
        navigationController?.navigationBar.tintColor = CommonColor.systemBlueColor
        navigationController?.navigationBar.setTitleVerticalPositionAdjustment(0, for: .default)
        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "contact-details-gradiant-bg-x1.jpg"), for: .default)
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.ofSize(fontSize: 17, withType: .bold),
            NSAttributedString.Key.foregroundColor: CommonColor.naviBarBlackColor,
        ]
        
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = false
        }
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    func updateNavbarAppear() {
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.barTintColor = UIColor(red: 84, green: 165, blue: 198) //CommonColor.naviBarBlackColor
        navigationController?.navigationBar.tintColor = CommonColor.systemWhiteColor
        navigationController?.navigationBar.setTitleVerticalPositionAdjustment(0, for: .default)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.ofSize(fontSize: 17, withType: .bold),
            NSAttributedString.Key.foregroundColor: CommonColor.systemWhiteColor,
        ]
        
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = false
        }
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
    }
}

protocol LargeNativeNavbar {
    func updateNavbarAppear()
}

extension LargeNativeNavbar where Self: UIViewController {
    
    func updateNavbarAppear() {

        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.barTintColor = .clear //CommonColor.naviBarBlackColor

        navigationController?.navigationBar.tintColor = CommonColor.systemWhiteColor
        navigationController?.navigationBar.setTitleVerticalPositionAdjustment(0, for: .default)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: CommonColor.systemWhiteColor]
        } else {
            navigationController?.navigationBar.titleTextAttributes = [
                NSAttributedString.Key.font: UIFont.ofSize(fontSize: 17, withType: .bold),
                NSAttributedString.Key.foregroundColor: CommonColor.systemWhiteColor,
            ]
        }
        
        
    }
}


