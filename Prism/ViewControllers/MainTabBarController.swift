//
//  MainTabBarController.swift
//  Prism
//
//  Created by Satish Boggarapu on 9/26/18.
//  Copyright © 2018 Satish Boggarapu. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let feedViewController = FeedViewController()
        feedViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .featured, tag: 0)
        
        let discoveryViewController = DiscoveryViewController()
        discoveryViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 1)
        
        let notificationViewController = NotificationViewController()
        notificationViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .history, tag: 2)
        
        let settingViewController = SettingViewController()
        settingViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .more, tag: 3)
        
        let tabBarList = [feedViewController, discoveryViewController, notificationViewController, settingViewController]
        viewControllers = tabBarList
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
