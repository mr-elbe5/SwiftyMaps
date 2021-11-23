//
//  MapPreferences.swift
//  OSM-Maps
//
//  Created by Michael Rönnau on 01.11.21.
//

import Foundation
import UIKit
import AVKit

class MapPreferences: Identifiable, Codable{
    
    static var storeKey = "preferences"
    
    static var instance = MapPreferences()
    
    static func loadInstance(){
        if let prefs : MapPreferences = DataController.shared.load(forKey: .preferences){
            instance = prefs
        }
        else{
            instance = MapPreferences()
        }
        instance.dump()
    }
    
    enum CodingKeys: String, CodingKey {
        case urlTemplate
        case startWithLastPosition
        case showPlaceMarkers
    }

    var urlTemplate : String = MapController.defaultUrl
    var startWithLastPosition : Bool = false
    var showPlaceMarkers : Bool = true
    
    init(){
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        urlTemplate = try values.decodeIfPresent(String.self, forKey: .urlTemplate) ?? MapController.defaultUrl
        startWithLastPosition = try values.decodeIfPresent(Bool.self, forKey: .startWithLastPosition) ?? false
        showPlaceMarkers = try values.decodeIfPresent(Bool.self, forKey: .showPlaceMarkers) ?? true
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(urlTemplate, forKey: .urlTemplate)
        try container.encode(startWithLastPosition, forKey: .startWithLastPosition)
        try container.encode(showPlaceMarkers, forKey: .showPlaceMarkers)
    }
    
    func save(){
        DataController.shared.save(forKey: .preferences, value: self)
    }
    
    func dump(){
        print("urlTemplate  = \(urlTemplate)" )
        print("startWithLastPosition  = \(startWithLastPosition)" )
        print("showPlaces  = \(showPlaceMarkers)" )
    }
    
}
