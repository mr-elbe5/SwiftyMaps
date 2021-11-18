//
//  AppInfoViewController.swift
//  myprivatetrack
//
//  Created by Michael Rönnau on 03.09.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

class InfoViewController: PopupViewController {
    
    var stackView = UIStackView()
    
    override func loadView() {
        title = "Info"
        super.loadView()
        contentView.addSubview(stackView)
        stackView.fillView(view: contentView, insets: UIEdgeInsets(top: Insets.defaultInset, left: .zero, bottom: Insets.defaultInset, right: .zero))
        stackView.setupVertical()
        stackView.addArrangedSubview(HeaderLabel(text: "appInfoHeader".localize()))
        stackView.addArrangedSubview(TextLabel(text: "appInfoText".localize()))
        stackView.addArrangedSubview(HeaderLabel(text: "appIconsHeader".localize()))
        stackView.addArrangedSubview(IconInfoText(icon: "map", text: "mapIconInfoText".localize()))
        
    }
    
}
