//
//  MKMapView.swift
//
//  Created by Michael Rönnau on 10.08.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit
import MapKit

extension MKMapView {


    func setMkMapType(from type: MapType) {
        mapType = type.mkMapType
        setCameraZoomRange(type.zoomRange, animated: true)
    }

    var zoomLevel : Int{
        get{
            Int(round(log2(Double(360 * frame.size.width) / (region.span.longitudeDelta * 128))))
        }
    }
    
    func centerToLocation(_ location: Location) {
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            span: MKCoordinateSpan(latitudeDelta: location.latitudeSpan, longitudeDelta: location.longitudeSpan))
        setRegion(coordinateRegion, animated: true)
    }
    
}
