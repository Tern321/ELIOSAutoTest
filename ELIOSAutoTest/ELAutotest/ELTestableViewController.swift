//
//  ELTestableViewController.swift
//  ELIOSAutoTest
//
//  Created by EVGENII Loshchenko on 24.07.2022.
//

import UIKit

protocol ELTestableViewControllerP {
    
}
extension UIViewController {
    static func loadViewControllerFromXib() -> Self {
        let identifier = "\(Self.self)"
        return Self(nibName: identifier, bundle: nil)
    }
}

class ELTestableViewControllerState: Codable {
    
}

class ELTestableViewController: UIViewController {

    var state = ELTestableViewControllerState()
    
    
    func getCurrentStateJson() -> String {
        return ""
    }
    func loadCurrentStateJson(json: String) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func getStateData() {
    }
    
    static func captureScreenshot() -> Data {
        let layer = UIApplication.shared.keyWindow!.layer
        let scale = UIScreen.main.scale
        // Creates UIImage of same size as view
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        var data = screenshot?.jpegData(compressionQuality: 0.5)
        return data!
    }

}

extension UIViewController {
    func topMostViewController() -> UIViewController {
        if self.presentedViewController == nil {
            return self
        }
        if let navigation = self.presentedViewController as? UINavigationController {
            return navigation.visibleViewController!.topMostViewController()
        }
        if let tab = self.presentedViewController as? UITabBarController {
            if let selectedTab = tab.selectedViewController {
                return selectedTab.topMostViewController()
            }
            return tab.topMostViewController()
        }
        return self.presentedViewController!.topMostViewController()
    }
}

extension UIApplication {
    func topMostViewController() -> UIViewController? {
        return UIWindow.key!.rootViewController?.topMostViewController()
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
