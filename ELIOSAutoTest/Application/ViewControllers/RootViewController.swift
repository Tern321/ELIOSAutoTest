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
//import "ObjcTestClass.h"

class PropertyTestContainer: NSObject { // view objects container
    @IBOutlet var button1: UIButton!
    // <outlet property="textField" destination="emp-yC-9Ze_xib_id" id="T2t-XX-mkW_connectionId"/>
    //
    @IBOutlet var textField: UITextField! = UITextField() // id="T2t-XX-mkW_connectionId" // на каждый обьект генерируется этот id, и далее xib обновляется, при сборке
}

class RootViewController: ELTestableViewController {
    
    @IBOutlet var modelStateLabel: UILabel!
    @IBOutlet var viewControllerStateLabel: UILabel!
    @IBOutlet var textField: UITextField!
    @IBOutlet var robotPicture: UIImageView!
    
    @IBOutlet var button1: UIButton!
    
    @IBOutlet weak var testLabel: UILabel!
    @objc dynamic var name: String?
    
    @objc dynamic var someTestString: String = "someText"
    
    static var shared: RootViewController?
    
    @IBOutlet var pc: PropertyTestContainer! = PropertyTestContainer()
    
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
        
        var notif = MyLocalNotification()
        notif.send()
        
        Task {
            print("sended")
            var sended = await notif.readNotifications()
            print(sended)
        }
        
        ObjcTestClass.start(self)
//        print(pc.button1)
        
        
//        do {
//            let data = Data(base64Encoded: TestConstants.runTestBase64Json)!
//            let testRun = try? JSONDecoder().decode(ELTestRun.self, from: data)
//            print(testRun)
//            
//            IOSAutotestMessageManager.manager.runTestCase(testRun!)
//        } catch {
//            
//        }
        print("test")
        
//        RootViewController.shared = self
//        self.robotPicture.image = Asset.robot.image
//
//        let delay = 1.0
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
//            print("main.asyncAfter")
//
//            self.view.gestureRecognizers?.first!.state = .ended
//
//            print(self.robotPicture.image?.size)
////            self.button1.sendActions(for: .touchUpInside)
//
//            self.textField.sendActions(for: .touchUpInside)
            
            // for bottun working
//            self.button1.sendActions(for: .touchUpInside)
//        })
        
//        DispatchQueue.background.asyncAfter(deadline: .now() + 1.5, execute: {
//            print("background.asyncAfter")
//
//        })
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
