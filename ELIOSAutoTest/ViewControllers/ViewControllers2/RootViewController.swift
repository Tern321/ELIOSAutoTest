//
//  RootViewController.swift
//  ELIOSAutoTest
//
//  Created by EVGENII Loshchenko on 14.07.2022.
//

import UIKit
import MediaPlayer
import AudioToolbox

class RootViewController: ELTestableViewController {
    
    @IBOutlet var modelStateLabel: UILabel!
    @IBOutlet var viewControllerStateLabel: UILabel!
    @IBOutlet var textField: UITextField!
    @IBOutlet var robotPicture: UIImageView!
    
    @IBOutlet weak var testLabel: UILabel!
    @objc dynamic var name: String?
    
    @objc dynamic var someTestString: String = "someText"
    
    static var shared: RootViewController?
    
    override func getModelJson() -> String? {
        return "{}"
    }
    override func loadModelJson(json: String) {}

    override func viewDidLoad() {
        super.viewDidLoad()
        
        RootViewController.shared = self
        self.robotPicture.image = Asset.robot.image
        
        let delay = 1.0

        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
            print("main.asyncAfter")
        })
        
        DispatchQueue.background.asyncAfter(deadline: .now() + 1.5, execute: {
            print("background.asyncAfter")
        })
        
//        observer = self.observe(\.someTestString, options: [.new]) { (foo, change) in
//           print(change.newValue)
//        }
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
