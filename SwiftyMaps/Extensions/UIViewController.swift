//
//  UIViewController.swift
//
//  Created by Michael Rönnau on 15.06.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import UIKit

extension UIViewController{
    
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
    
    func showDecision(title: String, text: String, onDecision: ((Bool) -> Void)? = nil){
        let alertController = UIAlertController(title: title, message: text, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "yes".localize(), style: .default) { action in
            onDecision?(true)
        })
        alertController.addAction(UIAlertAction(title: "no".localize(), style: .cancel) { action in
            onDecision?(false)
        })
        self.present(alertController, animated: true)
    }
    
    func showNegativeDecision(title: String, text: String, onDecision: ((Bool) -> Void)? = nil){
        let alertController = UIAlertController(title: title, message: text, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "no".localize(), style: .default) { action in
            onDecision?(false)
        })
        alertController.addAction(UIAlertAction(title: "yes".localize(), style: .cancel) { action in
            onDecision?(true)
        })
        self.present(alertController, animated: true)
    }
    
}

