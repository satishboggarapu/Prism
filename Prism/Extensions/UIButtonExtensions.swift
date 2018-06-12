//
//  UIButtonExtensions.swift
//  Prism
//
//  Created by Satish Boggarapu on 6/7/18.
//  Copyright © 2018 Satish Boggarapu. All rights reserved.
//

import UIKit

extension UIButton {
    
    /*
     * Sets the inset value all around the button.
     */
    func addContentEdgeInset(_ value: CGFloat) {
        self.contentEdgeInsets = UIEdgeInsets(top: value, left: value, bottom: value, right: value)
    }
    
}
