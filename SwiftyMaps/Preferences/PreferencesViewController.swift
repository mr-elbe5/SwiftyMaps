/*
 SwiftyMaps
 App for display and use of OSM maps without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import UIKit
import CoreLocation

class PreferencesViewController: ScrollViewController{
    
    var urlTemplateField = LabeledTextField()
    var preloadUrlTemplateField = LabeledTextField()
    var startZoomField = LabeledTextField()
    var minLocationAccuracyField = LabeledTextField()
    var maxLocationMergeDistanceField = LabeledTextField()
    var minTrackingDistanceField = LabeledTextField()
    var minTrackingIntervalField = LabeledTextField()
    var pinGroupRadiusField = LabeledTextField()
    var maxPreloadTilesField = LabeledTextField()
    var startWithLastPositionSwitch = LabeledSwitchView()
    var showPinsSwitch = LabeledSwitchView()
    
    var currentZoom : Int = MapStatics.minZoom
    var currentCenterCoordinate : CLLocationCoordinate2D? = nil
    
    override func loadView() {
        title = "mapPreferences".localize()
        super.loadView()
        
        urlTemplateField.setupView(labelText: "urlTemplate".localize(), text: Preferences.instance.urlTemplate, isHorizontal: false)
        contentView.addSubview(urlTemplateField)
        urlTemplateField.setAnchors(top: contentView.topAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, insets: defaultInsets)
        
        let elbe5Button = UIButton()
        elbe5Button.setTitle("elbe5TileURL".localize(), for: .normal)
        elbe5Button.setTitleColor(.systemBlue, for: .normal)
        elbe5Button.addTarget(self, action: #selector(elbe5Template), for: .touchDown)
        contentView.addSubview(elbe5Button)
        elbe5Button.setAnchors(top: urlTemplateField.bottomAnchor, leading: contentView.leadingAnchor, insets: flatInsets)
        
        let elbe5InfoLink = UIButton()
        elbe5InfoLink.setTitleColor(.systemBlue, for: .normal)
        elbe5InfoLink.titleLabel?.font = .preferredFont(forTextStyle: .footnote)
        contentView.addSubview(elbe5InfoLink)
        elbe5InfoLink.setAnchors(top: elbe5Button.bottomAnchor, leading: contentView.leadingAnchor, insets: flatInsets)
        elbe5InfoLink.setTitle("elbe5LegalInfo".localize(), for: .normal)
        elbe5InfoLink.addTarget(self, action: #selector(openElbe5Info), for: .touchDown)
        
        let osmButton = UIButton()
        osmButton.setTitle("osmTileURL".localize(), for: .normal)
        osmButton.setTitleColor(.systemBlue, for: .normal)
        osmButton.addTarget(self, action: #selector(osmTemplate), for: .touchDown)
        contentView.addSubview(osmButton)
        osmButton.setAnchors(top: elbe5InfoLink.bottomAnchor, leading: contentView.leadingAnchor, insets: flatInsets)
        
        let osmInfoLink = UIButton()
        osmInfoLink.setTitleColor(.systemBlue, for: .normal)
        osmInfoLink.titleLabel?.font = .preferredFont(forTextStyle: .footnote)
        contentView.addSubview(osmInfoLink)
        osmInfoLink.setAnchors(top: osmButton.bottomAnchor, leading: contentView.leadingAnchor, insets: flatInsets)
        osmInfoLink.setTitle("osmLegalInfo".localize(), for: .normal)
        osmInfoLink.addTarget(self, action: #selector(openOSMInfo), for: .touchDown)
        
        preloadUrlTemplateField.setupView(labelText: "preloadUrlTemplate".localize(), text: Preferences.instance.preloadUrlTemplate, isHorizontal: false)
        contentView.addSubview(preloadUrlTemplateField)
        preloadUrlTemplateField.setAnchors(top: osmInfoLink.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, insets: defaultInsets)
        
        startZoomField.setupView(labelText: "startZoom".localize(), text: String(Int(Preferences.instance.startZoom)), isHorizontal: true)
        contentView.addSubview(startZoomField)
        startZoomField.setAnchors(top: preloadUrlTemplateField.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, insets: defaultInsets)
        
        maxLocationMergeDistanceField.setupView(labelText: "maxLocationMergeDistance".localize(), text: String(Int(Preferences.instance.maxLocationMergeDistance)), isHorizontal: true)
        contentView.addSubview(maxLocationMergeDistanceField)
        maxLocationMergeDistanceField.setAnchors(top: startZoomField.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, insets: defaultInsets)
        
        minTrackingDistanceField.setupView(labelText: "minTrackingDistance".localize(), text: String(Int(Preferences.instance.minTrackingDistance)), isHorizontal: true)
        contentView.addSubview(minTrackingDistanceField)
        minTrackingDistanceField.setAnchors(top: maxLocationMergeDistanceField.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, insets: defaultInsets)
        
        minTrackingIntervalField.setupView(labelText: "minTrackingInterval".localize(), text: String(Int(Preferences.instance.minTrackingInterval)), isHorizontal: true)
        contentView.addSubview(minTrackingIntervalField)
        minTrackingIntervalField.setAnchors(top: minTrackingDistanceField.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, insets: defaultInsets)
        
        maxPreloadTilesField.setupView(labelText: "maxPreloadTiles".localize(), text: String(Int(Preferences.instance.maxPreloadTiles)), isHorizontal: true)
        contentView.addSubview(maxPreloadTilesField)
        maxPreloadTilesField.setAnchors(top: minTrackingIntervalField.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, insets: defaultInsets)
        
        startWithLastPositionSwitch.setupView(labelText: "startWithLastPosition".localize(), isOn: Preferences.instance.startWithLastPosition)
        contentView.addSubview(startWithLastPositionSwitch)
        startWithLastPositionSwitch.setAnchors(top: maxPreloadTilesField.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, insets: defaultInsets)
        
        showPinsSwitch.setupView(labelText: "showPins".localize(), isOn: Preferences.instance.showPins)
        contentView.addSubview(showPinsSwitch)
        showPinsSwitch.setAnchors(top: startWithLastPositionSwitch.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, insets: defaultInsets)
        
        let saveButton = UIButton()
        saveButton.setTitle("save".localize(), for: .normal)
        saveButton.setTitleColor(.systemBlue, for: .normal)
        saveButton.addTarget(self, action: #selector(save), for: .touchDown)
        contentView.addSubview(saveButton)
        saveButton.setAnchors(top: showPinsSwitch.bottomAnchor, bottom: contentView.bottomAnchor, insets: doubleInsets)
        .centerX(contentView.centerXAnchor)
    }
    
    @objc func elbe5Template(){
        urlTemplateField.text = Preferences.elbe5Url
    }
    
    @objc func openElbe5Info() {
        UIApplication.shared.open(URL(string: "https://privacy.elbe5.de")!)
    }
    
    @objc func osmTemplate(){
        urlTemplateField.text = Preferences.osmUrl
    }
    
    @objc func openOSMInfo() {
        UIApplication.shared.open(URL(string: "https://operations.osmfoundation.org/policies/tiles/")!)
    }
    
    @objc func save(){
        let newTemplate = urlTemplateField.text
        if newTemplate != Preferences.instance.urlTemplate{
            Preferences.instance.urlTemplate = newTemplate
            _ = MapTiles.clear()
        }
        Preferences.instance.preloadUrlTemplate = preloadUrlTemplateField.text
        if let val = Int(maxLocationMergeDistanceField.text){
            Preferences.instance.maxLocationMergeDistance = CLLocationDistance(val)
        }
        if let val = Int(minTrackingDistanceField.text){
            Preferences.instance.minTrackingDistance = CLLocationDistance(val)
        }
        if let val = Int(minTrackingIntervalField.text){
            Preferences.instance.minTrackingInterval = CLLocationDistance(val)
        }
        if let val = Int(maxPreloadTilesField.text){
            Preferences.instance.maxPreloadTiles = val
        }
        if let val = Int(startZoomField.text){
            Preferences.instance.startZoom = val
        }
        Preferences.instance.startWithLastPosition = startWithLastPositionSwitch.isOn
        let showPins = showPinsSwitch.isOn
        if showPins != Preferences.instance.showPins{
            Preferences.instance.showPins = showPinsSwitch.isOn
            MainTabController.getMapViewController().updateLocationLayer()
        }
        Preferences.instance.save()
        showDone(title: "ok".localize(), text: "preferencesSaved".localize())
    }
    
}

