/*
 SwiftyMaps
 App for display and use of OSM maps without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */

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

