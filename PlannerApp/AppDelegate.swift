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
import RealmSwift
import GooglePlaces

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
        
        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: 1,
            
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if (oldSchemaVersion < 1) {
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                }
        })
        
        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config
        
        //AIzaSyDDy1IxnyQcuuWPmqWx44TxxcxGsTWuVaA
        GMSServices.provideAPIKey("AIzaSyDDy1IxnyQcuuWPmqWx44TxxcxGsTWuVaA")
        GMSPlacesClient.provideAPIKey("AIzaSyDDy1IxnyQcuuWPmqWx44TxxcxGsTWuVaA")
        
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

