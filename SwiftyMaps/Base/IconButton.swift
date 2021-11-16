//
//  IconButton.swift
//
//  Created by Michael Rönnau on 07.08.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation

import UIKit

class IconButton : UIButton{
    
    var tintCol: UIColor
    var disabledTintCol: UIColor
    
    override var isEnabled: Bool{
        get{
            super.isEnabled
        }
        set{
            super.isEnabled = newValue
            self.tintColor = isEnabled ? tintCol : disabledTintCol
        }
    }
    
    init(icon: String, tintColor: UIColor = .darkGray, disabledTintColor : UIColor = .lightGray){
        self.tintCol = tintColor
        self.disabledTintCol = disabledTintColor
        super.init(frame: .zero)
        setImage(UIImage(systemName: icon), for: .normal)
        self.tintColor = tintCol
        self.setTitleColor(tintCol, for: .normal)
        self.scaleBy(1.25)
    }
    
    init(image: String, titleColor: UIColor = .darkGray){
        self.tintCol = titleColor
        self.disabledTintCol = titleColor
        super.init(frame: .zero)
        setImage(UIImage(named: image), for: .normal)
        self.setTitleColor(titleColor, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


