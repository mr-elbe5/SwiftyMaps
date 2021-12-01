/*
 SwiftyMaps
 App for display and use of OSM maps without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import UIKit

class InfoViewController: PopupScrollViewController {
    
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
        
        // user location
        stackView.addArrangedSubview(IconInfoText(icon: "record.circle", text: "userLocationInfoText".localize(), iconColor: UserLocationView.userLocationColor))
        // map location
        stackView.addArrangedSubview(IconInfoText(icon: "mappin", text: "locationMarkerInfoText".localize(), iconColor: LocationPinView.defaultPinColor))
        stackView.addArrangedSubview(IconInfoText(icon: "mappin", text: "locationPhotoMarkerInfoText".localize(), iconColor: LocationPinView.photoPinColor))
        stackView.addArrangedSubview(IconInfoText(icon: "mappin.and.ellipse", text: "locationTrackMarkerInfoText".localize(), iconColor: LocationPinView.defaultPinColor))
        stackView.addArrangedSubview(IconInfoText(icon: "mappin.and.ellipse", text: "locationPhotoTrackMarkerInfoText".localize(), iconColor: LocationPinView.photoPinColor))
        stackView.addArrangedSubview(TextLabel(text: "locationDetailsInfoText".localize(), insetLeft: subInset))
        // map menu
        stackView.addArrangedSubview(IconInfoText(icon: "map", text: "mapMenuInfoText".localize()))
        stackView.addArrangedSubview(IconInfoText(icon: "square.and.arrow.down", text: "preloadIconInfoText".localize(),leftInset: subInset))
        stackView.addArrangedSubview(IconInfoText(icon: "trash", text: "deleteTilesInfoText".localize(), iconColor: .red, leftInset: subInset))
        // location menu
        stackView.addArrangedSubview(IconInfoText(icon: "mappin.and.ellipse", text: "locationMenuInfoText".localize()))
        stackView.addArrangedSubview(IconInfoText(icon: "plus.circle", text: "locationIconInfoText".localize(),leftInset: subInset))
        stackView.addArrangedSubview(TextLabel(text: "addLocationInfoText".localize(), insetLeft: subInset))
        stackView.addArrangedSubview(IconInfoText(icon: "list.bullet", text: "locationListInfoText".localize(), leftInset: subInset))
        stackView.addArrangedSubview(IconInfoText(icon: "mappin", text: "showLocationsInfoText".localize(), leftInset: subInset))
        stackView.addArrangedSubview(IconInfoText(icon: "mappin.slash", text: "hideLocationsInfoText".localize(), leftInset: subInset))
        stackView.addArrangedSubview(IconInfoText(icon: "trash", text: "deleteLocationsInfoText".localize(), iconColor: .red, leftInset: subInset))
        // track menu
        stackView.addArrangedSubview(IconInfoText(icon: "figure.walk", text: "trackMenuInfoText".localize()))
        stackView.addArrangedSubview(IconInfoText(icon: "figure.walk", text: "startTrackInfoText".localize(), leftInset: subInset))
        stackView.addArrangedSubview(TextLabel(text: "startTrackLocationInfoText".localize(), insetLeft: subInset))
        stackView.addArrangedSubview(IconInfoText(icon: "figure.walk", text: "currentTrackInfoText".localize(), iconColor: .green, leftInset: subInset))
        stackView.addArrangedSubview(IconInfoText(icon: "eye.slash", text: "hideTrackInfoText".localize(), leftInset: subInset))
        stackView.addArrangedSubview(IconInfoText(icon: "list.bullet", text: "trackListInfoText".localize(), leftInset: subInset))
        stackView.addArrangedSubview(IconInfoText(icon: "trash", text: "deleteTracksInfoText".localize(), iconColor: .red, leftInset: subInset))
        // center
        stackView.addArrangedSubview(IconInfoText(icon: "record.circle", text: "centerIconInfoText".localize()))
        // camera
        stackView.addArrangedSubview(IconInfoText(icon: "camera", text: "cameraIconInfoText".localize()))
        stackView.addArrangedSubview(TextLabel(text: "addPhotoLocationInfoText".localize()))
        // preferences
        stackView.addArrangedSubview(IconInfoText(icon: "gearshape", text: "gearIconInfoText".localize()))
        // info
        stackView.addArrangedSubview(IconInfoText(icon: "info.circle", text: "infoIconInfoText".localize()))
        
        // info for location detail
        stackView.addArrangedSubview(HeaderLabel(text: "locationDetailInfoHeader".localize()))
        stackView.addArrangedSubview(IconInfoText(icon: "photo", text: "locationDetailImageInfoText".localize()))
        stackView.addArrangedSubview(IconInfoText(icon: "trash", text: "locationDetailTrashInfoText".localize(), iconColor: .red))
        stackView.addArrangedSubview(IconInfoText(icon: "pencil.circle", text: "locationDetailPencilInfoText".localize()))
        stackView.addArrangedSubview(TextLabel(text: "locationDetailEditInfoText".localize()))
        stackView.addArrangedSubview(IconInfoText(icon: "square.and.arrow.up", text: "locationDetailShareImageInfo".localize(), iconColor: .blue, leftInset: subInset))
        stackView.addArrangedSubview(IconInfoText(icon: "magnifyingglass", text: "locationDetailViewImageInfo".localize(), iconColor: .blue, leftInset: subInset))
        // info for track detail
        stackView.addArrangedSubview(HeaderLabel(text: "trackDetailInfoHeader".localize()))
        // info for preload
        stackView.addArrangedSubview(HeaderLabel(text: "tilePreloadInfoHeader".localize()))
        stackView.addArrangedSubview(TextLabel(text: "preloadInfoText".localize()))
        // info for location list
        stackView.addArrangedSubview(HeaderLabel(text: "locationListInfoHeader".localize()))
        stackView.addArrangedSubview(IconInfoText(icon: "pencil.circle", text: "locationListPencilInfoText".localize()))
        stackView.addArrangedSubview(IconInfoText(icon: "mappin", text: "locationListPinInfoText".localize()))
        stackView.addArrangedSubview(IconInfoText(icon: "magnifyingglass", text: "locationListViewInfoText".localize()))
        stackView.addArrangedSubview(TextLabel(text: "locationListEditInfoText".localize(), insetLeft: subInset))
        // info for track list
        stackView.addArrangedSubview(HeaderLabel(text: "trackListInfoHeader".localize()))
        stackView.addArrangedSubview(IconInfoText(icon: "pencil.circle", text: "trackListPencilInfoText".localize()))
        stackView.addArrangedSubview(IconInfoText(icon: "mappin", text: "trackListPinInfoText".localize()))
        stackView.addArrangedSubview(IconInfoText(icon: "magnifyingglass", text: "trackListViewInfoText".localize()))
        stackView.addArrangedSubview(TextLabel(text: "trackListEditInfoText".localize()))
        // info for preferences
        stackView.addArrangedSubview(HeaderLabel(text: "preferencesInfoHeader".localize()))
        stackView.addArrangedSubview(TextLabel(text: "urlInfoText".localize()))
    }
    
}
