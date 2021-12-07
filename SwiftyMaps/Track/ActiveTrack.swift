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
    
    static func startTracking(){
        if track == nil{
            guard let location = LocationService.shared.lastLocation else {return}
            track = TrackData()
            track!.trackpoints.append(TrackPoint(location: location))
        }
        isTracking = true
    }
    
    static func updateTrack(with location: CLLocation){
        if let track = track{
            track.updateTrack(location)
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
