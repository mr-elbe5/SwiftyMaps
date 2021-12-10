/*
 SwiftyMaps
 App for display and use of OSM maps without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import UIKit
import AVKit
import CoreLocation

class Preferences: Identifiable, Codable{
    
    static var storeKey = "preferences"
    
    static var instance = Preferences()
    
    static var defaultUrl = "https://maps.elbe5.de/carto/{z}/{x}/{y}.png"
    static var defaultStartZoom : Int = 10
    static var defaultminLocationAccuracy : CLLocationDistance = 5.0
    static var defaultMaxLocationMergeDistance : CLLocationDistance = 10.0
    static var defaultPinGroupRadius : CGFloat = 8
    static var defaultMaxPreloadTiles : Int = 5000
    
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
        case minLocationAccuracy
        case maxLocationMergeDistance
        case pinGroupRadius
        case startWithLastPosition
        case maxPreloadTiles
        case showPins
    }

    var urlTemplate : String = defaultUrl
    var startZoom : Int = defaultStartZoom
    var minLocationAccuracy : CLLocationDistance = defaultminLocationAccuracy
    var maxLocationMergeDistance : CLLocationDistance = defaultMaxLocationMergeDistance
    var pinGroupRadius : CGFloat = defaultPinGroupRadius
    var startWithLastPosition : Bool = true
    var maxPreloadTiles : Int = defaultMaxPreloadTiles
    var showPins : Bool = true
    
    init(){
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        urlTemplate = try values.decodeIfPresent(String.self, forKey: .urlTemplate) ?? Preferences.defaultUrl
        startZoom = try values.decodeIfPresent(Int.self, forKey: .startZoom) ?? Preferences.defaultStartZoom
        minLocationAccuracy = try values.decodeIfPresent(CLLocationDistance.self, forKey: .minLocationAccuracy) ?? Preferences.defaultminLocationAccuracy
        maxLocationMergeDistance = try values.decodeIfPresent(CLLocationDistance.self, forKey: .maxLocationMergeDistance) ?? Preferences.defaultMaxLocationMergeDistance
        pinGroupRadius = try values.decodeIfPresent(CGFloat.self, forKey: .pinGroupRadius) ?? Preferences.defaultPinGroupRadius
        startWithLastPosition = try values.decodeIfPresent(Bool.self, forKey: .startWithLastPosition) ?? false
        maxPreloadTiles = try values.decodeIfPresent(Int.self, forKey: .maxPreloadTiles) ?? Preferences.defaultMaxPreloadTiles
        showPins = try values.decodeIfPresent(Bool.self, forKey: .showPins) ?? true
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(urlTemplate, forKey: .urlTemplate)
        try container.encode(startZoom, forKey: .startZoom)
        try container.encode(minLocationAccuracy, forKey: .minLocationAccuracy)
        try container.encode(maxLocationMergeDistance, forKey: .maxLocationMergeDistance)
        try container.encode(pinGroupRadius, forKey: .pinGroupRadius)
        try container.encode(startWithLastPosition, forKey: .startWithLastPosition)
        try container.encode(maxPreloadTiles, forKey: .maxPreloadTiles)
        try container.encode(showPins, forKey: .showPins)
    }
    
    func save(){
        DataController.shared.save(forKey: .preferences, value: self)
    }
    
    func dump(){
        print("urlTemplate = \(urlTemplate)" )
        print("startZoom = \(startZoom)" )
        print("minLocationAccuracy = \(minLocationAccuracy)" )
        print("maxLocationMergeDistance = \(maxLocationMergeDistance)" )
        print("pinGroupRadius = \(pinGroupRadius)" )
        print("startWithLastPosition = \(startWithLastPosition)" )
        print("maxPreloadTiles = \(maxPreloadTiles)" )
        print("showPins = \(showPins)" )
    }
    
}
