//
//  TourViewController.swift
//  SwiftyMaps
//
//  Created by Michael Rönnau on 20.09.21.
//

import Foundation
import UIKit
import UniformTypeIdentifiers
import CoreLocation

protocol TourDelegate{
    func startTour()
    func stopTour()
}

class TourViewController: PopupViewController{
    
    var delegate : TourDelegate? = nil
    
    var currentTour : TourData? = nil
    
    var toggleTourButton = UIButton()
    
    var loadTourButton = UIButton()
    
    override func loadView() {
        title = "tour".localize()
        super.loadView()
        currentTour = TourData.activeTour
        
        toggleTourButton.setTitleColor(.systemBlue, for: .normal)
        toggleTourButton.addTarget(self, action: #selector(toggleTour), for: .touchDown)
        contentView.addSubview(toggleTourButton)
        toggleTourButton.setAnchors(top: contentView.topAnchor, insets: Insets.doubleInsets)
            .centerX(contentView.centerXAnchor)
        updateToggleButton()
        
        loadTourButton.setTitle("Load tour", for: .normal)
        loadTourButton.setTitleColor(.systemBlue, for: .normal)
        loadTourButton.addTarget(self, action: #selector(loadTour), for: .touchDown)
        contentView.addSubview(loadTourButton)
        loadTourButton.setAnchors(top: toggleTourButton.topAnchor, bottom: contentView.bottomAnchor, insets: Insets.doubleInsets)
            .centerX(contentView.centerXAnchor)
        
    }
    
    func updateToggleButton(){
        if currentTour == nil{
            toggleTourButton.setTitle("startTour".localize(), for: .normal)
        }
        else{
            toggleTourButton.setTitle("stopTour".localize(), for: .normal)
        }
    }
    
    @objc func toggleTour(){
        if currentTour == nil{
            delegate?.startTour()
        }
        else{
            delegate?.stopTour()
        }
        currentTour = TourData.activeTour
        updateToggleButton()
    }
    
    @objc func loadTour(){
        let filePicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType(filenameExtension: "gpx")!])
        filePicker.directoryURL = FileController.gpxDirURL
        filePicker.allowsMultipleSelection = false
        filePicker.delegate = self
        filePicker.modalPresentationStyle = .fullScreen
        self.present(filePicker, animated: true, completion: nil)
    }
    
}

extension TourViewController : UIDocumentPickerDelegate{
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        if let url = urls.first{
            if let locations = GPXParser.parseFile(url: url){
                let tour = TourData()
                for location in locations{
                    tour.trackpoints.append(TrackPoint(location: location))
                }
                tour.dump()
            }
        }
    }
    
}
