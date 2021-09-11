//
//  CLLocationManager.swift
//  myprivatetrack
//
//  Created by Michael Rönnau on 31.08.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

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
