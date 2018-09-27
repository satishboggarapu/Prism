//
//  NotificationViewController.swift
//  Prism
//
//  Created by Satish Boggarapu on 9/26/18.
//  Copyright © 2018 Satish Boggarapu. All rights reserved.
//

import UIKit

class NotificationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.loginBackground
        
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.barTintColor = .statusBarBackground
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.isOpaque = false
        navigationItem.setHidesBackButton(true, animated: false)
        navigationController?.hidesBarsOnSwipe = true
        
        let navigationView = NavigationView()
        navigationView.frame = CGRect(x: 0, y: 0, width: 100, height: 44)
        
        let signOutButton = UIBarButtonItem(title: "SignOut", style: .done, target: self, action: nil)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: navigationView)
        navigationItem.rightBarButtonItem = signOutButton
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
