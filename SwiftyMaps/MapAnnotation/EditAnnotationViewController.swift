//
//  EditAnnotationViewController.swift
//  SwiftyMaps
//
//  Created by Michael Rönnau on 06.11.21.
//

import Foundation
import UIKit

class EditAnnotationViewController: PopupViewController{
    
    var stackView = UIStackView()
    
    var annotation: MapAnnotation? = nil
    
    override func loadView() {
        super.loadView()
        scrollView.setupVertical()
        contentView.addSubview(stackView)
        stackView.fillView(view: scrollView, insets: UIEdgeInsets(top: Insets.defaultInset, left: .zero, bottom: Insets.defaultInset, right: .zero))
        stackView.setupVertical()
        setupKeyboard()
    }
    
}
