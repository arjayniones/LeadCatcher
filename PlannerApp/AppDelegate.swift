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
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        center.requestAuthorization(options: options) { (granted, error) in
            if granted {
//                DispatchQueue.main.async {
//                    application.registerForRemoteNotifications()
//                }
            }
        }
        
        prepareAndExecute() {
            
            GMSServices.provideAPIKey("AIzaSyCeTGV2wh-JFCok4DN_NQdtdpx5m1epQV4")
            //GMSPlacesClient.provideAPIKey("AIzaSyCeTGV2wh-JFCok4DN_NQdtdpx5m1epQV4")
            
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
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let actionIdentifier = response.actionIdentifier
        let content = response.notification.request.content
        
        switch actionIdentifier {
        case UNNotificationDismissActionIdentifier: // Notification was dismissed by user
            // Do something
            completionHandler()
        case UNNotificationDefaultActionIdentifier: // App was opened from notification
            // Do something
            completionHandler()
        default:
            completionHandler()
        }
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.alert,.sound,.badge])
    }


}

