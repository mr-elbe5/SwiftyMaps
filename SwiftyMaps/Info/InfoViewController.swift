/*
 SwiftyMaps
 App for display and use of OSM maps without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import UIKit

class InfoViewController: ScrollViewController {
    
    var stackView = UIStackView()
    
    var subInset : CGFloat = 40
    
    override func loadView() {
        title = "Info"
        super.loadView()
        contentView.addSubview(stackView)
        stackView.fillView(view: contentView, insets: defaultInsets)
        stackView.setupVertical()
        
        stackView.addArrangedSubview(UILabel(header: "appInfoHeader".localize()))
        stackView.addArrangedSubview(UILabel(text: "appInfoText".localize()))
        stackView.addSpacer()
        stackView.addArrangedSubview(UILabel(header: "appIconsHeader".localize()))
        
        // user location
        stackView.addArrangedSubview(IconInfoText(icon: "record.circle", text: "userLocationInfoText".localize(), iconColor: UserLocationView.userLocationColor))
        // map location
        stackView.addArrangedSubview(IconInfoText(image: "mappin.green", text: "locationMarkerInfoText".localize()))
        stackView.addArrangedSubview(IconInfoText(image: "mappin.red", text: "locationPhotoMarkerInfoText".localize()))
        stackView.addArrangedSubview(IconInfoText(image: "mappin.blue", text: "locationTrackMarkerInfoText".localize()))
        stackView.addArrangedSubview(IconInfoText(image: "mappin.purple", text: "locationPhotoTrackMarkerInfoText".localize()))
        stackView.addArrangedSubview(UILabel(text: "locationDetailsInfoText".localize()))
        stackView.addArrangedSubview(IconInfoText(image: "mappin.group.green", text: "locationDefaultGroupInfoText".localize()))
        stackView.addArrangedSubview(IconInfoText(image: "mappin.group.red", text: "locationPhotoGroupInfoText".localize()))
        stackView.addArrangedSubview(IconInfoText(image: "mappin.group.blue", text: "locationTrackGroupInfoText".localize()))
        stackView.addArrangedSubview(IconInfoText(image: "mappin.group.purple", text: "locationPhotoTrackGroupInfoText".localize()))
        stackView.addArrangedSubview(UILabel(text: "locationGroupInfoText".localize()))
        // map menu
        stackView.addSpacer()
        stackView.addArrangedSubview(IconInfoText(icon: "map", text: "mapMenuInfoText".localize()))
        stackView.addArrangedSubview(IconInfoText(icon: "square.and.arrow.down", text: "preloadIconInfoText".localize(),leftInset: subInset))
        stackView.addArrangedSubview(IconInfoText(icon: "trash", text: "deleteTilesInfoText".localize(), iconColor: .red, leftInset: subInset))
        // location menu
        stackView.addSpacer()
        stackView.addArrangedSubview(IconInfoText(icon: "mappin", text: "locationMenuInfoText".localize()))
        stackView.addArrangedSubview(IconInfoText(icon: "plus.circle", text: "locationIconInfoText".localize(),leftInset: subInset))
        stackView.addArrangedSubview(UILabel(text: "addLocationInfoText".localize()))
        stackView.addArrangedSubview(IconInfoText(icon: "list.bullet", text: "locationListInfoText".localize(), leftInset: subInset))
        stackView.addArrangedSubview(IconInfoText(icon: "mappin", text: "showLocationsInfoText".localize(), leftInset: subInset))
        stackView.addArrangedSubview(IconInfoText(icon: "mappin.slash", text: "hideLocationsInfoText".localize(), leftInset: subInset))
        stackView.addArrangedSubview(IconInfoText(icon: "trash", text: "deleteLocationsInfoText".localize(), iconColor: .red, leftInset: subInset))
        // track menu
        stackView.addSpacer()
        stackView.addArrangedSubview(IconInfoText(icon: "figure.walk", text: "trackMenuInfoText".localize()))
        stackView.addArrangedSubview(IconInfoText(icon: "figure.walk", text: "startTrackInfoText".localize(), leftInset: subInset))
        stackView.addArrangedSubview(UILabel(text: "startTrackLocationInfoText".localize()))
        stackView.addArrangedSubview(IconInfoText(icon: "figure.walk", text: "currentTrackInfoText".localize(), iconColor: .green, leftInset: subInset))
        stackView.addArrangedSubview(IconInfoText(icon: "eye.slash", text: "hideTrackInfoText".localize(), leftInset: subInset))
        stackView.addArrangedSubview(IconInfoText(icon: "list.bullet", text: "trackListInfoText".localize(), leftInset: subInset))
        stackView.addArrangedSubview(IconInfoText(icon: "trash", text: "deleteTracksInfoText".localize(), iconColor: .red, leftInset: subInset))
        // center
        stackView.addSpacer()
        stackView.addArrangedSubview(IconInfoText(icon: "record.circle", text: "centerIconInfoText".localize()))
        // camera
        stackView.addSpacer()
        stackView.addArrangedSubview(IconInfoText(icon: "camera", text: "cameraIconInfoText".localize()))
        stackView.addArrangedSubview(UILabel(text: "addPhotoLocationInfoText".localize()))
        // preferences
        stackView.addSpacer()
        stackView.addArrangedSubview(IconInfoText(icon: "gearshape", text: "gearIconInfoText".localize()))
        // info
        stackView.addSpacer()
        stackView.addArrangedSubview(IconInfoText(icon: "info.circle", text: "infoIconInfoText".localize()))
        
        // info for location detail
        stackView.addSpacer()
        stackView.addArrangedSubview(UILabel(header: "locationDetailInfoHeader".localize()))
        stackView.addArrangedSubview(IconInfoText(icon: "photo", text: "locationDetailImageInfoText".localize()))
        stackView.addArrangedSubview(IconInfoText(icon: "trash", text: "locationDetailTrashInfoText".localize(), iconColor: .red))
        stackView.addArrangedSubview(IconInfoText(icon: "pencil.circle", text: "locationDetailPencilInfoText".localize()))
        stackView.addArrangedSubview(UILabel(text: "locationDetailEditInfoText".localize()))
        stackView.addArrangedSubview(IconInfoText(icon: "square.and.arrow.up", text: "locationDetailShareImageInfo".localize(), iconColor: .blue, leftInset: subInset))
        stackView.addArrangedSubview(IconInfoText(icon: "magnifyingglass", text: "locationDetailViewImageInfo".localize(), iconColor: .blue, leftInset: subInset))
        // info for track detail
        stackView.addSpacer()
        stackView.addArrangedSubview(UILabel(header: "trackDetailInfoHeader".localize()))
        stackView.addArrangedSubview(IconInfoText(icon: "map", text: "trackDetailMapInfoText".localize()))
        // info for preload
        stackView.addSpacer()
        stackView.addArrangedSubview(UILabel(header: "tilePreloadInfoHeader".localize()))
        stackView.addArrangedSubview(UILabel(text: "preloadInfoText".localize()))
        // info for location list
        stackView.addSpacer()
        stackView.addArrangedSubview(UILabel(header: "locationListInfoHeader".localize()))
        stackView.addArrangedSubview(IconInfoText(icon: "map", text: "locationListMapInfoText".localize()))
        stackView.addArrangedSubview(IconInfoText(icon: "magnifyingglass", text: "locationListViewInfoText".localize()))
        // info for track list
        stackView.addSpacer()
        stackView.addArrangedSubview(UILabel(header: "trackListInfoHeader".localize()))
        stackView.addArrangedSubview(IconInfoText(icon: "map", text: "trackListPinInfoText".localize()))
        stackView.addArrangedSubview(IconInfoText(icon: "magnifyingglass", text: "trackListViewInfoText".localize()))
        // info for preferences
        stackView.addSpacer()
        stackView.addArrangedSubview(UILabel(header: "preferencesInfoHeader".localize()))
        stackView.addArrangedSubview(UILabel(text: "urlInfoText".localize()))
        stackView.addSpacer()
        stackView.addArrangedSubview(UILabel(text: "maxLocationMergeDistance".localize() + ": " + "maxLocationMergeDistanceInfoText".localize()))
        stackView.addSpacer()
        stackView.addArrangedSubview(UILabel(text: "useLog".localize() + ": " + "logInfoText".localize()))
    }
    
}
