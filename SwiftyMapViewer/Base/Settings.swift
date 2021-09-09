//
//  Settings.swift
//
//  Created by Michael Rönnau on 03.06.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class Settings: Identifiable, Codable{
    
    static var shared = Settings()
    
    static func load(){
        Settings.shared = DataController.shared.load(forKey: .settings) ?? Settings()
    }
    
    enum CodingKeys: String, CodingKey {
        case mapStartSize
    }
    
    var mapStartSize : MapStartSize = .mid
    
    var mapStartSizeIndex : Int{
        get{
            switch mapStartSize{
            case .small:
                return 0
            case .mid:
                return 1
            case .large:
                return 2
            }
        }
    }
    
    init(){
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        mapStartSize = MapStartSize(rawValue: try values.decode(Double.self, forKey: .mapStartSize)) ?? MapStartSize.mid
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Double(mapStartSize.rawValue), forKey: .mapStartSize)
    }
    
    func save(){
        DataController.shared.save(forKey: .settings, value: self)
    }
    
}
