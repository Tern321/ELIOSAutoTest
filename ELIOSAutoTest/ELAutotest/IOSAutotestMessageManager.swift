//
//  IOSMessageManager.swift
//  SocketClient
//
//  Created by EVGENII Loshchenko on 16.07.2022.
//

import UIKit

class IOSAutotestMessageManager: AutotestTransportServiceDelegate {
    
    var sr = SignalRService(url: URL(string: "http://localhost:5091/hubs/clock")!)
    
    static let manager: IOSAutotestMessageManager = {
            return  IOSAutotestMessageManager()
        }()
    
    var testsToRun: [TestScreenData] = []
    var timer: Timer?
    
    @objc func runTestCycle() {
        DispatchQueue.main.async {
            if !self.testsToRun.isEmpty {
                print("run test case \(self.testsToRun)")
                self.runTestCaseWithStateJson(testInfo: self.testsToRun.removeFirst())
            }
        }
    }
    
    init() {
        sr.delegate = self
        runTestCycle()
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(runTestCycle), userInfo: nil, repeats: true)
    }
    
    func showTestErrorAlert(className: String) {
        let alert = UIAlertController(title: "Testing is not supported", message: "getVCModel not implemented for \(className)", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        ATUtils.visibleViewController()?.present(alert, animated: true, completion: nil)
    }
    
    func getGlobalAppStateJson() -> String {
        var globalStateMap = [String: String]()
        
        let globalClasses = RuntimeExplorer.classes(conformToProtocol: ELAutotestModelObject.self)
        for obj in globalClasses {
            globalStateMap["\(obj)"] = obj.self.getStateModelJson()
        }
        return globalStateMap.toJson() ?? ""
    }
    
    func loadGlobalAppStateJson(json: String) {
        if let dataJson = json.data(using: .utf8) {
            // swiftlint:disable all
            let globalStateMap: [String: String] = try! JSONDecoder().decode([String: String].self, from: dataJson)
            // swiftlint:enable all
            let globalClasses = RuntimeExplorer.classes(conformToProtocol: ELAutotestModelObject.self)
            for obj in globalClasses {
                obj.loadStateStateObject(json: globalStateMap["\(obj)"])
            }
        }
    }

    func runTestCase(testInfo: TestScreenData) {
        ELTestableViewController.testModeDisabled = false
        print("gotSharedMessage RunTestCase \(String(describing: testInfo.testName))")
        testsToRun.append(testInfo)
    }
    
    func collectTestData( testInfo: TestScreenData) -> TestScreenData {
        let data = ELTestableViewController.captureScreenshot()! // let it fall
        let VCModelJson = (ATUtils.visibleViewController() as? ELTestableViewControllerModelProtocol)?.getModelJson()
        
        if VCModelJson == nil {
//                showTestErrorAlert(className: String(describing: type(of: ATUtils.vissibleViewController())))
        }
        testInfo.viewControllerName = ATUtils.visibleViewControllerName()
        testInfo.rotation = UIDevice.current.orientation.rawValue
        testInfo.screenBase64 = data.base64EncodedString()
        testInfo.deviceModel = ATUtils.modelIdentifier()
        testInfo.viewControllerStateDataJson = VCModelJson?.data(using: .utf8)?.prettyUtf8LogString ?? ""
        testInfo.applicationStateDataJson = getGlobalAppStateJson().data(using: .utf8)?.prettyUtf8LogString ?? ""
        testInfo.lang = Locale.current.languageCode ?? ""
        testInfo.hideBackButton = ATUtils.visibleViewController()?.navigationController?.navigationBar.backItem == nil

        return testInfo
    }
    
    func pushTestedViewController(testedViewController: UIViewController, hideBackButton: Bool) {
        let currentViewController = UIWindow.key?.rootViewController as? UINavigationController
        currentViewController?.navigationController?.navigationItem.hidesBackButton = hideBackButton
        currentViewController?.popToRootViewController(animated: false)
        currentViewController?.pushViewController(testedViewController, animated: false)
        if hideBackButton {
            testedViewController.navigationItem.setHidesBackButton(true, animated: false)
        }
    }
    func runTestCaseWithStateJsonSwiftUI() {
        
    }
    func runTestCaseWithStateJson(testInfo: TestScreenData) {
        
        // swiftlint:disable all
        print("runTestCaseWithState \(testInfo.testName ?? "no test name")")
        let testedViewControllerClass = NSClassFromString("ELIOSAutoTest." + testInfo.viewControllerName!) as! ELTestableViewController.Type
        // swiftlint:enable all
        let testedViewController = testedViewControllerClass.loadViewControllerFromXib()

        loadGlobalAppStateJson(json: testInfo.applicationStateDataJson ?? "")
        UIDevice.current.setValue(testInfo.rotation, forKey: "orientation")
        testedViewController.loadModelJson(json: testInfo.viewControllerStateDataJson ?? "{}")
        pushTestedViewController(testedViewController: testedViewController, hideBackButton: testInfo.hideBackButton)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let data = ELTestableViewController.captureScreenshot()! // let it fall
            testInfo.screenBase64 = data.base64EncodedString()
            testInfo.rotation = UIDevice.current.orientation.rawValue
            testInfo.deviceModel = ATUtils.modelIdentifier()
            testInfo.viewControllerStateDataJson = "{}"
            testInfo.lang = Locale.current.languageCode ?? ""
            
            self.sr.sendRunTestCaseResponse(testInfo: testInfo)
        }
    }
}
