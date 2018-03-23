//
//  SDWebImageHelper.swift
//  Prism
//
//  Created by Satish Boggarapu on 3/21/18.
//  Copyright © 2018 Satish Boggarapu. All rights reserved.
//

import Foundation
import SDWebImage

public class SDWebImageHelper {
    
    private static let imageCache = SDImageCache()
    
    public static func isImageInCache(key: String) -> Bool {
        return imageCache.diskImageDataExists(withKey: key)
    }
    
    
}
