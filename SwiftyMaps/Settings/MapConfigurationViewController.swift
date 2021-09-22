//
//  MapConfigurationViewController.swift
//  SwiftyMaps
//
//  Created by Michael Rönnau on 20.09.21.
//

import Foundation
import UIKit
import SwiftyIOSViewExtensions

class MapConfigurationViewController: ScrollViewController, UINavigationControllerDelegate{
    
    var stackView = UIStackView()
    
    override func loadView() {
        super.loadView()
        scrollView.setupVertical()
        scrollView.addSubview(stackView)
        stackView.fillSuperview(insets: UIEdgeInsets(top: defaultInset, left: .zero, bottom: defaultInset, right: .zero))
        stackView.setupVertical()
        scrollChild = stackView
        setupKeyboard()
        
        let btn = IconButton(icon: "gearshape")
        btn.addTarget(self, action: #selector(dumpIcons), for: .touchDown)
        stackView.addArrangedSubview(btn)
    }
    
    override open func setupHeaderView(){
        setupCloseHeader()
    }
    
    @objc func dumpIcons(){
        MapCache.instance.dumpTiles()
    }
    
}
