//
//  UserViewModel.swift
//  PlannerApp
//
//  Created by Lim Ai Zhi on 12/09/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import Foundation
import LocalAuthentication
import RealmSwift
import SwiftyUserDefaults
import UIKit

class UserViewModel{
    
    private init()
    {
        
    }
    // MARK: - Query Realm
    // query UserTable data and return is realmresults
    // checkType = "ViewLoad" will call when viewDidLoad
    // "LoginClick" will only when user click login button
    class func queryUserTable(checkType:String, loginID:String, passcode:String)->Results<UserModel>
    {
        let realmStore = RealmStore<UserModel>()
        
        if checkType == "ViewLoad" {
            // used to define UserTable is empty or not
            return realmStore.models()
        } else {
            // used to verify user info correct or not
            return realmStore.models().filter("U_Username = '\(loginID)' AND U_Password = '\(passcode)'")
        }
    }
    
    //insert user data into user table and return usertable UDID in string
    class func insertDataUserModel(loginID:String, passcode:String)->String
    {
        let data = UserModel().newInstance();
        data.U_Username = loginID;
        data.U_Password = passcode;
        data.add();
        
        return data.id;
    }
    
    // MARK: - text field checking
    // for loginVC and return alert message in string
    class func textFieldIsEmpty(text:String, textTag:Int)->String
    {
        if text.count == 0 && textTag == 0 {
            return "Login ID cannot empty";
        }
        else if text.count == 0 && textTag == 1
        {
            return "Passcode cannot empty";
        }
        else
        {
            return "";
        }
    }
    
    // text field checking for signUpVC and return alert message in string
    class func checkTextFieldIsEmpty(textField1:String, textField2:String, textField3:String)->String
    {
        if textField1.count == 0 {
            return "Login ID cannot empty";
        }
        else if textField2.count == 0
        {
            return "Passcode cannot empty";
        }
        else if textField3.count == 0
        {
            return "Confirm passcode cannot empty";
        }
        else if textField2 != textField3
        {
            return "Passcode not match"
        }
        else
        {
            return "Success";
        }
    }
    
    class func getDocumentsDirectory()
    {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask);
        let documentsDirectory = paths[0];
        print(documentsDirectory);
    }
    
}

// MARK: - Extension for LoginVC and UIVC

extension LoginViewController{
    func authenticationWithTouchID(id:String, completion:@escaping (_ value:String)->Void) {
        let localAuthenticationContext = LAContext()
        localAuthenticationContext.localizedFallbackTitle = "Use Passcode"
        
        var authError: NSError?
        let reasonString = "To access the secure data"
        
        if localAuthenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
            
            localAuthenticationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString) { success, evaluateError in
                
                if success {
                    //TODO: User authenticated successfully, take appropriate action
                    let resultUserList = UserViewModel.queryUserTable(checkType: "ViewLoad", loginID: "", passcode: "");
                    Defaults[.SessionUserId] = resultUserList[0].id;
                    completion("Success")
                } else {
                    //TODO: User did not authenticate successfully, look at error and take appropriate action
                    guard let error = evaluateError else {
                        return
                    }
                    
                    print(self.evaluateAuthenticationPolicyMessageForLA(errorCode: error._code))
                    
                    //TODO: If you have choosen the 'Fallback authentication mechanism selected' (LAError.userFallback). Handle gracefully
                    
                }
            }
        } else {
            
            guard let error = authError else {
                return
            }
            //TODO: Show appropriate alert if biometry/TouchID/FaceID is lockout or not enrolled
            print(self.evaluateAuthenticationPolicyMessageForLA(errorCode: error.code))
        }
    }
    
    func evaluatePolicyFailErrorMessageForLA(errorCode: Int) -> String {
        var message = ""
        if #available(iOS 11.0, macOS 10.13, *) {
            switch errorCode {
            case LAError.biometryNotAvailable.rawValue:
                message = "Authentication could not start because the device does not support biometric authentication."
                
            case LAError.biometryLockout.rawValue:
                message = "Authentication could not continue because the user has been locked out of biometric authentication, due to failing authentication too many times."
                
            case LAError.biometryNotEnrolled.rawValue:
                message = "Authentication could not start because the user has not enrolled in biometric authentication."
                
            default:
                message = "Did not find error code on LAError object"
            }
        } else {
            switch errorCode {
            case LAError.touchIDLockout.rawValue:
                message = "Too many failed attempts."
                
            case LAError.touchIDNotAvailable.rawValue:
                message = "TouchID is not available on the device"
                
            case LAError.touchIDNotEnrolled.rawValue:
                message = "TouchID is not enrolled on the device"
                
            default:
                message = "Did not find error code on LAError object"
            }
        }
        
        return message;
    }
    
    func evaluateAuthenticationPolicyMessageForLA(errorCode: Int) -> String {
        
        var message = ""
        
        switch errorCode {
            
        case LAError.authenticationFailed.rawValue:
            message = "The user failed to provide valid credentials"
            
        case LAError.appCancel.rawValue:
            message = "Authentication was cancelled by application"
            
        case LAError.invalidContext.rawValue:
            message = "The context is invalid"
            
        case LAError.notInteractive.rawValue:
            message = "Not interactive"
            
        case LAError.passcodeNotSet.rawValue:
            message = "Passcode is not set on the device"
            
        case LAError.systemCancel.rawValue:
            message = "Authentication was cancelled by the system"
            
        case LAError.userCancel.rawValue:
            message = "The user did cancel"
            
        case LAError.userFallback.rawValue:
            message = "The user chose to use the fallback"
            
        default:
            message = evaluatePolicyFailErrorMessageForLA(errorCode: errorCode)
        }
        
        return message
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
