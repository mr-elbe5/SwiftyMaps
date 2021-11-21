//
//  GeneralPreferences.swift
//  SwiftyMaps
//
//  Created by Michael Rönnau on 21.11.21.
//

import Foundation
import UIKit
import AVKit

class GeneralPreferences: Identifiable, Codable{
    
    static var storeKey = "generalPreferences"
    
    static var instance = GeneralPreferences()
    
    static func loadInstance(){
        if let prefs : GeneralPreferences = DataController.shared.load(forKey: .preferences){
            instance = prefs
        }
        else{
            instance = GeneralPreferences()
        }
        instance.dump()
    }
    
    enum CodingKeys: String, CodingKey {
        case flashMode
    }

    var flashMode : AVCaptureDevice.FlashMode = .off
    
    init(){
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        flashMode = AVCaptureDevice.FlashMode(rawValue: try values.decode(Int.self, forKey: .flashMode)) ?? .off
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(flashMode.rawValue, forKey: .flashMode)
    }
    
    func save(){
        DataController.shared.save(forKey: .preferences, value: self)
    }
    
    func dump(){
        print("flashMode  = \(flashMode)" )
    }
    
}
