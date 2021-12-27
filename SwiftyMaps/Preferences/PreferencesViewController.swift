/*
 SwiftyMaps
 App for display and use of OSM maps without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import UIKit
import CoreLocation

class PreferencesViewController: PopupScrollViewController{
    
    var urlTemplateField = LabeledTextField()
    var startZoomField = LabeledTextField()
    var minLocationAccuracyField = LabeledTextField()
    var maxLocationMergeDistanceField = LabeledTextField()
    var pinGroupRadiusField = LabeledTextField()
    var maxPreloadTilesField = LabeledTextField()
    var startWithLastPositionSwitch = LabeledSwitchView()
    var logSwitch = LabeledSwitchView()
    
    var currentZoom : Int = MapStatics.minZoom
    var currentCenterCoordinate : CLLocationCoordinate2D? = nil
    
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
        
        pinGroupRadiusField.setupView(labelText: "pinGroupRadius".localize(), text: String(Int(Preferences.instance.pinGroupRadius)), isHorizontal: true)
        contentView.addSubview(pinGroupRadiusField)
        pinGroupRadiusField.setAnchors(top: maxLocationMergeDistanceField.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, insets: defaultInsets)
        
        maxPreloadTilesField.setupView(labelText: "maxPreloadTiles".localize(), text: String(Int(Preferences.instance.maxPreloadTiles)), isHorizontal: true)
        contentView.addSubview(maxPreloadTilesField)
        maxPreloadTilesField.setAnchors(top: pinGroupRadiusField.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, insets: defaultInsets)
        
        startWithLastPositionSwitch.setupView(labelText: "startWithLastPosition".localize(), isOn: Preferences.instance.startWithLastPosition)
        contentView.addSubview(startWithLastPositionSwitch)
        startWithLastPositionSwitch.setAnchors(top: maxPreloadTilesField.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, insets: defaultInsets)
        
        let saveButton = UIButton()
        saveButton.setTitle("save".localize(), for: .normal)
        saveButton.setTitleColor(.systemBlue, for: .normal)
        saveButton.addTarget(self, action: #selector(save), for: .touchDown)
        contentView.addSubview(saveButton)
        saveButton.setAnchors(top: startWithLastPositionSwitch.bottomAnchor, bottom: contentView.bottomAnchor, insets: doubleInsets)
            .centerX(contentView.centerXAnchor)
        
        if Log.useLogging{
            logSwitch.setupView(labelText: "useLog".localize(), isOn: Log.isLogging)
            contentView.addSubview(logSwitch)
            logSwitch.setAnchors(top: saveButton.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, bottom: contentView.bottomAnchor, insets: defaultInsets)
            logSwitch.delegate = self
        }
        else{
            saveButton.bottom(contentView.bottomAnchor, inset: defaultInset)
        }
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
        if let val = Int(pinGroupRadiusField.text){
            Preferences.instance.pinGroupRadius = CGFloat(val)
        }
        if let val = Int(maxPreloadTilesField.text){
            Preferences.instance.maxPreloadTiles = val
        }
        if let val = Int(startZoomField.text){
            Preferences.instance.startZoom = val
        }
        Preferences.instance.startWithLastPosition = startWithLastPositionSwitch.isOn
        Preferences.instance.save(zoom: currentZoom, currentCenterCoordinate: currentCenterCoordinate)
        self.dismiss(animated: true)
    }
    
}

extension PreferencesViewController: SwitchDelegate{
    
    func switchValueDidChange(sender: LabeledSwitchView, isOn: Bool) {
        if Log.useLogging, sender == logSwitch{
            if sender.isOn{
                Log.startLogging()
            }
            else{
                Log.stopLogging()
                if let url = URL(string: "log_\(Date().fileDate()).log", relativeTo: FileController.logDirURL){
                    let s = Log.toString()
                    if let data = s.data(using: .utf8){
                        FileController.saveFile(data : data, url: url)
                    }
                }
            }
        }
    }
    
}

