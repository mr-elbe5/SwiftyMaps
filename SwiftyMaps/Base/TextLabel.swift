//
//  InfoText.swift
//
//  Created by Michael Rönnau on 12.08.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation

import UIKit

class TextLabel : UIView{
    
    let label = UILabel()
    
    init(text: String, insetLeft: CGFloat = 0){
        super.init(frame: .zero)
        label.text = text
        label.numberOfLines = 0
        label.textColor = .label
        addSubview(label)
        label.fillView(view: self, insets: insetLeft == 0 ? defaultInsets : UIEdgeInsets(top: defaultInset, left: defaultInset + insetLeft, bottom: defaultInset, right: defaultInset))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

