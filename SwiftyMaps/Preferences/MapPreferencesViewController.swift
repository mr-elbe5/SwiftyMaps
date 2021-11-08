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
    
    var cartoUrlTemplateField = UITextField()
    var topoUrlTemplateField = UITextField()
    var startWithLastPositionSwitch = UISwitch()
    var showUserDirectionSwitch = UISwitch()
    var showAnnotationsSwitch = UISwitch()
    
    var delegate : PreferencesDelegate? = nil
    
    override func loadView() {
        title = "Preferences"
        super.loadView()
        
        var label = UILabel()
        label.text = "URL Template for OpenStreetMap Carto Style:"
        contentView.addSubview(label)
        label.setAnchors(top: contentView.topAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, bottom: nil, insets: Insets.doubleInsets)
        cartoUrlTemplateField.autocapitalizationType = .none
        cartoUrlTemplateField.autocorrectionType = .no
        cartoUrlTemplateField.setKeyboardToolbar(doneTitle: "Done")
        contentView.addSubview(cartoUrlTemplateField)
        cartoUrlTemplateField.setAnchors(top: label.bottomAnchor, leading: scrollView.leadingAnchor, trailing: scrollView.trailingAnchor, bottom: nil, insets: Insets.doubleInsets)
        cartoUrlTemplateField.text = MapType.carto.tileUrl
        
        label = UILabel()
        label.text = "URL Template for OpenTopoMap Style:"
        contentView.addSubview(label)
        label.setAnchors(top: cartoUrlTemplateField.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, bottom: nil, insets: Insets.doubleInsets)
        topoUrlTemplateField.autocapitalizationType = .none
        topoUrlTemplateField.autocorrectionType = .no
        topoUrlTemplateField.setKeyboardToolbar(doneTitle: "Done")
        contentView.addSubview(topoUrlTemplateField)
        topoUrlTemplateField.setAnchors(top: label.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, bottom: nil, insets: Insets.doubleInsets)
        topoUrlTemplateField.text = MapType.topo.tileUrl
        
        label = UILabel()
        label.text = "startWithLastPosition".localize()
        scrollView.addSubview(label)
        label.setAnchors(top: topoUrlTemplateField.bottomAnchor, leading: scrollView.leadingAnchor, trailing: nil, bottom: nil, insets: Insets.doubleInsets)
        contentView.addSubview(startWithLastPositionSwitch)
        startWithLastPositionSwitch.setAnchors(top: topoUrlTemplateField.bottomAnchor, leading: nil, trailing: contentView.trailingAnchor, bottom: nil, insets: Insets.defaultInsets)
        startWithLastPositionSwitch.isOn = Preferences.instance.startWithLastPosition
        
        label = UILabel()
        label.text = "Show User Direction:"
        scrollView.addSubview(label)
        label.setAnchors(top: startWithLastPositionSwitch.bottomAnchor, leading: scrollView.leadingAnchor, trailing: nil, bottom: nil, insets: Insets.doubleInsets)
        contentView.addSubview(showUserDirectionSwitch)
        showUserDirectionSwitch.setAnchors(top: startWithLastPositionSwitch.bottomAnchor, leading: nil, trailing: contentView.trailingAnchor, bottom: nil, insets: Insets.defaultInsets)
        showUserDirectionSwitch.isOn = Preferences.instance.showUserDirection
        
        label = UILabel()
        label.text = "Show Annotations:"
        scrollView.addSubview(label)
        label.setAnchors(top: showUserDirectionSwitch.bottomAnchor, leading: scrollView.leadingAnchor, trailing: nil, bottom: nil, insets: Insets.doubleInsets)
        contentView.addSubview((showAnnotationsSwitch))
        showAnnotationsSwitch.setAnchors(top: showUserDirectionSwitch.bottomAnchor, leading: nil, trailing: contentView.trailingAnchor, bottom: nil, insets: Insets.defaultInsets)
        showAnnotationsSwitch.isOn =  Preferences.instance.showAnnotations
        
        let saveButton = UIButton()
        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(.systemBlue, for: .normal)
        saveButton.addTarget(self, action: #selector(ok), for: .touchDown)
        contentView.addSubview(saveButton)
        saveButton.setAnchors(top: showAnnotationsSwitch.bottomAnchor, leading: nil, trailing: nil, bottom: nil, insets: Insets.doubleInsets)
            .centerX(contentView.centerXAnchor)
        
        let clearTileCacheButton = UIButton()
        clearTileCacheButton.setTitle("Clear Tile Cache", for: .normal)
        clearTileCacheButton.setTitleColor(.systemBlue, for: .normal)
        clearTileCacheButton.addTarget(self, action: #selector(clearTileCache), for: .touchDown)
        contentView.addSubview(clearTileCacheButton)
        clearTileCacheButton.setAnchors(top: saveButton.bottomAnchor, leading: contentView.leadingAnchor, trailing: nil, bottom: nil, insets: Insets.doubleInsets)
        
        let removeAnnotationsButton = UIButton()
        removeAnnotationsButton.setTitle("Remove all annotations", for: .normal)
        removeAnnotationsButton.setTitleColor(.systemBlue, for: .normal)
        removeAnnotationsButton.addTarget(self, action: #selector(removeAnnotations), for: .touchDown)
        contentView.addSubview(removeAnnotationsButton)
        removeAnnotationsButton.setAnchors(top: clearTileCacheButton.bottomAnchor, leading: contentView.leadingAnchor, trailing: nil, bottom: contentView.bottomAnchor, insets: Insets.doubleInsets)
        
    }
    
    @objc func clearTileCache(){
        showApprove(title: "Really clear all tiles from cache?", text: "Tiles will have to be reloaded"){
            self.delegate?.clearTileCache()
        }
    }
    
    @objc func removeAnnotations(){
        showApprove(title: "Really delete all annotations?", text: "This cannot be undone"){
            self.delegate?.removeAnnotations()
        }
    }
    
    @objc func ok(){
        if let newTemplate = cartoUrlTemplateField.text, newTemplate != MapType.carto.tileUrl{
            MapType.carto.tileUrl = newTemplate
            _ = MapTileCache.clear()
        }
        if let newTemplate = topoUrlTemplateField.text, newTemplate != MapType.topo.tileUrl{
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

