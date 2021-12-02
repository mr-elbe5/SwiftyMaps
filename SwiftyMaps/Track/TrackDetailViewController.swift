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
    func pauseCurrentTrack()
    func resumeCurrentTrack()
    func cancelCurrentTrack()
    func saveCurrentTrack()
}

class TrackDetailViewController: PopupScrollViewController{
    
    var track: TrackData? = nil
    
    var isCurrentTrack : Bool{
        get{
            track != nil && track == Tracks.instance.currentTrack
        }
    }
    
    let mapButton = IconButton(icon: "map", tintColor: .white)
    let deleteButton = IconButton(icon: "trash", tintColor: .white)
    
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
            durationLabel.setAnchors(top: downDistanceLabel.bottomAnchor, leading: contentView.leadingAnchor)
            if isCurrentTrack{
                let pauseButton = UIButton()
                pauseButton.setTitle("pause".localize(), for: .normal)
                pauseButton.setTitleColor(.systemBlue, for: .normal)
                contentView.addSubview(pauseButton)
                pauseButton.setAnchors(top: durationLabel.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, insets: defaultInsets)
                pauseButton.addTarget(self, action: #selector(pause), for: .touchDown)
                
                let resumeButton = UIButton()
                resumeButton.setTitle("resume".localize(), for: .normal)
                resumeButton.setTitleColor(.systemBlue, for: .normal)
                contentView.addSubview(resumeButton)
                resumeButton.setAnchors(top: pauseButton.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, insets: defaultInsets)
                resumeButton.addTarget(self, action: #selector(resume), for: .touchDown)
                
                let cancelButton = UIButton()
                cancelButton.setTitle("cancel".localize(), for: .normal)
                cancelButton.setTitleColor(.systemBlue, for: .normal)
                contentView.addSubview(cancelButton)
                cancelButton.setAnchors(top: resumeButton.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, insets: defaultInsets)
                cancelButton.addTarget(self, action: #selector(cancel), for: .touchDown)
                
                let saveButton = UIButton()
                saveButton.setTitle("save".localize(), for: .normal)
                saveButton.setTitleColor(.systemBlue, for: .normal)
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
    
    @objc func pause(){
        if isCurrentTrack{
            delegate?.pauseCurrentTrack()
        }
    }
    
    @objc func resume(){
        if isCurrentTrack{
            delegate?.resumeCurrentTrack()
        }
    }
    
    @objc func cancel(){
        if isCurrentTrack{
            self.dismiss(animated: true){
                self.delegate?.cancelCurrentTrack()
            }
        }
    }
    
    @objc func save(){
        if isCurrentTrack{
            self.dismiss(animated: true){
                self.delegate?.saveCurrentTrack()
            }
        }
    }
    
    
}

