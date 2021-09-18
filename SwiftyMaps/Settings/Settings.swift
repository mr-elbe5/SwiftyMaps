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
        case startWithLastPosition
        case showUserLocation
        case showPins
    }

    var mapTypeName : MapTypeName = .standard
    var startWithLastPosition : Bool = false
    var showUserLocation : Bool = true
    var showPins : Bool = true
    
    init(){
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        mapTypeName = MapTypeName(rawValue: try values.decode(String.self, forKey: .mapType)) ?? MapTypeName.standard
        print("mapname: \(mapTypeName)")
        startWithLastPosition = try values.decodeIfPresent(Bool.self, forKey: .startWithLastPosition) ?? false
        showUserLocation = try values.decodeIfPresent(Bool.self, forKey: .showUserLocation) ?? true
        showPins = try values.decodeIfPresent(Bool.self, forKey: .showPins) ?? true
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(mapTypeName.rawValue, forKey: .mapType)
        try container.encode(startWithLastPosition, forKey: .startWithLastPosition)
        try container.encode(showUserLocation, forKey: .showUserLocation)
        try container.encode(showPins, forKey: .showPins)
    }
    
    func save(){
        DataController.shared.save(forKey: .settings, value: self)
    }
    
}
