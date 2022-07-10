/*
 SwiftyMaps
 App for display and use of OSM maps without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation

typealias TrackList = Array<TrackData>
    
extension TrackList{
    
    mutating func remove(_ track: TrackData){
        for idx in 0..<self.count{
            if self[idx] == track{
                self.remove(at: idx)
                return
            }
        }
    }
    
}
