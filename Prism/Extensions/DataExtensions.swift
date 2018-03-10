//
//  DataExtensions.swift
//  Prism
//
//  Created by Shiv Shah on 3/10/18.
//  Copyright © 2018 Satish Boggarapu. All rights reserved.
//

import Foundation


extension Date {
    func toMillis() -> Int64! {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}
