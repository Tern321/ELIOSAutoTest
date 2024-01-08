//
//  IOSMessageManager.swift
//  SocketClient
//
//  Created by EVGENII Loshchenko on 16.07.2022.
//

import UIKit


class IOSAutotestMessageManager: AutotestTransportServiceDelegate, TestableWindowDelegate, ELButtonPressDetectorDelegage {
    
    var window: UIWindow?
    
    var recordTestData: TestCaseData?
    
    func hitEvent(_ point: CGPoint, view: UIView?) {
        print("TestableWindow hitTest \(point)")
        print("hitObject \(view)")
        let event = AutotestEvent()
        event.setPoint(point)
        event.eventType = IOSAutotestEventType.click.rawValue
        self.recordTestData?.autotestEvents?.append(event)
    }
    
    var sr = SignalRService(url: URL(string: "http://localhost:5091/hubs/clock")!)
    
    static let manager: IOSAutotestMessageManager = {
        return  IOSAutotestMessageManager()
    }()
    
    var currentTestCase: StandardTestCaseData?
    var testRunData: ELTestRun?
    //    var testCasesToRun: [StandardTestCaseData] = []
    
    var timer: Timer?
    
    func runEvent(_ event: AutotestEvent) {
        
        if event.eventType == IOSAutotestEventType.click.rawValue {
            var hitTestView = UIWindow.key?.hitTest(event.getCGPoint()!, with: nil)
            
            print(hitTestView)
            if let hutButton = hitTestView as? UIButton {
                hutButton.sendActions(for: .touchUpInside)
            }
        }
        if event.eventType == IOSAutotestEventType.screenshot.rawValue {
            
            var responseData = TestRunEventResult()
            responseData.autotestEventId = event.autotestEventId
            responseData.screenBase64 = ELTestableViewController.captureScreenshot()!.base64EncodedString()
            responseData.rotation = UIDevice.current.orientation.rawValue
            responseData.deviceModel = ATUtils.modelIdentifier()
            responseData.lang = Locale.current.languageCode ?? ""
            
            responseData.testId = testRunData?.testId
            responseData.testRunId = testRunData?.testRunId
            responseData.standardTestCaseDataId = currentTestCase?.standardTestCaseDataId
            
            responseData.OS = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
            responseData.deviceId = SignalRService.deviceId
            
            sr.testRunEventResponse(responseData)
        }
    }
    
    @objc func runTestCycle() {
        DispatchQueue.main.async {
            if self.currentTestCase == nil {
                self.currentTestCase = self.testRunData?.testCases?.popLast()
                self.currentTestCase?.autotestEvents.reverse()
                // load test case state
                if self.currentTestCase != nil {
                    self.runTestCaseWithStateJson()
                }
            }
            
            if self.currentTestCase != nil {
                //                var
                if let event = self.currentTestCase?.autotestEvents.popLast() {
                    self.runEvent(event)
                }
                
            }
        }
    }
    
    func volumeChanged(_ value: Float) {
        print("volumeChanged")
        //        if self.testModeDisabled
        var customView = UIView()
        
        customView.frame = CGRect.init(x: 0, y: 0, width: 100, height: 200)
        customView.backgroundColor = UIColor.black     //give color to the view
        //           customView.center = self.view.center
        
        
        let currentViewController = UIWindow.key?.rootViewController as? UINavigationController
        currentViewController?.view.addSubview(customView)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            customView.removeFromSuperview()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.addRecordingScreenshot()
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
    
    func runTestCase(_ testRunData: ELTestRun) {
        ELTestableViewController.testModeDisabled = false
        testRunData.testCases?.reverse()
        self.testRunData = testRunData
    }
    //
    func collectTestData(_ testInfo: TestCaseData) -> TestCaseData {
        //        testInfo.setupData = TestSetupData()
        
        let VCModelJson = (ATUtils.visibleViewController() as? ELTestableViewControllerModelProtocol)?.getModelJson()
        
        if VCModelJson == nil {
            //                showTestErrorAlert(className: String(describing: type(of: ATUtils.vissibleViewController())))
        }
        //        testInfo
        testInfo.viewControllerName = ATUtils.visibleViewControllerName()
        
        //        testInfo.screenBase64 = data.base64EncodedString()
        testInfo.deviceModel = ATUtils.modelIdentifier()
        testInfo.OS = UIDevice.current.systemVersion
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
    func runTestCaseWithStateJson() {
        //        // swiftlint:disable all
        
        print("runTestCaseWithState \(self.currentTestCase?.testCaseName ?? "no test name")")
        let testedViewControllerClass = NSClassFromString("ELIOSAutoTest." + (self.currentTestCase?.viewControllerName ?? "")) as! ELTestableViewController.Type
        // swiftlint:enable all
        let testedViewController = testedViewControllerClass.loadViewControllerFromXib()
        
        loadGlobalAppStateJson(json: self.currentTestCase?.applicationStateDataJson ?? "")
        UIDevice.current.setValue(self.currentTestCase?.rotation, forKey: "orientation")
        testedViewController.loadModelJson(json: self.currentTestCase?.viewControllerStateDataJson ?? "{}")
        pushTestedViewController(testedViewController: testedViewController, hideBackButton: self.recordTestData?.hideBackButton ?? true)
    }
    //
    //        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
    //            let data = ELTestableViewController.captureScreenshot()! // let it fall
    //            testInfo.screenBase64 = data.base64EncodedString()
    //            testInfo.rotation = UIDevice.current.orientation.rawValue
    //            testInfo.deviceModel = ATUtils.modelIdentifier()
    //            testInfo.viewControllerStateDataJson = "{}"
    //            testInfo.lang = Locale.current.languageCode ?? ""
    //
    //            self.sr.sendRunTestCaseResponse(testInfo: testInfo)
    //        }
    //}
    
    //    func runTestCaseWithStateJson(testInfo: AutotestSetupData) {
    //
    //            // swiftlint:disable all
    //            print("runTestCaseWithState \(testInfo.testName ?? "no test name")")
    //            let testedViewControllerClass = NSClassFromString("ELIOSAutoTest." + testInfo.viewControllerName!) as! ELTestableViewController.Type
    //            // swiftlint:enable all
    //            let testedViewController = testedViewControllerClass.loadViewControllerFromXib()
    //
    //            loadGlobalAppStateJson(json: testInfo.applicationStateDataJson ?? "")
    //            UIDevice.current.setValue(testInfo.rotation, forKey: "orientation")
    //            testedViewController.loadModelJson(json: testInfo.viewControllerStateDataJson ?? "{}")
    //            pushTestedViewController(testedViewController: testedViewController, hideBackButton: testInfo.hideBackButton)
    //
    //            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
    //                let data = ELTestableViewController.captureScreenshot()! // let it fall
    //                testInfo.screenBase64 = data.base64EncodedString()
    //                testInfo.rotation = UIDevice.current.orientation.rawValue
    //                testInfo.deviceModel = ATUtils.modelIdentifier()
    //                testInfo.viewControllerStateDataJson = "{}"
    //                testInfo.lang = Locale.current.languageCode ?? ""
    //
    //                self.sr.sendRunTestCaseResponse(testInfo: testInfo)
    //            }
    //    }
    
    func startRecording(_ setupData: TestCaseData) {
        self.recordTestData = self.collectTestData(setupData)
        
        print("\(self.recordTestData?.toJson())")
        self.recordTestData?.autotestEvents = []
        ELButtonPressDetector.addRetainedListener(self)
        
    }
    
    func createScreenshotData() -> TestScreenshotData {
        let screenshotData = TestScreenshotData()
        screenshotData.screenBase64 = ELTestableViewController.captureScreenshot()!.base64EncodedString()
        screenshotData.rotation = UIDevice.current.orientation.rawValue
        return screenshotData
    }
    
    func addRecordingScreenshot() {
        let event = AutotestEvent()
        event.eventType = IOSAutotestEventType.screenshot.rawValue
        var screenshot = createScreenshotData()
        event.screenBase64 = screenshot.screenBase64
        event.rotation = screenshot.rotation
        self.recordTestData?.autotestEvents?.append(event)
    }
    
    func endRecording() -> TestCaseData {
        ELButtonPressDetector.removeListener(self)
        return self.recordTestData ?? TestCaseData()
    }
    
}

