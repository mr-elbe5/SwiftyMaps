//
//  TrackViewController.swift
//  SwiftyMaps
//
//  Created by Michael Rönnau on 20.09.21.
//

import Foundation
import UIKit
import UniformTypeIdentifiers
import CoreLocation

protocol TrackDelegate{
    func startTracking()
    func stopTracking()
    func trackLoaded()
}

class TrackViewController: PopupViewController{
    
    var delegate : TrackDelegate? = nil
    
    var toggleTrackingButton = UIButton()
    
    var loadTrackButton = UIButton()
    
    override func loadView() {
        title = "track".localize()
        super.loadView()
        
        toggleTrackingButton.setTitleColor(.systemBlue, for: .normal)
        toggleTrackingButton.addTarget(self, action: #selector(toggleTracking), for: .touchDown)
        contentView.addSubview(toggleTrackingButton)
        toggleTrackingButton.setAnchors(top: contentView.topAnchor, insets: Insets.doubleInsets)
            .centerX(contentView.centerXAnchor)
        updateToggleButton()
        
        loadTrackButton.setTitle("Load track", for: .normal)
        loadTrackButton.setTitleColor(.systemBlue, for: .normal)
        loadTrackButton.addTarget(self, action: #selector(loadTrack), for: .touchDown)
        contentView.addSubview(loadTrackButton)
        loadTrackButton.setAnchors(top: toggleTrackingButton.topAnchor, bottom: contentView.bottomAnchor, insets: Insets.doubleInsets)
            .centerX(contentView.centerXAnchor)
        
    }
    
    func updateToggleButton(){
        if !TrackController.isTracking{
            toggleTrackingButton.setTitle("startTracking".localize(), for: .normal)
        }
        else{
            toggleTrackingButton.setTitle("stopTracking".localize(), for: .normal)
        }
    }
    
    @objc func toggleTracking(){
        if !TrackController.isTracking{
            delegate?.startTracking()
        }
        else{
            delegate?.stopTracking()
        }
        updateToggleButton()
    }
    
    @objc func loadTrack(){
        let filePicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType(filenameExtension: "gpx")!])
        filePicker.directoryURL = FileController.gpxDirURL
        filePicker.allowsMultipleSelection = false
        filePicker.delegate = self
        filePicker.modalPresentationStyle = .fullScreen
        self.present(filePicker, animated: true){
            self.delegate?.trackLoaded()
        }
    }
    
}

extension TrackViewController : UIDocumentPickerDelegate{
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        if let url = urls.first{
            if let locations = GPXParser.parseFile(url: url){
                let track = TrackData()
                for location in locations{
                    track.trackpoints.append(TrackPoint(location: location))
                }
                //track.dump()
                TrackController.currentTrack = track
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
}
