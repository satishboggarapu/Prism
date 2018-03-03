//
// Created by Satish Boggarapu on 3/3/18.
// Copyright (c) 2018 Satish Boggarapu. All rights reserved.
//

import Foundation

extension String {
    var isAlpha: Bool {
        return !isEmpty && range(of: "[^a-zA-Z]", options: .regularExpression) == nil
    }
}
extension String {
    var isNumeric: Bool {
        return !isEmpty && range(of: "[^0-9]", options: .regularExpression) == nil
    }
}