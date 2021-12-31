/*
 SwiftyMaps
 App for display and use of OSM maps without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import CoreLocation

extension CLLocationManager{
    
    var authorized : Bool{
        switch authorizationStatus{
        case .authorizedAlways:
            return true
        case.authorizedWhenInUse:
            return true
        default:
            return false
        }
    }
    
    var authorizedForTracking : Bool{
        authorizationStatus == .authorizedAlways
    }
    
}
