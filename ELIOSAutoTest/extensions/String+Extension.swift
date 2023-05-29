//
//  String+Extension.swift
//  ELIOSAutoTest
//
//  Created by jack on 28.02.2023.
//

import Foundation

extension String {
    
    // MARK: - Properties
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
