//
//  AppDelegate.swift
//  ELIOSAutoTest
//
//  Created by EVGENII Loshchenko on 14.07.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

//    var sr = SignalRService(url: URL(string: "http://localhost:5075/hubs/clock")!)
    
    static var shared: AppDelegate!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        AppDelegate.shared = self
//        myTest()
        _ = IOSAutotestMessageManager.manager
        return true
    }
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    func myTest() {
        let json =
"""
{\"testId\":\"3f579e9397bb4e2591bf17858664197e\",\"testName\":\"run3\",\"testCaseId\":\"324ca882368c441087aeb4b801ed1c88\",\"testCaseName\":\"page1\",\"testRunId\":\"0dee48eb555d4960b9dfaf32d97f1d61\",\"hideBackButton\":true,\"rotation\":1,\"screenBase64\":\"\",\"deviceId\":null,\"deviceModel\":\"iPhone8,1\",\"lang\":\"ru\",\"viewControllerName\":\"RootViewController\",\"viewControllerStateDataJson\":\"{}\",\"applicationStateDataJson\":null,\"passed\":false}
"""
        
        let corrected = json.replacingOccurrences(of: "\n", with: "", options: .literal, range: nil)
//        var problemJson = String(bytes: corrected.base64DecodedBytes!, encoding: .utf8)!
        print("part1")
        let object = try! JSONDecoder().decode(TestScreenData.self, from: Data(corrected.utf8))
        print(object )
    }
}
