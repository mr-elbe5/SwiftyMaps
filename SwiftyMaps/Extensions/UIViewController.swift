/*
 SwiftyMaps
 App for display and use of OSM maps without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */

import UIKit

extension UIViewController{
    
    var defaultInset : CGFloat{
        get{
            return Insets.defaultInset
        }
    }
    
    var defaultInsets : UIEdgeInsets{
        get{
            return Insets.defaultInsets
        }
    }
    
    var doubleInsets : UIEdgeInsets{
        get{
            return Insets.doubleInsets
        }
    }
    
    var flatInsets : UIEdgeInsets{
        get{
            return Insets.flatInsets
        }
    }
    
    var narrowInsets : UIEdgeInsets{
        get{
            return Insets.narrowInsets
        }
    }
    
    var isDarkMode: Bool {
        return self.traitCollection.userInterfaceStyle == .dark
    }
    
    func showAlert(title: String, text: String, onOk: (() -> Void)? = nil){
        let alertController = UIAlertController(title: title, message: text, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "ok".localize(),style: .default) { action in
            onOk?()
        })
        self.present(alertController, animated: true)
    }
    
    func showApprove(title: String, text: String, onApprove: (() -> Void)? = nil){
        let alertController = UIAlertController(title: title, message: text, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "yes".localize(), style: .destructive) { action in
            onApprove?()
        })
        alertController.addAction(UIAlertAction(title: "no".localize(), style: .cancel))
        self.present(alertController, animated: true)
    }
    
}

