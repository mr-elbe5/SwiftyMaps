//
//  CLLocationCoordinate2D.swift
//  SwiftyMaps
//
//  Created by Michael Rönnau on 16.11.21.
//

import Foundation
import CoreLocation

extension CLLocationCoordinate2D : Equatable{
    
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
    
    public func closeTo(_ otherCoordinate: CLLocationCoordinate2D, maxDistance: CLLocationDistance = 10) -> Bool{
        distance(to: otherCoordinate) < maxDistance
    }
    
    public func distance(to coord: CLLocationCoordinate2D) -> CLLocationDistance{
        let latMid = (self.latitude + coord.latitude) / 2
        let latMetersPerDegree = 111132.954 - 559.822 * cos( 2 * latMid ) + 1.175 * cos( 4 * latMid)
        let lonMetersPerDegree = 111132.954 * cos ( latMid )
        let latDelta = abs(self.latitude - coord.latitude)
        let lonDelta = abs(self.longitude - coord.longitude)
        return sqrt(pow( latDelta * latMetersPerDegree,2) + pow( lonDelta * lonMetersPerDegree,2))
    }
    
}
