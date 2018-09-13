//
//  NavBarProtocols.swift
//  PlannerApp
//
//  Created by Alkuino Robert John Matias on 13/09/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import UIKit

protocol NativeNavbar {
    func updateNavbarAppear()
}

extension NativeNavbar where Self: UIViewController {
    
    func updateNavbarAppear() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = CommonColor.naviBarBlackColor
        navigationController?.navigationBar.setTitleVerticalPositionAdjustment(0, for: .default)
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedStringKey.font: CommonFontType.sfProTextBold,
            NSAttributedStringKey.foregroundColor: CommonColor.systemWhiteColor,
        ]
        
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = false
        }
        
        UIApplication.shared.setStatusBarHidden(false, with: .none)
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
    }
}

protocol LargeNativeNavbar {
    func updateNavbarAppear()
}

extension LargeNativeNavbar where Self: UIViewController {
    
    func updateNavbarAppear() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = CommonColor.naviBarBlackColor
        navigationController?.navigationBar.setTitleVerticalPositionAdjustment(0, for: .default)
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        
        UIApplication.shared.setStatusBarHidden(false, with: .none)
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: CommonColor.systemWhiteColor]
        } else {
            navigationController?.navigationBar.titleTextAttributes = [
                NSAttributedStringKey.font: CommonFontType.sfProTextBold,
                NSAttributedStringKey.foregroundColor: CommonColor.systemWhiteColor,
            ]
        }
        
    }
}


