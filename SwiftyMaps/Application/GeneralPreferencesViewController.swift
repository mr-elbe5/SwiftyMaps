//
//  GeneralPreferencesViewController.swift
//  SwiftyMaps
//
//  Created by Michael Rönnau on 21.11.21.
//

import Foundation
import UIKit

protocol GeneralPreferencesDelegate{
    
    func removePlaces()
}

class GeneralPreferencesViewController: PopupViewController{
    
    var delegate : GeneralPreferencesDelegate? = nil
    
    override func loadView() {
        title = "generalPreferences".localize()
        super.loadView()
        
        let saveButton = UIButton()
        saveButton.setTitle("save".localize(), for: .normal)
        saveButton.setTitleColor(.systemBlue, for: .normal)
        saveButton.addTarget(self, action: #selector(ok), for: .touchDown)
        contentView.addSubview(saveButton)
        saveButton.setAnchors(top: headerView.bottomAnchor, insets: Insets.doubleInsets)
            .centerX(contentView.centerXAnchor)
        
        let removePlacesButton = UIButton()
        removePlacesButton.setTitle("deletePlaces".localize(), for: .normal)
        removePlacesButton.setTitleColor(.systemBlue, for: .normal)
        removePlacesButton.addTarget(self, action: #selector(removePlaces), for: .touchDown)
        contentView.addSubview(removePlacesButton)
        removePlacesButton.setAnchors(top: saveButton.bottomAnchor, leading: contentView.leadingAnchor, bottom: contentView.bottomAnchor, insets: Insets.doubleInsets)
        
    }
    
    @objc func removePlaces(){
        showApprove(title: "reallyDeletePlaces".localize(), text: "deletePlacesHint".localize()){
            self.delegate?.removePlaces()
        }
    }
    
    @objc func ok(){
        
        
        self.dismiss(animated: true)
    }
    
}


