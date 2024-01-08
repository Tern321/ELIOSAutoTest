//
//  SceneDelegate.swift
//  ELIOSAutoTest
//
//  Created by EVGENII Loshchenko on 14.07.2022.
//

import UIKit

protocol TestableWindowDelegate: AnyObject {
    func hitEvent(_ point: CGPoint, view: UIView?)
//    func hitTarget(_ point: CGPoint) -> UIView?
}

class TestableWindow: UIWindow {
    weak var testableWindowDelegate: TestableWindowDelegate?
    
    func hitTarget(_ point: CGPoint) -> UIView? {
        return self.hitTest(point, with: nil)
    }
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        var hitObject = super.hitTest(point, with: nil)
        self.testableWindowDelegate?.hitEvent(point, view: hitObject)
        return hitObject
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("TestableWindow touchesBega \(event)")
//        for val in properties {
//            print(val)
//        }
    }
              
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("TestableWindow touchesEnded")
    }
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: TestableWindow?
    
    static var shared: SceneDelegate!
    
    var navigationController: UINavigationController!
    var rootViewCotroller: RootViewController!
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = TestableWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.testableWindowDelegate = IOSAutotestMessageManager.manager
        SceneDelegate.shared = self
        rootViewCotroller = RootViewController(nibName: "RootViewController", bundle: nil)
        self.navigationController = UINavigationController(rootViewController: rootViewCotroller)
        window?.rootViewController = self.navigationController
        
        window?.makeKeyAndVisible()
    }
}
