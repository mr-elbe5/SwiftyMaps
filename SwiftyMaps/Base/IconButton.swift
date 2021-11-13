//
//  IconButton.swift
//
//  Created by Michael Rönnau on 07.08.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation

import UIKit

class IconButton : UIButton{
    
    init(icon: String, tintColor: UIColor = .darkGray){
        super.init(frame: .zero)
        setImage(UIImage(systemName: icon), for: .normal)
        self.tintColor = tintColor
        self.setTitleColor(tintColor, for: .normal)
        self.scaleBy(1.25)
    }
    
    init(image: String, titleColor: UIColor = .darkGray){
        super.init(frame: .zero)
        setImage(UIImage(named: image), for: .normal)
        self.setTitleColor(titleColor, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

