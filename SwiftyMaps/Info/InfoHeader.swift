//
//  InfoHeader.swift
//
//  Created by Michael Rönnau on 12.08.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation

import UIKit

class InfoHeader : UIView{
    
    let label = UILabel()
    
    init(text: String, paddingTop: CGFloat = Insets.defaultInset){
        super.init(frame: .zero)
        label.text = text
        label.textColor = .label
        label.font = .preferredFont(forTextStyle: .headline)
        addSubview(label)
        label.setAnchors()
            .top(topAnchor, inset: paddingTop)
            .leading(leadingAnchor,inset: Insets.defaultInset)
            .trailing(trailingAnchor,inset: Insets.defaultInset)
            .bottom(bottomAnchor, inset: Insets.defaultInset)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

