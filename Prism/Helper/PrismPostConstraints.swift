//
// Created by Satish Boggarapu on 4/5/18.
// Copyright (c) 2018 Satish Boggarapu. All rights reserved.
//

import Foundation
import UIKit

public enum PrismPostConstraints: CGFloat {
    case DEFAULT_MARGIN = 8
    case TOP_MARGIN = 16
    case PROFILE_PICTURE_HEIGHT = 48
    case HEART_IMAGEVIEW_HEIGHT = 100
    case BUTTON_HEIGHT = 28
    case DIVIDER_HEIGHT = 1
    case IMAGE_MAX_HEIGHT_RATIO = 0.65
    case IMAGE_MAX_WIDTH_RATIO = 0.925

    static var IMAGE_MAX_HEIGHT: CGFloat {
        return Constraints.screenHeight() * PrismPostConstraints.IMAGE_MAX_HEIGHT_RATIO.rawValue
    }

    static var IMAGE_MAX_WIDTH: CGFloat {
        return Constraints.screenWidth() * PrismPostConstraints.IMAGE_MAX_WIDTH_RATIO.rawValue
    }

    static var LEFT_MARGIN: CGFloat {
        return Constraints.screenWidth() * ((1 - PrismPostConstraints.IMAGE_MAX_WIDTH_RATIO.rawValue)/2)
    }

    static var CELL_HEIGHT_WITHOUT_POST_IMAGE: CGFloat {
        return PrismPostConstraints.TOP_MARGIN.rawValue + PrismPostConstraints.PROFILE_PICTURE_HEIGHT.rawValue +
                PrismPostConstraints.DEFAULT_MARGIN.rawValue + PrismPostConstraints.DEFAULT_MARGIN.rawValue +
                PrismPostConstraints.BUTTON_HEIGHT.rawValue + PrismPostConstraints.TOP_MARGIN.rawValue +
                PrismPostConstraints.DIVIDER_HEIGHT.rawValue
    }
}
