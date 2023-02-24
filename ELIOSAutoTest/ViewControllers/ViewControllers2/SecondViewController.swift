//
//  SecondViewController.swift
//  ELIOSAutoTest
//
//  Created by EVGENII Loshchenko on 23.07.2022.
//

import UIKit

@MainActor
class SecondViewController: ELTestableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func test() {
    }
    
    @MainActor
    func testCall() {
        DispatchQueue.main.async {
            print("testCall")
        }
    }
}
