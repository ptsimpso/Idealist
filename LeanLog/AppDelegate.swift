//
//  AppDelegate.swift
//  LeanLog
//
//  Created by Peter Simpson on 2/26/15.
//  Copyright (c) 2015 Pete Simpson. All rights reserved.
//

import UIKit
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    override class func initialize() -> Void {
        iRate.sharedInstance().applicationName = "Idealist"
        iRate.sharedInstance().remindPeriod = 3
        iRate.sharedInstance().promptAtLaunch = false
        iRate.sharedInstance().useUIAlertControllerIfAvailable = true
        // Enable iRate preview mode
        // iRate.sharedInstance().previewMode = true
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Initialize Parse.
        Parse.setApplicationId("lcqPSVVFETGbyRqDafsoOILbBg3ZIR1bV2vAAyqI", clientKey: "NPpHYUKU3paEYReqw7ZIfWAmEO6NbzdecT7pVq9h")
        PFAnalytics.trackAppOpenedWithLaunchOptionsInBackground(launchOptions, block:nil)
        PFPurchase.addObserverForProduct("me.petersimpson.idealist.unlimited", block: { (transaction:SKPaymentTransaction!) -> Void in
            Branch.getInstance().userCompletedAction("completed_purchase")
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "unlimited")
            NSUserDefaults.standardUserDefaults().synchronize()
            let alertView = UIAlertView(title: "Success!", message: "You can now create unlimited ideas.", delegate: nil, cancelButtonTitle: "Ok")
            alertView.show()
        })
        
        Branch.getInstance().initSessionWithLaunchOptions(launchOptions, andRegisterDeepLinkHandler: { (params, error) -> Void in
            // code
        })
        
        // Dev: DEV5501FD63B8E0DCD3A50217441B4
        // Live: 5501FD63B7A89F3F5EC7B8524EBFB0
        #if DEBUG
            Batch.startWithAPIKey("DEV5501FD63B8E0DCD3A50217441B4")
        #else
            Batch.startWithAPIKey("5501FD63B7A89F3F5EC7B8524EBFB0")
        #endif
        
        Crashlytics.startWithAPIKey("b78d43f1d70460b77b2d36657656524e3275e3e6")
        
        // Override point for customization after application launch.
        window?.tintColor = UIColor(red: 68/255.0, green: 188/255.0, blue: 201/255.0, alpha: 1.0)
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        if Branch.getInstance().handleDeepLink(url) {
            return true
        }
        return true
    }

}

