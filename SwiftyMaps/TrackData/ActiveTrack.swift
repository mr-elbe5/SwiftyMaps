/*
 SwiftyMaps
 App for display and use of OSM maps without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import CoreLocation
import UIKit

class ActiveTrack{
    
    static var track : TrackData? = nil
    static var isTracking : Bool = false
    
    static func startTracking(startLocation: Location){
        if track == nil{
            track = TrackData(startLocation: startLocation)
            track!.trackpoints.append(Position(location: startLocation.cllocation))
        }
        isTracking = true
    }
    
    static func updateTrack(with position: Position){
        if let track = track{
            track.updateTrack(position)
        }
    }
    
    static func pauseTracking(){
        if let track = track{
            track.pauseTracking()
            isTracking = false
        }
    }
    
    static func resumeTracking(){
        if let track = track{
            track.resumeTracking()
            isTracking = true
        }
    }
    
    static func stopTracking(){
        if track != nil{
            isTracking = false
            track = nil
        }
    }
    
}
