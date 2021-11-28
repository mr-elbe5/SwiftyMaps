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
    var distanceFilterField = LabeledTextField()
    var headingFilterField = LabeledTextField()
    var minHorizontalAccuracyField = LabeledTextField()
    var minVerticalAccuracyField = LabeledTextField()
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
        
        distanceFilterField.setupView(labelText: "distanceFilter".localize(), text: String(Int(Preferences.instance.distanceFilter)), isHorizontal: true)
        contentView.addSubview(distanceFilterField)
        distanceFilterField.setAnchors(top: startZoomField.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, insets: defaultInsets)
        
        headingFilterField.setupView(labelText: "headingFilter".localize(), text: String(Int(Preferences.instance.headingFilter)), isHorizontal: true)
        contentView.addSubview(headingFilterField)
        headingFilterField.setAnchors(top: distanceFilterField.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, insets: defaultInsets)
        
        minHorizontalAccuracyField.setupView(labelText: "minHorizontalAccuracy".localize(), text: String(Int(Preferences.instance.minHorizontalAccuracy)), isHorizontal: true)
        contentView.addSubview(minHorizontalAccuracyField)
        minHorizontalAccuracyField.setAnchors(top: headingFilterField.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, insets: defaultInsets)
        
        minVerticalAccuracyField.setupView(labelText: "minVerticalAccuracy".localize(), text: String(Int(Preferences.instance.minVerticalAccuracy)), isHorizontal: true)
        contentView.addSubview(minVerticalAccuracyField)
        minVerticalAccuracyField.setAnchors(top: minHorizontalAccuracyField.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, insets: defaultInsets)
        
        maxLocationMergeDistanceField.setupView(labelText: "maxLocationMergeDistance".localize(), text: String(Int(Preferences.instance.maxLocationMergeDistance)), isHorizontal: true)
        contentView.addSubview(maxLocationMergeDistanceField)
        maxLocationMergeDistanceField.setAnchors(top: minVerticalAccuracyField.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, insets: defaultInsets)
        
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
        if newTemplate != MapStatics.defaultUrl{
            MapStatics.defaultUrl = newTemplate
            _ = MapTiles.clear()
        }
        if let val = Int(distanceFilterField.text){
            Preferences.instance.distanceFilter = CLLocationDistance(val)
        }
        if let val = Int(headingFilterField.text){
            Preferences.instance.headingFilter = CLLocationDistance(val)
        }
        if let val = Int(minHorizontalAccuracyField.text){
            Preferences.instance.minHorizontalAccuracy = CLLocationDistance(val)
        }
        if let val = Int(minVerticalAccuracyField.text){
            Preferences.instance.minVerticalAccuracy = CLLocationDistance(val)
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

