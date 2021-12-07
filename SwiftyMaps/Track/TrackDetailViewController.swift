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
    func viewTrackDetails(track: TrackData)
    func deleteTrack(track: TrackData, approved: Bool)
    func cancelActiveTrack()
    func saveActiveTrack()
}

class TrackDetailViewController: PopupScrollViewController{
    
    var track: TrackData? = nil
    
    var isActiveTrack : Bool{
        get{
            track != nil && track == ActiveTrack.track
        }
    }
    
    let mapButton = IconButton(icon: "map", tintColor: .white)
    let deleteButton = IconButton(icon: "trash", tintColor: .white)
    
    // MainViewController
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
        
        headerView.addSubview(mapButton)
        mapButton.addTarget(self, action: #selector(showOnMap), for: .touchDown)
        mapButton.setAnchors(top: headerView.topAnchor, leading: headerView.leadingAnchor, bottom: headerView.bottomAnchor, insets: wideInsets)
        
        headerView.addSubview(deleteButton)
        deleteButton.addTarget(self, action: #selector(deleteTrack), for: .touchDown)
        deleteButton.setAnchors(top: headerView.topAnchor, leading: mapButton.trailingAnchor, bottom: headerView.bottomAnchor, insets: wideInsets)
    
    }
    
    func setupContent() {
        if let track = track{
            var header = HeaderLabel(text: "startLocation".localize())
            contentView.addSubview(header)
            header.setAnchors(top: contentView.topAnchor, leading: contentView.leadingAnchor)
            let locationLabel = UILabel(text: track.startLocation?.locationString ?? "")
            contentView.addSubview(locationLabel)
            locationLabel.setAnchors(top: header.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor)
            let coordinateLabel = UILabel(text: track.startLocation?.coordinateString ?? "")
            contentView.addSubview(coordinateLabel)
            coordinateLabel.setAnchors(top: locationLabel.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor)
            let timeLabel = UILabel(text: "\(track.startTime.dateTimeString()) - \(track.endTime.dateTimeString())")
            contentView.addSubview(timeLabel)
            timeLabel.setAnchors(top: coordinateLabel.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor)
            header = HeaderLabel(text: "description".localize())
            contentView.addSubview(header)
            header.setAnchors(top: timeLabel.bottomAnchor, leading: contentView.leadingAnchor)
            let descriptionLabel = UILabel(text: track.description)
            contentView.addSubview(descriptionLabel)
            descriptionLabel.setAnchors(top: header.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor)
            header = HeaderLabel(text: "distances".localize())
            contentView.addSubview(header)
            header.setAnchors(top: descriptionLabel.bottomAnchor, leading: contentView.leadingAnchor)
            let distanceLabel = UILabel(text: "\("distance".localize()): \(Int(track.distance))m")
            contentView.addSubview(distanceLabel)
            distanceLabel.setAnchors(top: header.bottomAnchor, leading: contentView.leadingAnchor)
            let upDistanceLabel = UILabel(text: "\("upDistance".localize()): \(Int(track.upDistance))m")
            contentView.addSubview(upDistanceLabel)
            upDistanceLabel.setAnchors(top: distanceLabel.bottomAnchor, leading: contentView.leadingAnchor)
            let downDistanceLabel = UILabel(text: "\("downDistance".localize()): \(Int(track.downDistance))m")
            contentView.addSubview(downDistanceLabel)
            downDistanceLabel.setAnchors(top: upDistanceLabel.bottomAnchor, leading: contentView.leadingAnchor)
            let durationLabel = UILabel(text: "\("duration".localize()): \(track.duration.hmsString())")
            contentView.addSubview(durationLabel)
            durationLabel.setAnchors(top: downDistanceLabel.bottomAnchor, leading: contentView.leadingAnchor)
            if isActiveTrack{
                let cancelButton = UIButton()
                cancelButton.setTitle("cancel".localize(), for: .normal)
                cancelButton.setTitleColor(.systemBlue, for: .normal)
                cancelButton.setGrayRoundedBorders()
                contentView.addSubview(cancelButton)
                cancelButton.setAnchors(top: durationLabel.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, insets: defaultInsets)
                cancelButton.addTarget(self, action: #selector(cancel), for: .touchDown)
                
                let saveButton = UIButton()
                saveButton.setTitle("save".localize(), for: .normal)
                saveButton.setTitleColor(.systemBlue, for: .normal)
                saveButton.setGrayRoundedBorders()
                contentView.addSubview(saveButton)
                saveButton.setAnchors(top: cancelButton.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, bottom: contentView.bottomAnchor, insets: defaultInsets)
                saveButton.addTarget(self, action: #selector(save), for: .touchDown)
            }
            else{
                durationLabel.bottom(contentView.bottomAnchor)
            }
        }
        
    }
    
    @objc func showOnMap(){
        if let track = track{
            delegate?.showTrackOnMap(track: track)
        }
    }
    
    @objc func deleteTrack(){
        if let track = track{
            showApprove(title: "confirmDeleteTrack".localize(), text: "deleteTrackInfo".localize()){
                self.dismiss(animated: true){
                    self.delegate?.deleteTrack(track: track, approved: true)
                }
            }
        }
    }
    
    @objc func cancel(){
        if isActiveTrack{
            self.dismiss(animated: true){
                self.delegate?.cancelActiveTrack()
            }
        }
    }
    
    @objc func save(){
        if isActiveTrack{
            self.dismiss(animated: true){
                self.delegate?.saveActiveTrack()
            }
        }
    }
    
    
}

