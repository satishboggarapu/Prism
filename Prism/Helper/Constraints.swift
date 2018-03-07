//
//  Constraints.swift
//  Prism
//
//  Created by Satish Boggarapu on 2/24/18.
//  Copyright © 2018 Satish Boggarapu. All rights reserved.
//

import Foundation
import UIKit

public class Constraints {
    
    static public func screenWidth() -> CGFloat {
        return UIScreen.main.bounds.width
    }
    
    static public func screenHeight() -> CGFloat {
        return UIScreen.main.bounds.height
    }
    
    static public func statusBarHeight() -> CGFloat {
        return UIApplication.shared.statusBarFrame.size.height
    }

    static  public func navigationBarHeight() -> CGFloat {
        return 44.0
    }
    
    public class LoginViewController {
        
        static public func getIconSize() -> CGSize {
            let size: CGFloat = UIScreen.main.bounds.width * 0.65
            return CGSize(width: size, height: size)
        }
        
        static public func getIconFrame() -> CGRect {
            let width: CGFloat = UIScreen.main.bounds.width * 0.5
            let x: CGFloat = (UIScreen.main.bounds.width - width) / 2
            let y: CGFloat = 50
            let position = CGRect(x: x, y: y, width: width, height: width)
            return position
        }
        
        static public func getIconPosition() -> CGPoint {
            let frame: CGRect = getIconFrame()
            let x: CGFloat = frame.origin.x + (frame.height/2)
            let y: CGFloat = frame.origin.y + (frame.height/2)
            return CGPoint(x: x, y: y)
        }
        
        static public func getRegisterButtonYOffset() -> CGFloat {
            switch ScreenType.screenType {
            case .iPhoneX_2436?:
                return 24
            default:
                return 12
            }
        }
    }
    
    public class RegisterViewController {
        
        static public func getIconFrame() -> CGRect {
            let width: CGFloat = UIScreen.main.bounds.width * 0.35
            let x: CGFloat = (UIScreen.main.bounds.width - width) / 2
            let y: CGFloat = 50
            let position = CGRect(x: x, y: y, width: width, height: width)
            return position
        }
        
        static public func getAlreadyMemberButtonYOffset() -> CGFloat {
            switch ScreenType.screenType {
            case .iPhoneX_2436?:
                return 24
            default:
                return 10
            }
        }
    }
}
