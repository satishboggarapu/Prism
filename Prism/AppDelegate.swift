//
//  AppDelegate.swift
//  Prism
//
//  Created by Satish Boggarapu on 2/21/18.
//  Copyright © 2018 Satish Boggarapu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SDWebImage

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
//        SDImageCache.shared().clearMemory()
        SDImageCache.shared().clearDisk(onCompletion: {
            print("cleared disk")
        })
//        CachedImages.clearCache() { (result) in
//            print("cleared cache")
//        }

        self.window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()

        UINavigationBar.appearance().barTintColor = UIColor.statusBarBackground

        // get rid of black bar underneath navbar
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)

        application.statusBarStyle = .lightContent

        let statusBarBackgroundView = UIView()
        statusBarBackgroundView.backgroundColor = UIColor.statusBarBackground

        window?.addSubview(statusBarBackgroundView)
        window?.addConstraintsWithFormat(format: "H:|[v0]|", views: statusBarBackgroundView)
        window?.addConstraintsWithFormat(format: "V:|[v0(20)]", views: statusBarBackgroundView)

        // rootViewController from StoryBoard
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = mainStoryboard.instantiateViewController(withIdentifier: "splashScreenViewController")

        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "loginViewController")
        self.window!.rootViewController = navigationController
        navigationController.view.backgroundColor = UIColor(hex: 0x2b2b2b)

        let iconImageView = UIImageView(image: Icons.SPLASH_SCREEN_ICON)
        iconImageView.bounds.origin = CGPoint(x: 0, y: 0)
        iconImageView.bounds.size = Constraints.LoginViewController.getIconSize()
        iconImageView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        iconImageView.layer.position = CGPoint(x: navigationController.view.frame.width/2, y: navigationController.view.frame.height/2)
        navigationController.view.addSubview(iconImageView)

        // Icon rotation animation for the splash screen
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            // seque to the LoginViewController
            self.window!.rootViewController! = UINavigationController(rootViewController: viewController)
        })
        let rotationAnimation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = NSNumber(value: .pi * 2.0)
        rotationAnimation.duration = 0.75;
        rotationAnimation.beginTime = CACurrentMediaTime() + 0.1
        rotationAnimation.isCumulative = true;
        rotationAnimation.repeatCount = 1;
        rotationAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        iconImageView.layer.add(rotationAnimation, forKey: "rotationAnimation")
        CATransaction.commit()
        
        return true
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
        SDImageCache.shared().clearMemory()
        SDImageCache.shared().clearDisk()
//        CachedImages.clearCache()
        print("cache cleared")
    }


}

