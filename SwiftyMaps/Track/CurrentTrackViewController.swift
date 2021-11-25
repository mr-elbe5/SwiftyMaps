//
//  CurrentTrackViewController.swift
//  SwiftyMaps
//
//  Created by Michael Rönnau on 22.11.21.
//

import Foundation
import UIKit
import UniformTypeIdentifiers
import CoreLocation

protocol CurrentTrackDelegate{
    
    func pauseCurrentTrack()
    func resumeCurrentTrack()
    func cancelCurrentTrack()
    func saveCurrentTrack()
}

class CurrentTrackViewController: PopupViewController{
    
    var delegate : CurrentTrackDelegate? = nil
    
    override func loadView() {
        title = "currentTrack".localize()
        super.loadView()
        if let track = Tracks.instance.currentTrack{
            
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
        
    }
    
    @objc func pause(){
        delegate?.pauseCurrentTrack()
    }
    
    @objc func resume(){
        delegate?.resumeCurrentTrack()
    }
    
    @objc func cancel(){
        self.dismiss(animated: true){
            self.delegate?.cancelCurrentTrack()
        }
    }
    
    @objc func save(){
        self.dismiss(animated: true){
            self.delegate?.saveCurrentTrack()
        }
    }
    
    
}

