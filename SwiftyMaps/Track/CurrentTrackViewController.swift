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
    
    var track : TrackData? = nil
    
    var delegate : CurrentTrackDelegate? = nil
    
    override func loadView() {
        title = "currentTrack".localize()
        super.loadView()
        
        let pauseButton = UIButton()
        pauseButton.setTitle("pause".localize(), for: .normal)
        pauseButton.setTitleColor(.systemBlue, for: .normal)
        contentView.addSubview(pauseButton)
        pauseButton.setAnchors(top: contentView.topAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, insets: defaultInsets)
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

