//
//  DispatchQueue+Extensions.swift
//  ELIOSAutoTest
//
//  Created by EVGENII Loshchenko on 24.02.2023.
//

import UIKit

extension DispatchQueue {
    static let background: DispatchQueue = DispatchQueue.global(qos: .background)
}
