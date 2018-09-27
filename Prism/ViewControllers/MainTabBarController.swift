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
        setupTabBarViewControllers()
        setupTabBar()
    }
    
    /*
     *  Initializes tabBar attributes
     */
    private func setupTabBar() {
        tabBar.barTintColor = .statusBarBackground
        tabBar.barStyle = .black
        tabBar.isOpaque = false
        tabBar.unselectedItemTintColor = .white
    }
    
    /*
     *  Initializes all the view controller for the controller.
     */
    private func setupTabBarViewControllers() {
        let imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        let feedTabBarItem = UITabBarItem(title: nil, image: Icons.IMAGE_FILTER_24, tag: 0)
        feedTabBarItem.imageInsets = imageInsets
        let discoveryTabBarItem = UITabBarItem(title: nil, image: Icons.SEARCH_24, tag: 1)
        discoveryTabBarItem.imageInsets = imageInsets
        let notificationTabBarItem = UITabBarItem(title: nil, image: Icons.NOTIFICATIONS_24, tag: 2)
        notificationTabBarItem.imageInsets = imageInsets
        let settingTabBarItem = UITabBarItem(title: nil, image: Icons.MORE_HORIZONTAL_LINES_24, tag: 3)
        settingTabBarItem.imageInsets = imageInsets
        
        let feedViewController = FeedViewController()
        feedViewController.tabBarItem = feedTabBarItem
        
        let discoveryViewController = DiscoveryViewController()
        discoveryViewController.tabBarItem = discoveryTabBarItem
        
        let notificationViewController = NotificationViewController()
        notificationViewController.tabBarItem = notificationTabBarItem
        
        let settingViewController = SettingViewController()
        settingViewController.tabBarItem = settingTabBarItem
        
        let tabBarList = [feedViewController, discoveryViewController, notificationViewController, settingViewController]
//        viewControllers = tabBarList
        viewControllers = tabBarList.map { UINavigationController(rootViewController: $0)}
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
