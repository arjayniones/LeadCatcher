//
//  OnboardingViewController.swift
//  PlannerApp
//
//  Created by Alkuino Robert John Matias on 08/11/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

class OnboardingViewController: ViewControllerProtocol ,UITextFieldDelegate{
    
    let nameTextField: UITextField = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        nameTextField.delegate = self
        nameTextField.returnKeyType = .done
        nameTextField.keyboardType = .alphabet
        nameTextField.layer.borderColor = UIColor.lightGray.cgColor
        nameTextField.layer.borderWidth = 1
        nameTextField.layer.cornerRadius = 10
        nameTextField.clipsToBounds = true
        nameTextField.placeholder = "What should I call you?"
        
        view.addSubview(nameTextField)
        
        
        view.updateConstraintsIfNeeded()
        view.setNeedsUpdateConstraints()
    }
    
    override func updateViewConstraints() {
        
        if !didSetupConstraints {
            
            nameTextField.snp.makeConstraints { make in
                make.height.equalTo(40)
                make.centerY.equalToSuperview()
                make.left.right.equalTo(view).inset(20)
            }
            
            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
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
