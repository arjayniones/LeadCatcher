//
//  UIAlertController+Convenience.swift
//  iDealer
//
//  Created by IRS on 12/02/2018.
//  Copyright © 2018 IrsSoftware. All rights reserved.
//

import UIKit

extension UIAlertController
{
    class func alertControllerWithTitle(title:String, message:String) -> UIAlertController
    {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert);
        controller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil));
        return controller;
        
    }
    
    class func alertControllerWithNumberInput(title:String, message:String, buttonTitle:String, handler:@escaping (Int?)->Void)->UIAlertController
    {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert);
        controller.addTextField { $0.keyboardType = .numberPad};
        controller.addAction(UIAlertAction(title: "Cancel", style:.cancel, handler: nil));
        controller.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: { action in
            let textFields = controller.textFields;
            let value = Int((textFields?[0].text)!);
            handler(value);
        }));
        
        return controller;
    }
    
    
}
