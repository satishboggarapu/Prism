//
// Created by Satish Boggarapu on 3/3/18.
// Copyright (c) 2018 Satish Boggarapu. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {

    func addStatusBarViewWithBackground(_ color: UIColor) {
        let statusBarBackground = UIView()
        statusBarBackground.backgroundColor = color
        self.view.addSubview(statusBarBackground)

        // constraints for the status bar
        self.view.addConstraintsWithFormat(format: "H:|[v0]|", views: statusBarBackground)
        self.view.addConstraintsWithFormat(format: "V:|[v0(\(Constraints.statusBarHeight()))]", views: statusBarBackground)
    }

}