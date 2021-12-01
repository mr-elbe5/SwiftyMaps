/*
 SwiftyMaps
 App for display and use of OSM maps without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import UIKit
import UniformTypeIdentifiers
import CoreLocation

class TrackViewController: PopupScrollViewController{
    
    var track : TrackData? = nil
    
    override func loadView() {
        title = "track".localize()
        super.loadView()
        scrollView.setupVertical()
        setupContent()
    }
    
    func setupContent(){
        if let track = track{
            var header = HeaderLabel(text: "startLocation".localize())
            contentView.addSubview(header)
            header.setAnchors(top: contentView.topAnchor, leading: contentView.leadingAnchor)
            let locationLabel = TextLabel(text: track.startLocation.locationString)
            contentView.addSubview(locationLabel)
            locationLabel.setAnchors(top: header.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor)
            let coordinateLabel = TextLabel(text: track.startLocation.coordinateString)
            contentView.addSubview(coordinateLabel)
            coordinateLabel.setAnchors(top: locationLabel.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor)
            let timeLabel = TextLabel(text: "\(track.startTime.dateTimeString()) - \(track.endTime.dateTimeString())")
            contentView.addSubview(timeLabel)
            timeLabel.setAnchors(top: coordinateLabel.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor)
            header = HeaderLabel(text: "description".localize())
            contentView.addSubview(header)
            header.setAnchors(top: timeLabel.bottomAnchor, leading: contentView.leadingAnchor)
            let descriptionLabel = TextLabel(text: track.description)
            contentView.addSubview(descriptionLabel)
            descriptionLabel.setAnchors(top: header.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor)
            header = HeaderLabel(text: "distances".localize())
            contentView.addSubview(header)
            header.setAnchors(top: descriptionLabel.bottomAnchor, leading: contentView.leadingAnchor)
            let distanceLabel = TextLabel(text: "\("distance".localize()): \(Int(track.distance))m")
            contentView.addSubview(distanceLabel)
            distanceLabel.setAnchors(top: header.bottomAnchor, leading: contentView.leadingAnchor)
            let upDistanceLabel = TextLabel(text: "\("upDistance".localize()): \(Int(track.upDistance))m")
            contentView.addSubview(upDistanceLabel)
            upDistanceLabel.setAnchors(top: distanceLabel.bottomAnchor, leading: contentView.leadingAnchor)
            let downDistanceLabel = TextLabel(text: "\("downDistance".localize()): \(Int(track.downDistance))m")
            contentView.addSubview(downDistanceLabel)
            downDistanceLabel.setAnchors(top: upDistanceLabel.bottomAnchor, leading: contentView.leadingAnchor)
            let durationLabel = TextLabel(text: "\("duration".localize()): \(track.duration.hmsString())")
            contentView.addSubview(durationLabel)
            durationLabel.setAnchors(top: downDistanceLabel.bottomAnchor, leading: contentView.leadingAnchor, bottom: contentView.bottomAnchor)
        }
    }
    
}
