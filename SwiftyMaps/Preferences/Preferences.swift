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
    
    static var elbe5Url = "https://maps.elbe5.de/carto/{z}/{x}/{y}.png"
    static var osmUrl = "https://tile.openstreetmap.org/{z}/{x}/{y}.png"
    static var defaultStartZoom : Int = 10
    static var defaultMaxLocationMergeDistance : CLLocationDistance = 10.0
    
    static func loadInstance(){
        if let prefs : Preferences = DataController.shared.load(forKey: Preferences.storeKey){
            instance = prefs
        }
        else{
            instance = Preferences()
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case urlTemplate
        case preloadUrlTemplate
        case startZoom
        case maxLocationMergeDistance
        case startWithLastPosition
        case showPins
        case showTrack
    }

    var urlTemplate : String = elbe5Url
    var preloadUrlTemplate : String = elbe5Url
    var startZoom : Int = defaultStartZoom
    var maxLocationMergeDistance : CLLocationDistance = defaultMaxLocationMergeDistance
    var startWithLastPosition : Bool = true
    var showPins : Bool = true
    var showTrack : Bool = true
    
    init(){
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        urlTemplate = try values.decodeIfPresent(String.self, forKey: .urlTemplate) ?? Preferences.elbe5Url
        preloadUrlTemplate = try values.decodeIfPresent(String.self, forKey: .preloadUrlTemplate) ?? Preferences.elbe5Url
        startZoom = try values.decodeIfPresent(Int.self, forKey: .startZoom) ?? Preferences.defaultStartZoom
        maxLocationMergeDistance = try values.decodeIfPresent(CLLocationDistance.self, forKey: .maxLocationMergeDistance) ?? Preferences.defaultMaxLocationMergeDistance
        startWithLastPosition = try values.decodeIfPresent(Bool.self, forKey: .startWithLastPosition) ?? false
        showPins = try values.decodeIfPresent(Bool.self, forKey: .showPins) ?? true
        showTrack = try values.decodeIfPresent(Bool.self, forKey: .showTrack) ?? true
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(urlTemplate, forKey: .urlTemplate)
        try container.encode(preloadUrlTemplate, forKey: .preloadUrlTemplate)
        try container.encode(startZoom, forKey: .startZoom)
        try container.encode(maxLocationMergeDistance, forKey: .maxLocationMergeDistance)
        try container.encode(startWithLastPosition, forKey: .startWithLastPosition)
        try container.encode(showPins, forKey: .showPins)
        try container.encode(showTrack, forKey: .showTrack)
    }
    
    func save(){
        DataController.shared.save(forKey: Preferences.storeKey, value: self)
    }
    
    
}
