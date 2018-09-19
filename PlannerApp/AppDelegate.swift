//
//  AppDelegate.swift
//  PlannerApp
//
//  Created by Alkuino Robert John Matias on 06/09/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import UIKit
import Neon
import SnapKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let center = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        center.requestAuthorization(options: options) { (granted, error) in
            if granted {
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            }
        }
        
        prepareAndExecute() {
            
            self.window?.rootViewController = BaseViewController()
        }
        
        return true
    }
    
    private func prepareAndExecute(fn: () -> ()) {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        self.window?.backgroundColor = .white
        
        SessionService.onLogout(performAlways: true) {
            self.window?.rootViewController?.present(LoginViewController(), animated: true, completion: nil)
        }
        
        fn()
        
        self.window?.makeKeyAndVisible()
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        //
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        //
    }


}

