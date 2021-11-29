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
        
        stackView.addArrangedSubview(IconInfoText(icon: "mappin", text: "locationMarkerInfoText".localize(), iconColor: LocationPinView.defaultPinColor))
        stackView.addArrangedSubview(IconInfoText(icon: "mappin", text: "locationPhotoMarkerInfoText".localize(), iconColor: LocationPinView.photoPinColor))
        stackView.addArrangedSubview(IconInfoText(icon: "mappin.and.ellipse", text: "locationTrackMarkerInfoText".localize(), iconColor: LocationPinView.defaultPinColor))
        stackView.addArrangedSubview(IconInfoText(icon: "mappin.and.ellipse", text: "locationPhotoTrackMarkerInfoText".localize(), iconColor: LocationPinView.photoPinColor))
        stackView.addArrangedSubview(TextLabel(text: "locationDetailsInfoText".localize(), insetLeft: subInset))
        
        stackView.addArrangedSubview(IconInfoText(icon: "map", text: "mapMenuInfoText".localize()))
        stackView.addArrangedSubview(IconInfoText(icon: "square.and.arrow.down", text: "preloadIconInfoText".localize(),leftInset: subInset))
        stackView.addArrangedSubview(IconInfoText(icon: "trash", text: "deleteTilesInfoText".localize(), iconColor: .red, leftInset: subInset))
        
        stackView.addArrangedSubview(IconInfoText(icon: "mappin.and.ellipse", text: "pinMenuInfoText".localize()))
        stackView.addArrangedSubview(IconInfoText(icon: "plus.circle", text: "pinIconInfoText".localize(),leftInset: subInset))
        stackView.addArrangedSubview(TextLabel(text: "addLocationInfoText".localize(), insetLeft: subInset))
        
        stackView.addArrangedSubview(IconInfoText(icon: "figure.walk", text: "trackMenuInfoText".localize()))
        
        stackView.addArrangedSubview(IconInfoText(icon: "record.circle", text: "centerIconInfoText".localize()))
        
        stackView.addArrangedSubview(IconInfoText(icon: "gearshape", text: "gearIconInfoText".localize()))
        stackView.addArrangedSubview(TextLabel(text: "urlInfoText".localize(), insetLeft: subInset))
        stackView.addArrangedSubview(TextLabel(text: "deleteLocations".localize() + ": " + "deleteLocationsInfoText".localize(), insetLeft: subInset))
        
        
        stackView.addArrangedSubview(IconInfoText(icon: "info.circle", text: "infoIconInfoText".localize()))
        
        
        
        stackView.addArrangedSubview(IconInfoText(icon: "mappin.and.ellipse", text: "pinIconInfoText".localize()))
        stackView.addArrangedSubview(IconInfoText(icon: "circle.slash", text: "noPinIconInfoText".localize()))
        
        stackView.addArrangedSubview(IconInfoText(icon: "figure.walk", text: "trackIconInfoText".localize()))
        
        //
        
        stackView.addArrangedSubview(TextLabel(text: "edit".localize() + ": " + "locationEditInfoText".localize(), insetLeft: subInset))
        stackView.addArrangedSubview(TextLabel(text: "delete".localize() + ": " + "locationDeleteInfoText".localize(), insetLeft: subInset))
    }
    
}
