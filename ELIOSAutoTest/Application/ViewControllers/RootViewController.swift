//
//  RootViewController.swift
//  ELIOSAutoTest
//
//  Created by EVGENII Loshchenko on 14.07.2022.
//

import UIKit
import MediaPlayer
import AudioToolbox
import SwiftUI


class CustomView: UIView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        print("hitTest \(point)")
        return super.hitTest(point, with: event)
    }
}

class RootViewController: ELTestableViewController {
    
    @IBOutlet var modelStateLabel: UILabel!
    @IBOutlet var viewControllerStateLabel: UILabel!
    @IBOutlet var textField: UITextField!
    @IBOutlet var robotPicture: UIImageView!
    
    @IBOutlet weak var testLabel: UILabel!
    @objc dynamic var name: String?
    
    @objc dynamic var someTestString: String = "someText"
    
    static var shared: RootViewController?
    
    @IBAction func ShowUITestView(_ sender: Any) {
        
        let swiftUIView = UITestView() // swiftUIView is View
        let viewCtrl = UIHostingController(rootView: swiftUIView)

        self.navigationController?.pushViewController(viewCtrl, animated: true)
    }
    
    override func getModelJson() -> String? {
        return "{}"
    }
    override func loadModelJson(json: String) {}

    override func viewDidLoad() {
        super.viewDidLoad()
        ObjcTestClass.start(self)
        
        
        RootViewController.shared = self
        self.robotPicture.image = Asset.robot.image
        
        let delay = 1.0

        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
            print("main.asyncAfter")
            print(self.robotPicture.image?.size)
        })
        
        DispatchQueue.background.asyncAfter(deadline: .now() + 1.5, execute: {
            print("background.asyncAfter")
        })
    }
    
    @MainActor
    func testCall() {
        DispatchQueue.main.async {
            print("testCall")
        }
    }
    
    @IBAction func secondVk() {
        let vk = SecondViewController.loadViewControllerFromXib()
        self.navigationController?.pushViewController(vk, animated: false)
    }
    
    @IBAction func test() {
        let nextVK = ATListViewController.loadViewControllerFromXib()
        nextVK.model = ATListViewControllerModel()
        self.navigationController?.pushViewController(nextVK, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}
