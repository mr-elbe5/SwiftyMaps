//
//  MapPreferences.swift
//  OSM-Maps
//
//  Created by Michael Rönnau on 01.11.21.
//

import Foundation
import UIKit
import AVKit

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
        case mapTypeName
        case urlTemplate
        case startWithLastPosition
        case showUserDirection
        case showPlaceMarkers
        case flashMode
    }

    var urlTemplate : String = MapController.defaultUrl
    var startWithLastPosition : Bool = false
    var showUserDirection : Bool = true
    var showPlaceMarkers : Bool = true
    
    var flashMode : AVCaptureDevice.FlashMode = .off
    
    init(){
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        urlTemplate = try values.decodeIfPresent(String.self, forKey: .urlTemplate) ?? MapController.defaultUrl
        startWithLastPosition = try values.decodeIfPresent(Bool.self, forKey: .startWithLastPosition) ?? false
        showUserDirection = try values.decodeIfPresent(Bool.self, forKey: .showUserDirection) ?? true
        showPlaceMarkers = try values.decodeIfPresent(Bool.self, forKey: .showPlaceMarkers) ?? true
        flashMode = AVCaptureDevice.FlashMode(rawValue: try values.decode(Int.self, forKey: .flashMode)) ?? .off
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(urlTemplate, forKey: .urlTemplate)
        try container.encode(startWithLastPosition, forKey: .startWithLastPosition)
        try container.encode(showUserDirection, forKey: .showUserDirection)
        try container.encode(showPlaceMarkers, forKey: .showPlaceMarkers)
        try container.encode(flashMode.rawValue, forKey: .flashMode)
    }
    
    func save(){
        DataController.shared.save(forKey: .preferences, value: self)
    }
    
    func dump(){
        print("urlTemplate  = \(urlTemplate)" )
        print("startWithLastPosition  = \(startWithLastPosition)" )
        print("showUserDirection  = \(showUserDirection)" )
        print("showPlaces  = \(showPlaceMarkers)" )
    }
    
}
