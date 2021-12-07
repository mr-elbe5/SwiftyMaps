/*
 SwiftyMaps
 App for display and use of OSM maps without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import UIKit

protocol TrackViewDelegate{
    func viewTrack(data: TrackData)
    func shareTrack(data: TrackData)
}

class TrackView : UIView{
    
    static func fromData(data : TrackData,delegate : TrackViewDelegate? = nil)  -> TrackView{
        let itemView = TrackView()
        itemView.delegate = delegate
        itemView.setupView(data: data)
        return itemView
    }
    
    var trackData : TrackData? = nil
    
    var delegate : TrackViewDelegate? = nil
    
    func setupView(data: TrackData){
        self.trackData = data
        if let track = trackData{
            let header = HeaderLabel(text: track.description)
            addSubview(header)
            header.setAnchors(top: topAnchor, leading: leadingAnchor)
            let locationLabel = UILabel(text: track.startLocation?.locationString ?? "")
            addSubview(locationLabel)
            locationLabel.setAnchors(top: header.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor)
            let coordinateLabel = UILabel(text: track.startLocation?.coordinateString ?? "")
            addSubview(coordinateLabel)
            coordinateLabel.setAnchors(top: locationLabel.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor)
            let timeLabel = TextLabel(text: "\(track.startTime.dateTimeString()) - \(track.endTime.dateTimeString())")
            addSubview(timeLabel)
            timeLabel.setAnchors(top: coordinateLabel.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor)
            let distanceLabel = TextLabel(text: "\("distance".localize()): \(Int(track.distance))m")
            addSubview(distanceLabel)
            distanceLabel.setAnchors(top: timeLabel.bottomAnchor, leading: leadingAnchor)
            let upDistanceLabel = TextLabel(text: "\("upDistance".localize()): \(Int(track.upDistance))m")
            addSubview(upDistanceLabel)
            upDistanceLabel.setAnchors(top: distanceLabel.bottomAnchor, leading: leadingAnchor)
            let downDistanceLabel = TextLabel(text: "\("downDistance".localize()): \(Int(track.downDistance))m")
            addSubview(downDistanceLabel)
            downDistanceLabel.setAnchors(top: upDistanceLabel.bottomAnchor, leading: leadingAnchor)
            let durationLabel = TextLabel(text: "\("duration".localize()): \(track.duration.hmsString())")
            addSubview(durationLabel)
            durationLabel.setAnchors(top: downDistanceLabel.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor)
            if delegate != nil{
                let sv = UIStackView()
                sv.setupHorizontal(distribution: .fillEqually, spacing: 2*defaultInset)
                addSubview(sv)
                sv.setAnchors(top: topAnchor, trailing: trailingAnchor, insets: doubleInsets)
                let viewButton = IconButton(icon: "magnifyingglass", tintColor: .systemBlue)
                viewButton.addTarget(self, action: #selector(viewItem), for: .touchDown)
                sv.addArrangedSubview(viewButton)
                let shareButton = IconButton(icon: "square.and.arrow.up", tintColor: .systemBlue)
                shareButton.addTarget(self, action: #selector(shareItem), for: .touchDown)
                sv.addArrangedSubview(shareButton)
            }
        }
    }
    
    @objc func viewItem(){
        if let data = trackData{
            //todo
        }
    }
    
    @objc func shareItem(){
        if let data = trackData{
            delegate?.shareTrack(data: data)
        }
    }
    
}
