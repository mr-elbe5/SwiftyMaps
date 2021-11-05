/*
 OSM-Maps
 Project for displaying a map like OSM without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import CoreLocation

extension CLLocationManager{
    
    var authorized : Bool{
        get{
            switch authorizationStatus{
            case .authorizedAlways:
                return true
            case.authorizedWhenInUse:
                return true
            default:
                return false
            }
        }
    }
    
    var authorizedForTracking : Bool{
        get{
            authorizationStatus == .authorizedAlways
        }
    }
    
}
