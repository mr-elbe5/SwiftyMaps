/*
 SwiftyMaps
 App for display and use of OSM maps without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import UIKit

class InfoViewController: PopupViewController {
    
    var stackView = UIStackView()
    
    var subInset : CGFloat = 40
    
    override func loadView() {
        title = "Info"
        super.loadView()
        contentView.addSubview(stackView)
        stackView.fillView(view: contentView, insets: UIEdgeInsets(top: defaultInset, left: .zero, bottom: defaultInset, right: .zero))
        stackView.setupVertical()
        
        stackView.addArrangedSubview(HeaderLabel(text: "appInfoHeader".localize()))
        stackView.addArrangedSubview(TextLabel(text: "appInfoText".localize()))
        
        stackView.addArrangedSubview(HeaderLabel(text: "appIconsHeader".localize()))
        
        stackView.addArrangedSubview(IconInfoText(icon: "record.circle", text: "userLocationInfoText".localize(), iconColor: UserLocationView.userLocationColor))
        
        stackView.addArrangedSubview(IconInfoText(image: "mappin", text: "locationMarkerInfoText".localize()))
        stackView.addArrangedSubview(IconInfoText(image: "mappin.track", text: "locationMarkerInfoText".localize()))
        stackView.addArrangedSubview(IconInfoText(image: "mappin.photo", text: "locationMarkerInfoText".localize()))
        stackView.addArrangedSubview(IconInfoText(image: "mappin.track.photo", text: "locationMarkerInfoText".localize()))
        stackView.addArrangedSubview(TextLabel(text: "showDetails".localize() + ": " + "locationDetailsInfoText".localize(), insetLeft: subInset))
        stackView.addArrangedSubview(TextLabel(text: "edit".localize() + ": " + "locationEditInfoText".localize(), insetLeft: subInset))
        stackView.addArrangedSubview(TextLabel(text: "delete".localize() + ": " + "locationDeleteInfoText".localize(), insetLeft: subInset))
        
        stackView.addArrangedSubview(IconInfoText(icon: "map", text: "mapIconInfoText".localize()))
        
        stackView.addArrangedSubview(IconInfoText(icon: "arrow.down.square", text: "preloadIconInfoText".localize()))
        stackView.addArrangedSubview(IconInfoText(icon: "12.square", text: "zoomIconInfoText".localize()))
        
        stackView.addArrangedSubview(IconInfoText(icon: "record.circle", text: "centerIconInfoText".localize()))
        
        stackView.addArrangedSubview(IconInfoText(icon: "gearshape", text: "gearIconInfoText".localize()))
        stackView.addArrangedSubview(TextLabel(text: "urlInfoText".localize(), insetLeft: subInset))
        stackView.addArrangedSubview(TextLabel(text: "deleteLocations".localize() + ": " + "deleteLocationsInfoText".localize(), insetLeft: subInset))
        stackView.addArrangedSubview(TextLabel(text: "clearTileCache".localize() + ": " + "deleteTilesInfoText".localize(), insetLeft: subInset))
        
        stackView.addArrangedSubview(IconInfoText(icon: "info.circle", text: "infoIconInfoText".localize()))
        
        stackView.addArrangedSubview(IconInfoText(icon: "camera", text: "cameraIconInfoText".localize()))
        stackView.addArrangedSubview(TextLabel(text: "addLocationInfoText".localize(), insetLeft: subInset))
        
        stackView.addArrangedSubview(IconInfoText(icon: "mappin.and.ellipse", text: "pinIconInfoText".localize()))
        stackView.addArrangedSubview(IconInfoText(icon: "circle.slash", text: "noPinIconInfoText".localize()))
        
        stackView.addArrangedSubview(IconInfoText(icon: "figure.walk", text: "trackIconInfoText".localize()))
    }
    
}
