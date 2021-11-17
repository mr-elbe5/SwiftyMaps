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
    
    let privacyHeader = HeaderLabel(text: "privacyInfoHeader".localize())
    let privacyInfoText1 = TextLabel(text: "privacyInfoText1".localize())
    let privacyInfoText2 = TextLabel(text: "privacyInfoText2".localize())
    let privacyInfoText3 = TextLabel(text: "privacyInfoText3".localize())
    let privacyInfoText4 = TextLabel(text: "privacyInfoText4".localize())
    let privacyInfoText5 = TextLabel(text: "privacyInfoText5".localize())
    let privacyInfoText6 = TextLabel(text: "privacyInfoText6".localize())
    
    override func loadView() {
        title = "Info"
        super.loadView()
        scrollView.setupVertical()
        contentView.addSubview(stackView)
        stackView.fillView(view: scrollView, insets: UIEdgeInsets(top: Insets.defaultInset, left: .zero, bottom: Insets.defaultInset, right: .zero))
        stackView.setupVertical()
        stackView.addArrangedSubview(privacyHeader)
        stackView.addArrangedSubview(privacyInfoText1)
        stackView.addArrangedSubview(privacyInfoText2)
        stackView.addArrangedSubview(privacyInfoText3)
        stackView.addArrangedSubview(privacyInfoText4)
        stackView.addArrangedSubview(privacyInfoText5)
        stackView.addArrangedSubview(privacyInfoText6)
    }
    
}
