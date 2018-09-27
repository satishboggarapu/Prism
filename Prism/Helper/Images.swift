//
// Created by Satish Boggarapu on 9/27/18.
// Copyright (c) 2018 Satish Boggarapu. All rights reserved.
//

import UIKit
public struct Images {

    /// Get the icon by the file name.
    public static func image(_ name: String) -> UIImage? {
        return UIImage(named: name)
    }

    public static var SPLASH_SCREEN_ICON = Images.image("splash_screen_lens")

    // Default Profile Pictures
    public static var DEFAULT_PROFILE_PIC_0_LOW = Images.image("default_prof_0_low")
    public static var DEFAULT_PROFILE_PIC_1_LOW = Images.image("default_prof_1_low")
    public static var DEFAULT_PROFILE_PIC_2_LOW = Images.image("default_prof_2_low")
    public static var DEFAULT_PROFILE_PIC_3_LOW = Images.image("default_prof_3_low")
    public static var DEFAULT_PROFILE_PIC_4_LOW = Images.image("default_prof_4_low")
    public static var DEFAULT_PROFILE_PIC_5_LOW = Images.image("default_prof_5_low")
    public static var DEFAULT_PROFILE_PIC_6_LOW = Images.image("default_prof_6_low")
    public static var DEFAULT_PROFILE_PIC_7_LOW = Images.image("default_prof_7_low")
    public static var DEFAULT_PROFILE_PIC_8_LOW = Images.image("default_prof_8_low")
    public static var DEFAULT_PROFILE_PIC_9_LOW = Images.image("default_prof_9_low")
    public static var DEFAULT_PROFILE_PIC_0_HI = Images.image("default_prof_0_hi")
    public static var DEFAULT_PROFILE_PIC_1_HI = Images.image("default_prof_1_hi")
    public static var DEFAULT_PROFILE_PIC_2_HI = Images.image("default_prof_2_hi")
    public static var DEFAULT_PROFILE_PIC_3_HI = Images.image("default_prof_3_hi")
    public static var DEFAULT_PROFILE_PIC_4_HI = Images.image("default_prof_4_hi")
    public static var DEFAULT_PROFILE_PIC_5_HI = Images.image("default_prof_5_hi")
    public static var DEFAULT_PROFILE_PIC_6_HI = Images.image("default_prof_6_hi")
    public static var DEFAULT_PROFILE_PIC_7_HI = Images.image("default_prof_7_hi")
    public static var DEFAULT_PROFILE_PIC_8_HI = Images.image("default_prof_8_hi")
    public static var DEFAULT_PROFILE_PIC_9_HI = Images.image("default_prof_9_hi")

}
