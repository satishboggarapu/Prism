//
// Created by Satish Boggarapu on 3/3/18.
// Copyright (c) 2018 Satish Boggarapu. All rights reserved.
//

import Foundation
import UIKit

extension UIView {

    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }

        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(),
                metrics: nil, views: viewsDictionary))
    }
}