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
    
    static var shared = Settings()
    
    static func load(){
        Settings.shared = DataController.shared.load(forKey: .settings) ?? Settings()
    }
    
    enum CodingKeys: String, CodingKey {
        case mapType
        case location
        case startWithLastPosition
        case showUserLocation
        case showAnnotations
    }

    var mapType : MKMapView.MapType = .standard
    var region : MKCoordinateRegion? = nil
    var startWithLastPosition : Bool = false
    var showUserLocation : Bool = true
    var showAnnotations : Bool = true
    
    init(){
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        mapType = MKMapView.MapType(rawValue: try values.decode(String.self, forKey: .mapType)) ?? MKMapView.MapType.standard
        if let location = try values.decodeIfPresent(Location.self, forKey: .location){
            region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: location.latitudeSpan, longitudeDelta: location.longitudeSpan))
        }
        else{
            region = nil
        }
        startWithLastPosition = try values.decodeIfPresent(Bool.self, forKey: .startWithLastPosition) ?? false
        showUserLocation = try values.decodeIfPresent(Bool.self, forKey: .showUserLocation) ?? true
        showAnnotations = try values.decodeIfPresent(Bool.self, forKey: .showAnnotations) ?? true
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(mapType.rawValue, forKey: .mapType)
        if let region = region{
            let location = Location(region.center, latitudeSpan: region.span.latitudeDelta, longitudeSpan: region.span.longitudeDelta)
            try container.encode(location, forKey: .location)
        }
        try container.encode(startWithLastPosition, forKey: .startWithLastPosition)
        try container.encode(showUserLocation, forKey: .showUserLocation)
        try container.encode(showAnnotations, forKey: .showAnnotations)
    }
    
    func save(){
        DataController.shared.save(forKey: .settings, value: self)
    }
    
}
