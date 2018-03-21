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
        return UIImage(named: name)
    }
    
    public static var SPLASH_SCREEN_ICON = Icons.icon("splash_screen_lens")
    
    // Main View Icons
    public static var IMAGE_FILTER_24 = Icons.icon("ic_image_filter_hdr_24dp")
    public static var IMAGE_FILTER_36 = Icons.icon("ic_image_filter_hdr_36dp")
    public static var IMAGE_FILTER_48 = Icons.icon("ic_image_filter_hdr_48dp")
    
    public static var SEARCH_24 = Icons.icon("ic_magnify_24dp")
    public static var SEARCH_36 = Icons.icon("ic_magnify_36dp")
    public static var SEARCH_48 = Icons.icon("ic_magnify_48dp")
    
    public static var NOTIFICATIONS_24 = Icons.icon("ic_bell_24dp")
    public static var NOTIFICATIONS_36 = Icons.icon("ic_bell_36dp")
    public static var NOTIFICATIONS_48 = Icons.icon("ic_bell_48dp")
    
    public static var MORE_HORIZONTAL_LINES_24 = Icons.icon("ic_dehaze")
    
    // Post Icons
    public static var LIKE_OUTLINE_24 = Icons.icon("ic_heart_outline_24dp")
    public static var LIKE_OUTLINE_36 = Icons.icon("ic_heart_outline_36dp")
    public static var LIKE_OUTLINE_48 = Icons.icon("ic_heart_outline_48dp")
    
    public static var LIKE_FILL_24 = Icons.icon("ic_heart_24dp")
    public static var LIKE_FILL_36 = Icons.icon("ic_heart_36dp")
    public static var LIKE_FILL_48 = Icons.icon("ic_heart_48dp")
    
    public static var MORE_VERTICAL_DOTS_24 = Icons.icon("ic_dots_vertical_24dp")
    public static var MORE_VERTICAL_DOTS_36 = Icons.icon("ic_dots_vertical_36dp")
    public static var MORE_VERTICAL_DOTS_48 = Icons.icon("ic_dots_vertical_48dp")
    
    // Default Profile Pictures
    public static var DEFAULT_PROFILE_PIC_0_LOW = Icons.icon("default_prof_0_low")
    public static var DEFAULT_PROFILE_PIC_1_LOW = Icons.icon("default_prof_1_low")
    public static var DEFAULT_PROFILE_PIC_2_LOW = Icons.icon("default_prof_2_low")
    public static var DEFAULT_PROFILE_PIC_3_LOW = Icons.icon("default_prof_3_low")
    public static var DEFAULT_PROFILE_PIC_4_LOW = Icons.icon("default_prof_4_low")
    public static var DEFAULT_PROFILE_PIC_5_LOW = Icons.icon("default_prof_5_low")
    public static var DEFAULT_PROFILE_PIC_6_LOW = Icons.icon("default_prof_6_low")
    public static var DEFAULT_PROFILE_PIC_7_LOW = Icons.icon("default_prof_7_low")
    public static var DEFAULT_PROFILE_PIC_8_LOW = Icons.icon("default_prof_8_low")
    public static var DEFAULT_PROFILE_PIC_9_LOW = Icons.icon("default_prof_9_low")
    public static var DEFAULT_PROFILE_PIC_0_HI = Icons.icon("default_prof_0_hi")
    public static var DEFAULT_PROFILE_PIC_1_HI = Icons.icon("default_prof_1_hi")
    public static var DEFAULT_PROFILE_PIC_2_HI = Icons.icon("default_prof_2_hi")
    public static var DEFAULT_PROFILE_PIC_3_HI = Icons.icon("default_prof_3_hi")
    public static var DEFAULT_PROFILE_PIC_4_HI = Icons.icon("default_prof_4_hi")
    public static var DEFAULT_PROFILE_PIC_5_HI = Icons.icon("default_prof_5_hi")
    public static var DEFAULT_PROFILE_PIC_6_HI = Icons.icon("default_prof_6_hi")
    public static var DEFAULT_PROFILE_PIC_7_HI = Icons.icon("default_prof_7_hi")
    public static var DEFAULT_PROFILE_PIC_8_HI = Icons.icon("default_prof_8_hi")
    public static var DEFAULT_PROFILE_PIC_9_HI = Icons.icon("default_prof_9_hi")
    
}

