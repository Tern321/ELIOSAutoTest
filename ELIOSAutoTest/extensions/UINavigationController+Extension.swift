import UIKit

extension UINavigationController {
    
    func setTopBar(
        isEnabled: Bool,
        isTranslucent: Bool,
        barTintColor: UIColor) {
            
            if #available(iOS 13.0, *) {
                let navBarAppearance = UINavigationBarAppearance()
                navBarAppearance.configureWithOpaqueBackground()
                navBarAppearance.backgroundColor = barTintColor
                
                navigationBar.standardAppearance = navBarAppearance
                navigationBar.compactAppearance = navBarAppearance
                navigationBar.scrollEdgeAppearance = navBarAppearance
                navigationBar.isTranslucent = isTranslucent
            } else {
                // Fallback on earlier versions
                navigationBar.barTintColor = barTintColor
                navigationBar.tintColor = barTintColor
                navigationBar.isTranslucent = isTranslucent
            }
        }
}
