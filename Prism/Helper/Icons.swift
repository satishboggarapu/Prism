//
//  Icons.swift
//  Prism
//
//  Created by Satish Boggarapu on 2/25/18.
//  Copyright © 2018 Satish Boggarapu. All rights reserved.
//

import Foundation
import UIKit

public enum Icons: String {
    
    case SPLASH_SCREEN_ICON = "splash_screen_lens"
}

//extension Icons {
//    var image: UIImage {
//        return UIImage(named: self.rawValue)
//    }
//}

extension UIImage {
    convenience init(icon: Icons) {
        self.init(named: icon.rawValue)!
    }
}
