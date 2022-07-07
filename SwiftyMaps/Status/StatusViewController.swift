//
//  DebugViewController.swift
//  SwiftyMaps for OSM
//
//  Created by Michael Rönnau on 06.07.22.
//

import Foundation
import UIKit
import CoreLocation

class StatusViewController : ScrollViewController{
    
    var authorizationField = LabeledTextField()
    var latitudeField = LabeledTextField()
    var longitudeField = LabeledTextField()
    var horizontalAccuracyField = LabeledTextField()
    var altitudeField = LabeledTextField()
    var verticalAccuracyField = LabeledTextField()
    var directionField = LabeledTextField()
    
    override func loadView() {
        title = "status".localize()
        super.loadView()
        authorizationField.setupView(labelText: "authorization".localize(), text: "not authorized", isHorizontal: true)
        contentView.addSubview(authorizationField)
        authorizationField.setAnchors(top: contentView.topAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, insets: defaultInsets)
        latitudeField.setupView(labelText: "latitude".localize(), text: "", isHorizontal: true)
        contentView.addSubview(latitudeField)
        latitudeField.setAnchors(top: authorizationField.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, insets: defaultInsets)
        longitudeField.setupView(labelText: "longitude".localize(), text: "", isHorizontal: true)
        contentView.addSubview(longitudeField)
        longitudeField.setAnchors(top: latitudeField.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, insets: defaultInsets)
        horizontalAccuracyField.setupView(labelText: "accuracy".localize(), text: "", isHorizontal: true)
        contentView.addSubview(horizontalAccuracyField)
        horizontalAccuracyField.setAnchors(top: longitudeField.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, insets: defaultInsets)
        altitudeField.setupView(labelText: "altitude".localize(), text: "" , isHorizontal: true)
        contentView.addSubview(altitudeField)
        altitudeField.setAnchors(top: horizontalAccuracyField.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, insets: defaultInsets)
        verticalAccuracyField.setupView(labelText: "accuracy".localize(), text: "", isHorizontal: true)
        contentView.addSubview(verticalAccuracyField)
        verticalAccuracyField.setAnchors(top: altitudeField.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, insets: defaultInsets)
        directionField.setupView(labelText: "direction".localize(), text: "" , isHorizontal: true)
        contentView.addSubview(directionField)
        directionField.setAnchors(top: verticalAccuracyField.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, insets: defaultInsets)
        LocationService.shared.delegates.append(self)
        authorizationDidChange(authorization: LocationService.shared.authorization)
    }
    
}

extension StatusViewController: LocationServiceDelegate{
    
    func authorizationDidChange(authorization: CLAuthorizationStatus) {
        var txt : String
        switch authorization{
        case .authorizedAlways: txt = "always"
        case .authorizedWhenInUse: txt = "when in use"
        default: txt = "not authorized"
        }
        authorizationField.text = txt
    }
    
    func positionDidChange(position: Position) {
        latitudeField.text = "\(position.coordinate.latitude)"
        longitudeField.text = "\(position.coordinate.longitude)"
        horizontalAccuracyField.text = "\(position.horizontalAccuracy)"
        altitudeField.text = "\(position.altitude)"
        verticalAccuracyField.text = "\(position.verticalAccuracy)"
    }
    
    func directionDidChange(direction: Int) {
        directionField.text = "\(direction)"
    }
    
}
