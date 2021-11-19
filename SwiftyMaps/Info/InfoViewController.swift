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
    
    var subInset : CGFloat = 40
    
    override func loadView() {
        title = "Info"
        super.loadView()
        contentView.addSubview(stackView)
        stackView.fillView(view: contentView, insets: UIEdgeInsets(top: Insets.defaultInset, left: .zero, bottom: Insets.defaultInset, right: .zero))
        stackView.setupVertical()
        
        stackView.addArrangedSubview(HeaderLabel(text: "appInfoHeader".localize()))
        stackView.addArrangedSubview(TextLabel(text: "appInfoText".localize()))
        
        stackView.addArrangedSubview(HeaderLabel(text: "appIconsHeader".localize()))
        
        stackView.addArrangedSubview(IconInfoText(icon: "record.circle", text: "userLocationInfoText".localize(), iconColor: UserLocationView.userLocationColor))
        
        stackView.addArrangedSubview(IconInfoText(image: "mappin", text: "placeMarkerInfoText".localize()))
        stackView.addArrangedSubview(TextLabel(text: "showDetails".localize() + ": " + "placeDetailsInfoText".localize(), insetLeft: subInset))
        stackView.addArrangedSubview(TextLabel(text: "edit".localize() + ": " + "placeEditInfoText".localize(), insetLeft: subInset))
        stackView.addArrangedSubview(TextLabel(text: "delete".localize() + ": " + "placeDeleteInfoText".localize(), insetLeft: subInset))
        
        stackView.addArrangedSubview(IconInfoText(icon: "map", text: "mapIconInfoText".localize()))
        
        stackView.addArrangedSubview(IconInfoText(icon: "square.and.arrow.down", text: "preloadIconInfoText".localize()))
        
        stackView.addArrangedSubview(IconInfoText(icon: "record.circle", text: "centerIconInfoText".localize()))
        
        stackView.addArrangedSubview(IconInfoText(icon: "gearshape", text: "gearIconInfoText".localize()))
        stackView.addArrangedSubview(TextLabel(text: "urlInfoText".localize(), insetLeft: subInset))
        stackView.addArrangedSubview(TextLabel(text: "deletePlaces".localize() + ": " + "deletePlacesInfoText".localize(), insetLeft: subInset))
        stackView.addArrangedSubview(TextLabel(text: "clearTileCache".localize() + ": " + "deleteTilesInfoText".localize(), insetLeft: subInset))
        
        stackView.addArrangedSubview(IconInfoText(icon: "info.circle", text: "infoIconInfoText".localize()))
        
        stackView.addArrangedSubview(IconInfoText(icon: "camera", text: "cameraIconInfoText".localize()))
        stackView.addArrangedSubview(TextLabel(text: "addPlaceInfoText".localize(), insetLeft: subInset))
        
        stackView.addArrangedSubview(IconInfoText(icon: "mappin.and.ellipse", text: "pinIconInfoText".localize()))
        stackView.addArrangedSubview(IconInfoText(icon: "circle.slash", text: "noPinIconInfoText".localize()))
        
        stackView.addArrangedSubview(IconInfoText(icon: "figure.walk", text: "tourIconInfoText".localize()))
    }
    
}
