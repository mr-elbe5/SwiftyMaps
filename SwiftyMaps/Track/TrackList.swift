/*
 SwiftyMaps
 App for display and use of OSM maps without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation

typealias TrackList = Array<TrackData>
    
extension TrackList{
    
    static func load() -> TrackList{
        if let tracks : TrackList = DataController.shared.load(forKey: .tracks){
            return tracks
        }
        else{
            return TrackList()
        }
    }
    
    static func save(_ list: TrackList){
        DataController.shared.save(forKey: .tracks, value: list)
    }
    
}
