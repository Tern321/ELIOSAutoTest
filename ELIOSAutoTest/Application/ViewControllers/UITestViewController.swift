//
//  UITestViewController.swift
//  ELIOSAutoTest
//
//  Created by jack on 28.02.2023.
//

import UIKit
//import "ObjcTestClass.h"

class UITestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        ObjcTestClass.start(self)
    }
}
