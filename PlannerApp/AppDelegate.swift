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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
//        let data = SampleModel()
//        data.username = "Alkuino"
//        data.id = uuid()
//        data.created_at = Date().toRFC3339String()
//        data.updated_at = Date().toRFC3339String()
//
//        let data2 = SampleModel2()
//        data2.id = uuid()
//        data.created_at = Date().toRFC3339String()
//        data.updated_at = Date().toRFC3339String()
//        data2.username = "robertjohn"
//        data2.lastname = "robertjohn"
//
//        data.lastname.append(data2)
//
//        RealmStore.add(model: data)
        
//        if let update = RealmStore.model(type: SampleModel.self, id: "1234fdfa") {
//            try! RealmStore.write {
//                update.username = "sample"
//            }
//        }
        
        prepareAndExecute() {
            
            self.window?.rootViewController = BaseViewController()
        }
        
        return true
    }
    
    private func prepareAndExecute(fn: () -> ()) {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        window?.backgroundColor = .white
        
        SessionService.onLogout(performAlways: true) { self.window?.rootViewController = LoginViewController() }

        if SessionService.isLoggedIn {
            fn()
        } else {
            window?.rootViewController = LoginViewController()
        }
        
        window?.makeKeyAndVisible()
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

