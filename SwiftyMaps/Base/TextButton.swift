/*
 SwiftyMaps
 App for display and use of OSM maps without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation

import UIKit

class TextButton : UIButton{
    
    init(text: String, tintColor: UIColor = .systemBlue, backgroundColor: UIColor? = nil){
        super.init(frame: .zero)
        setTitle(text, for: .normal)
        setTitleColor(tintColor, for: .normal)
        self.tintColor = tintColor
        if let bgcol = backgroundColor{
            self.backgroundColor = bgcol
            layer.cornerRadius = 5
            layer.masksToBounds = true
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

