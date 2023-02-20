import UIKit

extension UIViewController {
    
    var topbarHeight: CGFloat {
        if #available(iOS 13.0, *) {
            return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
        } else {
            let topBarHeight = UIApplication.shared.statusBarFrame.size.height +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
            return topBarHeight
        }
    }
    
    func addSwipeBackGesture() {
        let swipeBack = UISwipeGestureRecognizer(target: self, action: #selector(popViewController))
        swipeBack.direction = .right
        self.view.addGestureRecognizer(swipeBack)
    }
    
    @objc
    public func popViewController() {
        navigationController?.popViewController(animated: true)
    }
    
    static func loadViewControllerFromXib() -> Self {
        let identifier = "\(Self.self)"
        return Self(nibName: identifier, bundle: nil)
    }

}
