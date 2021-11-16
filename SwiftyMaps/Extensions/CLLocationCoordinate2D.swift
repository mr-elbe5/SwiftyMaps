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
        MapCalculator.distanceBetween(coord1: self, coord2: otherCoordinate) < maxDistance
    }
    
}
