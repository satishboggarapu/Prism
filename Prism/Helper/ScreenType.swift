//
//  ScreenType.swift
//  CustomLoginScreen
//
//  Created by Satish Boggarapu on 2/20/18.
//  Copyright © 2018 Satish Boggarapu. All rights reserved.
//

import Foundation
import UIKit

public enum ScreenType {
    case iPhoneSE_1136
    case iPhoneNormal_1334
    case iPhonePlus_1920
    case iPhoneX_2436
    
    case iPadPro9_2048
    case iPadPro10_1668
    case iPadPro12_2732
    
    static var screenType: ScreenType? {
        switch UIScreen.main.nativeBounds.height {
        case 1136:
            return .iPhoneSE_1136
        case 1334:
            return .iPhoneNormal_1334
        case 1920:
            return .iPhonePlus_1920
        case 2436:
            return .iPhoneX_2436
        case 2048:
            return .iPadPro9_2048
        case 1668:
            return .iPadPro10_1668
        case 2732:
            return .iPadPro12_2732
        default:
            return nil
        }
    }
    
}
