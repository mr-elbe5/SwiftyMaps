//
//  Settings.swift
//
//  Created by Michael Rönnau on 03.06.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import AVFoundation

class Settings: Identifiable, Codable{
    
    static var instance = Settings()
    
    static func createAndLoadInstance(){
        Settings.instance = DataController.shared.load(forKey: .settings) ?? Settings()
    }
    
    enum CodingKeys: String, CodingKey {
        case mapType
        case cartoUrl
        case topoUrl
        case startWithLastPosition
        case showUserLocation
        case showMarkers
    }

    var mapTypeName : MapTypeName = .standard
    var cartoUrl : String = Statics.cartoUrl
    var topoUrl : String = Statics.topoUrl
    var startWithLastPosition : Bool = false
    var showUserLocation : Bool = true
    var showMarkers : Bool = true
    
    init(){
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        mapTypeName = MapTypeName(rawValue: try values.decode(String.self, forKey: .mapType)) ?? MapTypeName.standard
        cartoUrl = try values.decodeIfPresent(String.self, forKey: .cartoUrl) ?? Statics.cartoUrl
        topoUrl = try values.decodeIfPresent(String.self, forKey: .topoUrl) ?? Statics.topoUrl
        startWithLastPosition = try values.decodeIfPresent(Bool.self, forKey: .startWithLastPosition) ?? false
        showUserLocation = try values.decodeIfPresent(Bool.self, forKey: .showUserLocation) ?? true
        showMarkers = try values.decodeIfPresent(Bool.self, forKey: .showMarkers) ?? true
        updateOverlays()
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(mapTypeName.rawValue, forKey: .mapType)
        try container.encode(cartoUrl, forKey: .cartoUrl)
        try container.encode(topoUrl, forKey: .topoUrl)
        try container.encode(startWithLastPosition, forKey: .startWithLastPosition)
        try container.encode(showUserLocation, forKey: .showUserLocation)
        try container.encode(showMarkers, forKey: .showMarkers)
    }
    
    func updateOverlays(){
        OpenStreetMapType.instance.overlay = MapTileOverlay(urlTemplate: cartoUrl)
        OpenTopoMapType.instance.overlay = MapTileOverlay(urlTemplate: topoUrl)
    }
    
    func save(){
        DataController.shared.save(forKey: .settings, value: self)
    }
    
}
