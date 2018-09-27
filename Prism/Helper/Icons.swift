//
//  Icons.swift
//  Prism
//
//  Created by Satish Boggarapu on 2/25/18.
//  Copyright © 2018 Satish Boggarapu. All rights reserved.
//

import Foundation
import UIKit

public struct Icons {
    
    /// Get the icon by the file name.
    public static func icon(_ name: String) -> UIImage? {
        return UIImage(named: name)?.withRenderingMode(.alwaysTemplate)
    }

    // TabBar Icons
    public static var IMAGE_FILTER_24 = Icons.icon("ic_image_filter_hdr_24dp")
    public static var SEARCH_24 = Icons.icon("ic_magnify_24dp")
    public static var NOTIFICATIONS_24 = Icons.icon("ic_bell_24dp")
    public static var MORE_HORIZONTAL_LINES_24 = Icons.icon("ic_dehaze")
    
    // Post Icons
    public static var LIKE_OUTLINE_36 = Icons.icon("ic_heart_outline_36dp")
    public static var LIKE_FILL_36 = Icons.icon("ic_heart_36dp")
    public static var LIKE_HEART = Icons.icon("like_heart_128dp")
    public static var UNLIKE_HEART = Icons.icon("unlike_heart_128dp")
    public static var REPOST_24 = Icons.icon("ic_camera_iris_24dp")
    public static var REPOST_36 = Icons.icon("ic_camera_iris_36dp")
    public static var MORE_VERTICAL_DOTS_24 = Icons.icon("ic_dots_vertical_24dp")
    public static var MORE_VERTICAL_DOTS_36 = Icons.icon("ic_dots_vertical_36dp")

    public static var ARROW_BACK_24 = Icons.icon("ic_arrow_back_white")
    public static var ACCOUNT_EDIT_24 = Icons.icon("ic_account_edit_24dp")
    public static var PLUS_24 = Icons.icon("ic_plus_24dp")
    public static var IMAGE_24 = Icons.icon("ic_image_24dp")
    public static var CAMERA_24 = Icons.icon("ic_camera_24dp")
    
    // Icons for Settings Page
    public static var SETTINGS_24 = Icons.icon("ic_settings_24dp")
    public static var ACCOUNT_SETTINGS_24 = Icons.icon("ic_account_settings_variant_24dp")
    public static var HELP_24 = Icons.icon("ic_help_24dp")
    public static var ABOUT_24 = Icons.icon("ic_about_24dp")
    public static var LOGOUT_24 = Icons.icon("ic_logout_24dp")
}

