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

    // Main View Icons
    case IMAGE_FILTER_24 = "ic_image_filter_hdr_24dp"
    case IMAGE_FILTER_36 = "ic_image_filter_hdr_36dp"
    case IMAGE_FILTER_48 = "ic_image_filter_hdr_48dp"

    case SEARCH_24 = "ic_magnify_24dp"
    case SEARCH_36 = "ic_magnify_36dp"
    case SEARCH_48 = "ic_magnify_48dp"

    case NOTIFICATIONS_24 = "ic_bell_24dp"
    case NOTIFICATIONS_36 = "ic_bell_36dp"
    case NOTIFICATIONS_48 = "ic_bell_48dp"

    case MORE_HORIZONTAL_LINES_24 = "ic_dehaze"

    // Post Icons
    case LIKE_OUTLINE_24 = "ic_heart_outline_24dp"
    case LIKE_OUTLINE_36 = "ic_heart_outline_36dp"
    case LIKE_OUTLINE_48 = "ic_heart_outline_48dp"

    case LIKE_FILL_24 = "ic_heart_24dp"
    case LIKE_FILL_36 = "ic_heart_36dp"
    case LIKE_FILL_48 = "ic_heart_48dp"

    case MORE_VERTICAL_DOTS_24 = "ic_dots_vertical_24dp"
    case MORE_VERTICAL_DOTS_36 = "ic_dots_vertical_36dp"
    case MORE_VERTICAL_DOTS_48 = "ic_dots_vertical_48dp"
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
