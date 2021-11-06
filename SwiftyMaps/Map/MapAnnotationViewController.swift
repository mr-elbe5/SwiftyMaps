//
//  MapAnnotationViewController.swift
//  SwiftyMaps
//
//  Created by Michael Rönnau on 06.11.21.
//

import Foundation
import UIKit

class MapAnnotationViewController: ScrollViewController{
    
    var stackView = UIStackView()
    
    override func loadView() {
        super.loadView()
        scrollView.setupVertical()
        scrollView.addSubview(stackView)
        stackView.fillView(view: scrollView, insets: UIEdgeInsets(top: Insets.defaultInset, left: .zero, bottom: Insets.defaultInset, right: .zero))
        stackView.setupVertical()
        scrollChild = stackView
        setupKeyboard()
    }
    
    override func setupHeaderView(){
        setupCloseHeader()
    }
    
}
