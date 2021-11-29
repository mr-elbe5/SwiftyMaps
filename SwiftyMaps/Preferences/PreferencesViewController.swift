//
//  SettingsViewController.swift
//
//  Created by Michael Rönnau on 13.06.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class PreferencesViewController: PopupViewController{
    
    var urlTemplateField = LabeledTextField()
    var startZoomField = LabeledTextField()
    var minLocationAccuracyField = LabeledTextField()
    var maxLocationMergeDistanceField = LabeledTextField()
    var minZoomToShowLocationsField = LabeledTextField()
    var maxPreloadTilesField = LabeledTextField()
    var startWithLastPositionSwitch = LabeledSwitchView()
    
    override func loadView() {
        title = "mapPreferences".localize()
        super.loadView()
        
        urlTemplateField.setupView(labelText: "urlTemplate".localize(), text: Preferences.instance.urlTemplate, isHorizontal: false)
        contentView.addSubview(urlTemplateField)
        urlTemplateField.setAnchors(top: contentView.topAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, insets: defaultInsets)
        
        startZoomField.setupView(labelText: "startZoom".localize(), text: String(Int(Preferences.instance.startZoom)), isHorizontal: true)
        contentView.addSubview(startZoomField)
        startZoomField.setAnchors(top: urlTemplateField.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, insets: defaultInsets)
        
        minLocationAccuracyField.setupView(labelText: "minLocationAccuracy".localize(), text: String(Int(Preferences.instance.minLocationAccuracy)), isHorizontal: true)
        contentView.addSubview(minLocationAccuracyField)
        minLocationAccuracyField.setAnchors(top: startZoomField.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, insets: defaultInsets)
        
        maxLocationMergeDistanceField.setupView(labelText: "maxLocationMergeDistance".localize(), text: String(Int(Preferences.instance.maxLocationMergeDistance)), isHorizontal: true)
        contentView.addSubview(maxLocationMergeDistanceField)
        maxLocationMergeDistanceField.setAnchors(top: minLocationAccuracyField.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, insets: defaultInsets)
        
        minZoomToShowLocationsField.setupView(labelText: "minZoomToShowLocations".localize(), text: String(Int(Preferences.instance.minZoomToShowLocations)), isHorizontal: true)
        contentView.addSubview(minZoomToShowLocationsField)
        minZoomToShowLocationsField.setAnchors(top: maxLocationMergeDistanceField.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, insets: defaultInsets)
        
        maxPreloadTilesField.setupView(labelText: "maxPreloadTiles".localize(), text: String(Int(Preferences.instance.maxPreloadTiles)), isHorizontal: true)
        contentView.addSubview(maxPreloadTilesField)
        maxPreloadTilesField.setAnchors(top: minZoomToShowLocationsField.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, insets: defaultInsets)
        
        startWithLastPositionSwitch.setupView(labelText: "startWithLastPosition".localize(), isOn: Preferences.instance.startWithLastPosition)
        contentView.addSubview(startWithLastPositionSwitch)
        startWithLastPositionSwitch.setAnchors(top: maxPreloadTilesField.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, insets: defaultInsets)
        startWithLastPositionSwitch.isOn = Preferences.instance.startWithLastPosition
        
        let saveButton = UIButton()
        saveButton.setTitle("save".localize(), for: .normal)
        saveButton.setTitleColor(.systemBlue, for: .normal)
        saveButton.addTarget(self, action: #selector(save), for: .touchDown)
        contentView.addSubview(saveButton)
        saveButton.setAnchors(top: startWithLastPositionSwitch.bottomAnchor, bottom: contentView.bottomAnchor, insets: doubleInsets)
            .centerX(contentView.centerXAnchor)
    }
    
    @objc func save(){
        let newTemplate = urlTemplateField.text
        if newTemplate != Preferences.instance.urlTemplate{
            Preferences.instance.urlTemplate = newTemplate
            _ = MapTiles.clear()
        }
        if let val = Int(minLocationAccuracyField.text){
            Preferences.instance.minLocationAccuracy = CLLocationDistance(val)
        }
        if let val = Int(maxLocationMergeDistanceField.text){
            Preferences.instance.maxLocationMergeDistance = CLLocationDistance(val)
        }
        if let val = Int(minZoomToShowLocationsField.text){
            Preferences.instance.minZoomToShowLocations = val
        }
        if let val = Int(maxPreloadTilesField.text){
            Preferences.instance.maxPreloadTiles = val
        }
        if let val = Int(startZoomField.text){
            Preferences.instance.startZoom = val
        }
        Preferences.instance.startWithLastPosition = startWithLastPositionSwitch.isOn
        Preferences.instance.save()
        self.dismiss(animated: true)
    }
    
}

