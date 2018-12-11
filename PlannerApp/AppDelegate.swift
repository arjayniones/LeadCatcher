//
//  AppDelegate.swift
//  PlannerApp
//
//  Created by Alkuino Robert John Matias on 06/09/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import UIKit
import SnapKit
import UserNotifications
import GoogleMaps
import RealmSwift
import GooglePlaces
import CallKit
import SwiftyUserDefaults
import IQKeyboardManagerSwift
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate {

    var window: UIWindow?
    var callObServer:CXCallObserver!;

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true;
        callObServer = CXCallObserver();
        callObServer.setDelegate(self, queue: DispatchQueue.main);

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

        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if !launchedBefore  {
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            Defaults[.NeedOnboarding] = true
        }

        prepareAndExecute() {
            self.window?.rootViewController = BaseViewController()
        }

        return true
    }

    private func prepareAndExecute(fn: () -> ()) {
        self.window = UIWindow(frame: UIScreen.main.bounds)

        self.window?.backgroundColor = .white

//        SessionService.onLogout(performAlways: true) {
//            self.window?.rootViewController?.present(LoginViewController(), animated: true, completion: nil)
//        }

        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            // version control
            schemaVersion: 4,

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
        Fabric.with([Crashlytics.self])

        if Defaults[.NeedOnboarding] == true {
            self.window?.rootViewController = OnboardingInfoViewController()
        } else {
            fn()
        }

        self.window?.makeKeyAndVisible()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let actionIdentifier = response.actionIdentifier
        let content = response.notification.request.content

        switch actionIdentifier {
        case UNNotificationDismissActionIdentifier: // Notification was dismissed by user

            let realm = RealmStore<AddNote>()

            let data = realm.models(query: "id = '\(content.userInfo["id"]!)'")?.first
            try! realm.write {
                data?.status = "unread"
            }

            completionHandler()
        case UNNotificationDefaultActionIdentifier: // App was opened from notification

            let realm = RealmStore<AddNote>()

            let data = realm.models(query: "id = '\(content.userInfo["id"]!)'")?.first
            try! realm.write {
                data?.status = "unread"
            }

            completionHandler()
        default:
            completionHandler()
        }
    }

    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        let realm = RealmStore<AddNote>()

        let data = realm.models(query: "id = '\(notification.request.content.userInfo["id"]!)'")?.first
        try! realm.write {
            data?.status = "unread"
        }

        completionHandler([.alert,.sound,.badge])
    }

}

extension AppDelegate:CXCallObserverDelegate
{
    func callObserver(_ callObserver: CXCallObserver, callChanged call: CXCall) {
        if call.hasEnded == true {
            // user hang up the phone
            print("Disconnected")
            if (ContactViewModel.insertDataContactHistoryModel(cID: Defaults[.ContactID]!, cHistoryType: "Call"))
            {

            }

        }
        if call.isOutgoing == true && call.hasConnected == false {
            print("azlim Dialing")
        }
        if call.isOutgoing == false && call.hasConnected == false && call.hasEnded == false {
            print("azlim Incoming")
        }

        if call.hasConnected == true && call.hasEnded == false {
            // user pick up phone call
            print("azlim Connected")
        }
    }
}
