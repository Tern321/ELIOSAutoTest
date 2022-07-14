//
//  SceneDelegate.swift
//  ELIOSAutoTest
//
//  Created by EVGENII Loshchenko on 14.07.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    static var shared: SceneDelegate!
    
    var navigationController: UINavigationController!
    var rootViewCotroller: RootViewController!
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        SceneDelegate.shared = self
        rootViewCotroller = RootViewController(nibName: "RootViewController", bundle: nil)
        self.navigationController = UINavigationController(rootViewController: rootViewCotroller)
        window?.rootViewController = self.navigationController
        
        window?.makeKeyAndVisible()
    }
}
