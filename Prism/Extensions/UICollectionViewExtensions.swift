//
//  UICollectionViewExtensions.swift
//  Prism
//
//  Created by Satish Boggarapu on 5/23/18.
//  Copyright © 2018 Satish Boggarapu. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    /*
     * Sets the inset value all around the collectionView.
     */
    func addContentInset(_ value: CGFloat) {
        self.contentInset = UIEdgeInsets(top: value, left: value, bottom: value, right: value)
    }
    
}
