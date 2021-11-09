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
        if let prefs : Preferences = DataController.shared.load(forKey: .settings){
            instance = prefs
        }
        else{
            instance = Preferences()
        }
        instance.dump()
    }
    
    enum CodingKeys: String, CodingKey {
        case mapTypeName
        case cartoUrlTemplate
        case topoUrlTemplate
        case startWithLastPosition
        case showUserDirection
        case showAnnotations
        case flashMode
    }

    var mapTypeName : String = MapType.current.name
    var cartoUrlTemplate : String = MapType.current.tileUrl
    var topoUrlTemplate : String = MapType.current.tileUrl
    var startWithLastPosition : Bool = false
    var showUserDirection : Bool = true
    var showAnnotations : Bool = true
    var flashMode : AVCaptureDevice.FlashMode = .off
    
    init(){
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        mapTypeName = try values.decodeIfPresent(String.self, forKey: .mapTypeName) ?? MapType.current.name
        cartoUrlTemplate = try values.decodeIfPresent(String.self, forKey: .cartoUrlTemplate) ?? MapType.carto.tileUrl
        topoUrlTemplate = try values.decodeIfPresent(String.self, forKey: .topoUrlTemplate) ?? MapType.topo.tileUrl
        startWithLastPosition = try values.decodeIfPresent(Bool.self, forKey: .startWithLastPosition) ?? false
        showUserDirection = try values.decodeIfPresent(Bool.self, forKey: .showUserDirection) ?? true
        showAnnotations = try values.decodeIfPresent(Bool.self, forKey: .showAnnotations) ?? true
        flashMode = AVCaptureDevice.FlashMode(rawValue: try values.decode(Int.self, forKey: .flashMode)) ?? .off
        if let mapType = MapType.getMapType(name: mapTypeName){
            MapType.current = mapType
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(mapTypeName, forKey: .mapTypeName)
        try container.encode(cartoUrlTemplate, forKey: .cartoUrlTemplate)
        try container.encode(topoUrlTemplate, forKey: .topoUrlTemplate)
        try container.encode(startWithLastPosition, forKey: .startWithLastPosition)
        try container.encode(showUserDirection, forKey: .showUserDirection)
        try container.encode(showAnnotations, forKey: .showAnnotations)
        try container.encode(flashMode.rawValue, forKey: .flashMode)
    }
    
    func save(){
        DataController.shared.save(forKey: .settings, value: self)
    }
    
    func dump(){
        print("mapTypeName  = \(mapTypeName)" )
        print("cartoUrlTemplate  = \(cartoUrlTemplate)" )
        print("topoUrlTemplate  = \(topoUrlTemplate)" )
        print("startWithLastPosition  = \(startWithLastPosition)" )
        print("showUserDirection  = \(showUserDirection)" )
        print("showAnnotations  = \(showAnnotations)" )
    }
    
}
