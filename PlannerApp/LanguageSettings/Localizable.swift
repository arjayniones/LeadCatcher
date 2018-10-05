//
//  String+Localizable.swift
//  Localizable
//
//  Created by Roman Sorochak <roman.sorochak@gmail.com> on 6/23/17.
//  Copyright © 2017 MagicLab. All rights reserved.
//

import UIKit


private let appleLanguagesKey = "AppleLanguages"

enum Language: String {
    
    case english = "en"
    case chinese = "zh"
    case malay = "ms-MY"
    
    var semantic: UISemanticContentAttribute {
        switch self {
        case .english, .chinese , .malay:
            return .forceLeftToRight
//        case .arabic:
//            return .forceRightToLeft
//        }
        }
    }
    
    
    static var language: Language {
        get {
            if let languageCode = UserDefaults.standard.string(forKey: appleLanguagesKey),
                let language = Language(rawValue: languageCode) {
                return language
            } else {
                let preferredLanguage = NSLocale.preferredLanguages[0] as String
                
//                let index = preferredLanguage.index(
//                    preferredLanguage.startIndex,
//                    offsetBy: 2
//                )
                guard let localization = Language(rawValue: preferredLanguage) else {
                        return Language.english
                }
                
                return localization
            }
        }
        set {
            guard language != newValue else {
                return
            }
            
            UserDefaults.standard.set([newValue.rawValue], forKey: appleLanguagesKey)
            UserDefaults.standard.synchronize()
            
            UIView.appearance().semanticContentAttribute = newValue.semantic
            
            UIApplication.shared.windows[0].rootViewController = BaseViewController()
        }
    }
}


extension String {
    
    var localized: String {
        return Bundle.localizedBundle.localizedString(forKey: self, value: nil, table: nil)
    }
    
    var localizedImage: UIImage? {
        return localizedImage()
            ?? localizedImage(type: ".png")
            ?? localizedImage(type: ".jpg")
            ?? localizedImage(type: ".jpeg")
            ?? UIImage(named: self)
    }
    
    private func localizedImage(type: String = "") -> UIImage? {
        guard let imagePath = Bundle.localizedBundle.path(forResource: self, ofType: type) else {
            return nil
        }
        return UIImage(contentsOfFile: imagePath)
    }
}

extension Bundle {
    static var localizedBundle: Bundle {
        let languageCode = Language.language.rawValue
        guard let path = Bundle.main.path(forResource: languageCode, ofType: "lproj") else {
            return Bundle.main
        }
        return Bundle(path: path)!
    }
}
