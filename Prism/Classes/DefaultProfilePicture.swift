//
//  DefaultProfilePicture.swift
//  Prism
//
//  Created by Satish Boggarapu on 3/18/18.
//  Copyright © 2018 Satish Boggarapu. All rights reserved.
//

import UIKit

public enum DefaultProfilePicture {
    struct picture {
        var lowResPicture: UIImage!
        var hiResPicture: UIImage!
    }
    static func getProfilePicture(index: Int) -> picture {
        let picture0 = picture(lowResPicture: Images.DEFAULT_PROFILE_PIC_0_LOW, hiResPicture: Images.DEFAULT_PROFILE_PIC_0_HI)
        let picture1 = picture(lowResPicture: Images.DEFAULT_PROFILE_PIC_1_LOW, hiResPicture: Images.DEFAULT_PROFILE_PIC_1_HI)
        let picture2 = picture(lowResPicture: Images.DEFAULT_PROFILE_PIC_2_LOW, hiResPicture: Images.DEFAULT_PROFILE_PIC_2_HI)
        let picture3 = picture(lowResPicture: Images.DEFAULT_PROFILE_PIC_3_LOW, hiResPicture: Images.DEFAULT_PROFILE_PIC_3_HI)
        let picture4 = picture(lowResPicture: Images.DEFAULT_PROFILE_PIC_4_LOW, hiResPicture: Images.DEFAULT_PROFILE_PIC_4_HI)
        let picture5 = picture(lowResPicture: Images.DEFAULT_PROFILE_PIC_5_LOW, hiResPicture: Images.DEFAULT_PROFILE_PIC_5_HI)
        let picture6 = picture(lowResPicture: Images.DEFAULT_PROFILE_PIC_6_LOW, hiResPicture: Images.DEFAULT_PROFILE_PIC_6_HI)
        let picture7 = picture(lowResPicture: Images.DEFAULT_PROFILE_PIC_7_LOW, hiResPicture: Images.DEFAULT_PROFILE_PIC_7_HI)
        let picture8 = picture(lowResPicture: Images.DEFAULT_PROFILE_PIC_8_LOW, hiResPicture: Images.DEFAULT_PROFILE_PIC_8_HI)
        let picture9 = picture(lowResPicture: Images.DEFAULT_PROFILE_PIC_9_LOW, hiResPicture: Images.DEFAULT_PROFILE_PIC_9_HI)
        let values: [picture] = [picture0, picture1, picture2, picture3, picture4, picture5, picture6, picture7, picture8, picture9]
        return values[index]
    }
}

