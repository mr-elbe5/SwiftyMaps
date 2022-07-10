/*
 SwiftyMaps
 App for display and use of OSM maps without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import UIKit
import UniformTypeIdentifiers
import CoreLocation

protocol TrackDetailDelegate{
    func showTrackOnMap(track: TrackData)
}

//opened by TrackCell via TracksViewController
class TrackDetailViewController: HeaderScrollViewController{
    
    var track: TrackData? = nil
    
    var isActiveTrack : Bool{
        track != nil && track == TrackPool.activeTrack
    }
    
    let mapButton = IconButton(icon: "map", tintColor: .darkGray)
    let deleteButton = IconButton(icon: "trash", tintColor: .darkGray)
    
    // MapViewController
    var delegate : TrackDetailDelegate? = nil
    
    override func loadView() {
        title = "track".localize()
        super.loadView()
        scrollView.setupVertical()
        setupContent()
        setupKeyboard()
    }
    
    override func setupHeaderView(){
        super.setupHeaderView()
        addHeaderTitle()
        addCloseButton()
        headerView.addSubview(mapButton)
        mapButton.addTarget(self, action: #selector(showOnMap), for: .touchDown)
        mapButton.setAnchors(top: headerView.topAnchor, leading: headerView.leadingAnchor, bottom: headerView.bottomAnchor, insets: wideInsets)
    }
    
    func setupContent() {
        if let track = track{
            var header = UILabel(header: "name".localize())
            contentView.addSubview(header)
            header.setAnchors(top: contentView.topAnchor, leading: contentView.leadingAnchor,insets: defaultInsets)
            let nameLabel = UILabel(text: track.name)
            contentView.addSubview(nameLabel)
            nameLabel.setAnchors(top: header.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor,insets: flatInsets)
            let coordinateLabel = UILabel(text: track.trackpoints.first?.coordinate.coordinateString ?? "")
            contentView.addSubview(coordinateLabel)
            coordinateLabel.setAnchors(top: nameLabel.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor,insets: flatInsets)
            let timeLabel = UILabel(text: "\(track.startTime.dateTimeString()) - \(track.endTime.dateTimeString())")
            contentView.addSubview(timeLabel)
            timeLabel.setAnchors(top: coordinateLabel.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor,insets: flatInsets)
            header = UILabel(header: "distances".localize())
            contentView.addSubview(header)
            header.setAnchors(top: timeLabel.bottomAnchor, leading: contentView.leadingAnchor,insets: defaultInsets)
            let distanceLabel = UILabel(text: "\("distance".localize()): \(Int(track.distance))m")
            contentView.addSubview(distanceLabel)
            distanceLabel.setAnchors(top: header.bottomAnchor, leading: contentView.leadingAnchor,insets: flatInsets)
            let upDistanceLabel = UILabel(text: "\("upDistance".localize()): \(Int(track.upDistance))m")
            contentView.addSubview(upDistanceLabel)
            upDistanceLabel.setAnchors(top: distanceLabel.bottomAnchor, leading: contentView.leadingAnchor,insets: flatInsets)
            let downDistanceLabel = UILabel(text: "\("downDistance".localize()): \(Int(track.downDistance))m")
            contentView.addSubview(downDistanceLabel)
            downDistanceLabel.setAnchors(top: upDistanceLabel.bottomAnchor, leading: contentView.leadingAnchor,insets: flatInsets)
            let durationLabel = UILabel(text: "\("duration".localize()): \(track.duration.hmsString())")
            contentView.addSubview(durationLabel)
            durationLabel.setAnchors(top: downDistanceLabel.bottomAnchor, leading: contentView.leadingAnchor, bottom: contentView.bottomAnchor,insets: flatInsets)
        }
        
    }
    
    @objc func showOnMap(){
        if let track = track{
            delegate?.showTrackOnMap(track: track)
        }
    }
    
}

