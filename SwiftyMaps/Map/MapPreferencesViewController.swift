//
//  SettingsViewController.swift
//
//  Created by Michael Rönnau on 13.06.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

protocol MapPreferencesDelegate{
    func clearTileCache()
    func removePlaces()
}

class MapPreferencesViewController: PopupViewController{
    
    var urlTemplateField = LabeledTextField()
    var startWithLastPositionSwitch = LabeledSwitchView()
    var showUserDirectionSwitch = LabeledSwitchView()
    var showPlaceMarkersSwitch = LabeledSwitchView()
    
    var delegate : MapPreferencesDelegate? = nil
    
    override func loadView() {
        title = "mapPreferences".localize()
        super.loadView()
        
        urlTemplateField.setupView(labelText: "urlTemplate".localize(), text: MapController.defaultUrl, isHorizontal: false)
        contentView.addSubview(urlTemplateField)
        urlTemplateField.setAnchors(top: contentView.topAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, insets: Insets.defaultInsets)
        
        startWithLastPositionSwitch.setupView(labelText: "startWithLastPosition".localize(), isOn: MapPreferences.instance.startWithLastPosition)
        contentView.addSubview(startWithLastPositionSwitch)
        startWithLastPositionSwitch.setAnchors(top: urlTemplateField.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, insets: Insets.defaultInsets)
        startWithLastPositionSwitch.isOn = MapPreferences.instance.startWithLastPosition
        
        showUserDirectionSwitch.setupView(labelText: "showUserDirection".localize(), isOn: MapPreferences.instance.showUserDirection)
        contentView.addSubview(showUserDirectionSwitch)
        showUserDirectionSwitch.setAnchors(top: startWithLastPositionSwitch.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, insets: Insets.defaultInsets)
        
        showPlaceMarkersSwitch.setupView(labelText: "showPlaces".localize(), isOn: MapPreferences.instance.showPlaceMarkers)
        contentView.addSubview((showPlaceMarkersSwitch))
        showPlaceMarkersSwitch.setAnchors(top: showUserDirectionSwitch.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, insets: Insets.defaultInsets)
        
        let saveButton = UIButton()
        saveButton.setTitle("save".localize(), for: .normal)
        saveButton.setTitleColor(.systemBlue, for: .normal)
        saveButton.addTarget(self, action: #selector(save), for: .touchDown)
        contentView.addSubview(saveButton)
        saveButton.setAnchors(top: showPlaceMarkersSwitch.bottomAnchor, bottom: contentView.bottomAnchor, insets: Insets.doubleInsets)
            .centerX(contentView.centerXAnchor)
        
    }
    
    @objc func save(){
        let newTemplate = urlTemplateField.text
        if newTemplate != MapController.defaultUrl{
            MapController.defaultUrl = newTemplate
            _ = MapTileFiles.clear()
        }
        MapPreferences.instance.startWithLastPosition = startWithLastPositionSwitch.isOn
        MapPreferences.instance.showUserDirection = showUserDirectionSwitch.isOn
        MapPreferences.instance.showPlaceMarkers = showPlaceMarkersSwitch.isOn
        MapPreferences.instance.save()
        self.dismiss(animated: true)
    }
    
}

