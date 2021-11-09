//
//  SettingsViewController.swift
//
//  Created by Michael Rönnau on 13.06.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

protocol PreferencesDelegate{
    func clearTileCache()
    func removePlaces()
}

class MapPreferencesViewController: PopupViewController{
    
    var cartoUrlTemplateField = LabeledTextField()
    var topoUrlTemplateField = LabeledTextField()
    var startWithLastPositionSwitch = LabeledSwitchView()
    var showUserDirectionSwitch = LabeledSwitchView()
    var showPlaceMarkersSwitch = LabeledSwitchView()
    
    var delegate : PreferencesDelegate? = nil
    
    override func loadView() {
        title = "preferences".localize()
        super.loadView()
        
        
        cartoUrlTemplateField.setupView(labelText: "cartoUrl".localize(), text: MapType.carto.tileUrl, isHorizontal: false)
        contentView.addSubview(cartoUrlTemplateField)
        cartoUrlTemplateField.setAnchors(top: contentView.topAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, bottom: nil, insets: Insets.defaultInsets)
        
        topoUrlTemplateField.setupView(labelText: "topoUrl".localize(), text: MapType.topo.tileUrl, isHorizontal: false)
        contentView.addSubview(topoUrlTemplateField)
        topoUrlTemplateField.setAnchors(top: cartoUrlTemplateField.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, bottom: nil, insets: Insets.defaultInsets)
        
        startWithLastPositionSwitch.setupView(labelText: "startWithLastPosition".localize(), isOn: Preferences.instance.startWithLastPosition)
        contentView.addSubview(startWithLastPositionSwitch)
        startWithLastPositionSwitch.setAnchors(top: topoUrlTemplateField.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, bottom: nil, insets: Insets.defaultInsets)
        startWithLastPositionSwitch.isOn = Preferences.instance.startWithLastPosition
        
        showUserDirectionSwitch.setupView(labelText: "showUserDirection".localize(), isOn: Preferences.instance.showUserDirection)
        contentView.addSubview(showUserDirectionSwitch)
        showUserDirectionSwitch.setAnchors(top: startWithLastPositionSwitch.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, bottom: nil, insets: Insets.defaultInsets)
        
        showPlaceMarkersSwitch.setupView(labelText: "showPlaces".localize(), isOn: Preferences.instance.showPlaceMarkers)
        contentView.addSubview((showPlaceMarkersSwitch))
        showPlaceMarkersSwitch.setAnchors(top: showUserDirectionSwitch.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, bottom: nil, insets: Insets.defaultInsets)
        
        let saveButton = UIButton()
        saveButton.setTitle("save".localize(), for: .normal)
        saveButton.setTitleColor(.systemBlue, for: .normal)
        saveButton.addTarget(self, action: #selector(ok), for: .touchDown)
        contentView.addSubview(saveButton)
        saveButton.setAnchors(top: showPlaceMarkersSwitch.bottomAnchor, leading: nil, trailing: nil, bottom: nil, insets: Insets.doubleInsets)
            .centerX(contentView.centerXAnchor)
        
        let clearTileCacheButton = UIButton()
        clearTileCacheButton.setTitle("clearTileCache".localize(), for: .normal)
        clearTileCacheButton.setTitleColor(.systemBlue, for: .normal)
        clearTileCacheButton.addTarget(self, action: #selector(clearTileCache), for: .touchDown)
        contentView.addSubview(clearTileCacheButton)
        clearTileCacheButton.setAnchors(top: saveButton.bottomAnchor, leading: contentView.leadingAnchor, trailing: nil, bottom: nil, insets: Insets.doubleInsets)
        
        let removePlacesButton = UIButton()
        removePlacesButton.setTitle("deletePlaces".localize(), for: .normal)
        removePlacesButton.setTitleColor(.systemBlue, for: .normal)
        removePlacesButton.addTarget(self, action: #selector(removePlaces), for: .touchDown)
        contentView.addSubview(removePlacesButton)
        removePlacesButton.setAnchors(top: clearTileCacheButton.bottomAnchor, leading: contentView.leadingAnchor, trailing: nil, bottom: contentView.bottomAnchor, insets: Insets.doubleInsets)
        
    }
    
    @objc func clearTileCache(){
        showApprove(title: "reallyClearTileCache".localize(), text: "clearTileCacheHint".localize()){
            self.delegate?.clearTileCache()
        }
    }
    
    @objc func removePlaces(){
        showApprove(title: "reallyDeletePlaces".localize(), text: "deletePlacesHint".localize()){
            self.delegate?.removePlaces()
        }
    }
    
    @objc func ok(){
        var newTemplate = cartoUrlTemplateField.text
        if newTemplate != MapType.carto.tileUrl{
            MapType.carto.tileUrl = newTemplate
            _ = MapTileCache.clear()
        }
        newTemplate = topoUrlTemplateField.text
        if newTemplate != MapType.topo.tileUrl{
            MapType.topo.tileUrl = newTemplate
            _ = MapTileCache.clear()
        }
        Preferences.instance.startWithLastPosition = startWithLastPositionSwitch.isOn
        Preferences.instance.showUserDirection = showUserDirectionSwitch.isOn
        Preferences.instance.showPlaceMarkers = showPlaceMarkersSwitch.isOn
        Preferences.instance.save()
        self.dismiss(animated: true)
    }
    
}

