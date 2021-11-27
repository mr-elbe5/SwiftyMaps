//
//  Preferences.swift
//  OSM-Maps
//
//  Created by Michael Rönnau on 01.11.21.
//

import Foundation
import UIKit
import AVKit
import CoreLocation

class Preferences: Identifiable, Codable{
    
    static var storeKey = "preferences"
    
    static var instance = Preferences()
    
    static func loadInstance(){
        if let prefs : Preferences = DataController.shared.load(forKey: .preferences){
            instance = prefs
        }
        else{
            instance = Preferences()
        }
        instance.dump()
    }
    
    enum CodingKeys: String, CodingKey {
        case urlTemplate
        case startZoom
        case distanceFilter
        case headingFilter
        case minHorizontalAccuracy
        case minVerticalAccuracy
        case minZoomToShowPlaces
        case startWithLastPosition
        case maxPreloadTiles
        case showPins
    }

    var urlTemplate : String = MapStatics.defaultUrl
    var startZoom : Int = 10
    var distanceFilter : CLLocationDistance = 5.0
    var headingFilter : CLLocationDistance = 2.0
    var minHorizontalAccuracy : CLLocationDistance = 10.0
    var minVerticalAccuracy : CLLocationDistance = 5.0
    var minZoomToShowPlaces : Int = 8
    var startWithLastPosition : Bool = true
    var maxPreloadTiles : Int = 5000
    var showPins : Bool = true
    
    init(){
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        urlTemplate = try values.decodeIfPresent(String.self, forKey: .urlTemplate) ?? MapStatics.defaultUrl
        startZoom = try values.decodeIfPresent(Int.self, forKey: .startZoom) ?? 10
        distanceFilter = try values.decodeIfPresent(CLLocationDistance.self, forKey: .distanceFilter) ?? 5.0
        headingFilter = try values.decodeIfPresent(CLLocationDistance.self, forKey: .headingFilter) ?? 2.0
        minHorizontalAccuracy = try values.decodeIfPresent(CLLocationDistance.self, forKey: .minHorizontalAccuracy) ?? 10.0
        minVerticalAccuracy = try values.decodeIfPresent(CLLocationDistance.self, forKey: .minVerticalAccuracy) ?? 5.0
        minZoomToShowPlaces = try values.decodeIfPresent(Int.self, forKey: .minZoomToShowPlaces) ?? 8
        startWithLastPosition = try values.decodeIfPresent(Bool.self, forKey: .startWithLastPosition) ?? false
        maxPreloadTiles = try values.decodeIfPresent(Int.self, forKey: .maxPreloadTiles) ?? 5000
        showPins = try values.decodeIfPresent(Bool.self, forKey: .showPins) ?? true
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(urlTemplate, forKey: .urlTemplate)
        try container.encode(startZoom, forKey: .startZoom)
        try container.encode(distanceFilter, forKey: .distanceFilter)
        try container.encode(headingFilter, forKey: .headingFilter)
        try container.encode(minHorizontalAccuracy, forKey: .minHorizontalAccuracy)
        try container.encode(minVerticalAccuracy, forKey: .minVerticalAccuracy)
        try container.encode(minZoomToShowPlaces, forKey: .minZoomToShowPlaces)
        try container.encode(startWithLastPosition, forKey: .startWithLastPosition)
        try container.encode(maxPreloadTiles, forKey: .maxPreloadTiles)
        try container.encode(showPins, forKey: .showPins)
    }
    
    func save(){
        DataController.shared.save(forKey: .preferences, value: self)
    }
    
    func dump(){
        print("urlTemplate  = \(urlTemplate)" )
        print("startWithLastPosition  = \(startWithLastPosition)" )
        print("showPins  = \(showPins)" )
    }
    
}
