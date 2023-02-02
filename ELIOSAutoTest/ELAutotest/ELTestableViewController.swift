//
//  ELTestableViewController.swift
//  ELIOSAutoTest
//
//  Created by EVGENII Loshchenko on 24.07.2022.
//

import UIKit

protocol ELTestableViewControllerModelProtocol {
    func getModelJson() -> String?
    func loadModelJson(json: String)
}

class ELTestableViewControllerState: Codable {

}

//extension ATListViewController: ELTestableViewControllerProtocol {
//    func modelForTest() -> Codable {
//        return model
//    }
//    func additionalData() -> Codable {
//        return model
//    }
//}

class ELTestableViewController: UIViewController, ELTestableViewControllerModelProtocol {

    static var testModeDisabled = true
    var VCState = ELTestableViewControllerState()
    
    func getStateData() {
    }
    
//    func getCurrentStateJson() -> String {
//        return "{}"
//    }
//    func loadCurrentStateJson(json: String) {
//
//    }
    func showTestErrorAlert(className: String) {
        let alert = UIAlertController(title: "Testing is not supported", message: "getVCModel not implemented for \(className)", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    func getModelJson() -> String? {
        print("getVCModel in class \(String(describing: type(of: self))) not implemented")
//        fatalError()
        
        showTestErrorAlert(className: String(describing: type(of: self)))
        return nil
    }
//    func getModelJson() -> String {
//        print("getModelJson in class \(String(describing: type(of: self))) not implemented")
//        fatalError()
//    }
    func loadModelJson(json: String) {
        print("loadModelJson in class \(String(describing: type(of: self))) not implemented")
        fatalError()
    }
    
    static func captureScreenshot() -> Data? {
        let layer = UIApplication.shared.keyWindow!.layer
        let scale = UIScreen.main.scale
        // Creates UIImage of same size as view
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let data = screenshot?.jpegData(compressionQuality: 0.5)
        return data
    }

}

extension UIViewController {
    func topMostViewController() -> UIViewController? {
        if self.presentedViewController == nil {
            return self
        }
        if let navigation = self.presentedViewController as? UINavigationController {
            return navigation.visibleViewController?.topMostViewController()
        }
        if let tab = self.presentedViewController as? UITabBarController {
            if let selectedTab = tab.selectedViewController {
                return selectedTab.topMostViewController()
            }
            return tab.topMostViewController()
        }
        return self.presentedViewController?.topMostViewController()
    }
}

extension UIApplication {
    func topMostViewController() -> UIViewController? {
        return UIWindow.key?.rootViewController?.topMostViewController()
    }
}

extension UIWindow {
    static var key: UIWindow? {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.keyWindow
        }
    }
}
