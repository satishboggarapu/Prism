//
//  DictionaryExtensions.swift
//  Prism
//
//  Created by Satish Boggarapu on 3/20/18.
//  Copyright © 2018 Satish Boggarapu. All rights reserved.
//

import Foundation

extension Dictionary {
    mutating func update(other:Dictionary) {
        for (key,value) in other {
            self.updateValue(value, forKey:key)
        }
    }
}

extension Array {
    mutating func removeObject<T>(_ object: T) where T : Equatable {
        self = self.filter({$0 as? T != object})
    }
    
}
