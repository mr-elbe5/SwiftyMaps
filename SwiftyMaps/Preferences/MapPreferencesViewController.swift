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
    func removeAnnotations()
}

class MapPreferencesViewController: PopupViewController{
    
    var cartoUrlTemplateField = LabeledTextField()
    var topoUrlTemplateField = LabeledTextField()
    var startWithLastPositionSwitch = LabeledSwitchView()
    var showUserDirectionSwitch = LabeledSwitchView()
    var showAnnotationsSwitch = LabeledSwitchView()
    
    var delegate : PreferencesDelegate? = nil
    
    override func loadView() {
        title = "Preferences"
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
        
        showAnnotationsSwitch.setupView(labelText: "showAnnotations".localize(), isOn: Preferences.instance.showAnnotations)
        contentView.addSubview((showAnnotationsSwitch))
        showAnnotationsSwitch.setAnchors(top: showUserDirectionSwitch.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, bottom: nil, insets: Insets.defaultInsets)
        
        let saveButton = UIButton()
        saveButton.setTitle("save".localize(), for: .normal)
        saveButton.setTitleColor(.systemBlue, for: .normal)
        saveButton.addTarget(self, action: #selector(ok), for: .touchDown)
        contentView.addSubview(saveButton)
        saveButton.setAnchors(top: showAnnotationsSwitch.bottomAnchor, leading: nil, trailing: nil, bottom: nil, insets: Insets.doubleInsets)
            .centerX(contentView.centerXAnchor)
        
        let clearTileCacheButton = UIButton()
        clearTileCacheButton.setTitle("clearTileCache".localize(), for: .normal)
        clearTileCacheButton.setTitleColor(.systemBlue, for: .normal)
        clearTileCacheButton.addTarget(self, action: #selector(clearTileCache), for: .touchDown)
        contentView.addSubview(clearTileCacheButton)
        clearTileCacheButton.setAnchors(top: saveButton.bottomAnchor, leading: contentView.leadingAnchor, trailing: nil, bottom: nil, insets: Insets.doubleInsets)
        
        let removeAnnotationsButton = UIButton()
        removeAnnotationsButton.setTitle("deleteAnnotations".localize(), for: .normal)
        removeAnnotationsButton.setTitleColor(.systemBlue, for: .normal)
        removeAnnotationsButton.addTarget(self, action: #selector(removeAnnotations), for: .touchDown)
        contentView.addSubview(removeAnnotationsButton)
        removeAnnotationsButton.setAnchors(top: clearTileCacheButton.bottomAnchor, leading: contentView.leadingAnchor, trailing: nil, bottom: contentView.bottomAnchor, insets: Insets.doubleInsets)
        
    }
    
    @objc func clearTileCache(){
        showApprove(title: "reallyClearTileCache".localize(), text: "clearTileCacheHint".localize()){
            self.delegate?.clearTileCache()
        }
    }
    
    @objc func removeAnnotations(){
        showApprove(title: "reallyDeleteAnnotations".localize(), text: "deleteAnnotationsHint".localize()){
            self.delegate?.removeAnnotations()
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
        Preferences.instance.showAnnotations = showAnnotationsSwitch.isOn
        Preferences.instance.save()
        self.dismiss(animated: true)
    }
    
}

