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

    var zoomLevel : Double{
        get{
            Statics.zoomLevel(from: frame.size, longitudeDelta: region.span.longitudeDelta)
        }
    }
    
    func centerToLocation(_ location: Location) {
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            span: region.span)
        setRegion(coordinateRegion, animated: true)
    }
    
    func centerToLocation(_ region: MKCoordinateRegion) {
        setRegion(region, animated: true)
    }
    
    func loadLastRegion(animated: Bool = true){
        if let codableRegion : CodableRegion = DataController.shared.load(forKey: .region){
            setRegion(codableRegion.region, animated: animated)
        }
    }
    
    func saveLastRegion(){
        let codableRegion = CodableRegion(region: region)
        DataController.shared.save(forKey: .region, value: codableRegion)
    }
    
}


