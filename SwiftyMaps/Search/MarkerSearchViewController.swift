//
//  MarkerSearchViewController.swift
//  SwiftyMaps
//
//  Created by Michael Rönnau on 20.09.21.
//

import Foundation
import UIKit
import SwiftyIOSViewExtensions

class MarkerSearchViewController: ScrollViewController{
    
    var stackView = UIStackView()
    
    override func loadView() {
        super.loadView()
        scrollView.setupVertical()
        scrollView.addSubview(stackView)
        stackView.fillSuperview(insets: UIEdgeInsets(top: defaultInset, left: .zero, bottom: defaultInset, right: .zero))
        stackView.setupVertical()
        scrollChild = stackView
        setupKeyboard()
    }
    
    override open func setupHeaderView(){
        setupCloseHeader()
    }
    
}
