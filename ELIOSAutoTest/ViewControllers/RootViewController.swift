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
//    @IBOutlet var text: UILabel!
    
    static var shared: RootViewController?
    var testObjcObj = ObjcTestClass()
    var manager = IOSAutotestMessageManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.start()
        RootViewController.shared = self
        
        //
        var testedViewControllerClass = NSClassFromString("ELIOSAutoTest.SecondViewController")
//        var testedViewController = testedViewControllerClass.loadViewControllerFromXib() as! ELTestableViewController
        print(testedViewControllerClass)
    }
    @IBAction func secondVk() {
        self.navigationController?.pushViewController(SecondViewController.loadViewControllerFromXib(), animated: false)
        
    }
    @IBAction func test() {
//        var data = captureScreenshot()
//        var testInfo = TestScreenData()
//        testInfo.rotation = "v"
        
        
        
//        testInfo.screenBase64 = data.base64EncodedString()
//        testInfo.testName = "test1"
        
        
//        manager.sendSharedMessage(message: testInfo.ToJson())
        
    }
    func showData() {
        var a = UIApplication.shared.windows.count
        print(a)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //        

    }
    
    
    
}
