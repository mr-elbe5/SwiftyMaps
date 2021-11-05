//
//  ControlView.swift
//
//  Created by Michael Rönnau on 04.08.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation

import UIKit

class ButtonStackView: UIView{
    
    var stackView = UIStackView()
    
    func setupView(){
        addSubview(stackView)
        stackView.setupHorizontal(spacing: defaultInset)
        stackView.setAnchors(top: topAnchor, leading: nil, trailing: trailingAnchor, bottom: nil, insets: Insets.defaultInsets)
    }
    
}

