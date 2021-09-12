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
        case position
    }

    var mapType : MKMapView.MapType = .standard
    
    init(){
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        mapType = MKMapView.MapType(rawValue: try values.decode(String.self, forKey: .mapType)) ?? MKMapView.MapType.standard
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(mapType.rawValue, forKey: .mapType)
    }
    
    func save(){
        DataController.shared.save(forKey: .settings, value: self)
    }
    
}
