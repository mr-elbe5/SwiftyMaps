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

    enum MapType: String{
        case standard
        case openStreetMap
        case openTopoMap
        case satellite
    }

    static let zoomRangeDefault = MKMapView.CameraZoomRange(minCenterCoordinateDistance: -1, maxCenterCoordinateDistance: -1)!
    static let zoomRange20 = MKMapView.CameraZoomRange(minCenterCoordinateDistance: 175, maxCenterCoordinateDistance: -1)!
    static let zoomRange17 = MKMapView.CameraZoomRange(minCenterCoordinateDistance: 1380, maxCenterCoordinateDistance: -1)!

    func setMapType(_ type: MapType) {
        switch type {
        case .standard:
            mapType = .standard
            setCameraZoomRange(MKMapView.zoomRangeDefault, animated: true)
        case .openStreetMap:
            mapType = .standard
            setCameraZoomRange(MKMapView.zoomRange20, animated: true)
        case .openTopoMap:
            mapType = .standard
            setCameraZoomRange(MKMapView.zoomRange17, animated: true)
        case .satellite:
            mapType = .satellite
            setCameraZoomRange(MKMapView.zoomRangeDefault, animated: true)
        }
    }

    func showAppleLabels(_ type: MapType) -> Bool{
        switch type {
        case .standard:
            return true
        case .openStreetMap:
            return false
        case .openTopoMap:
            return false
        case .satellite:
            return true
        }
    }
    
    var zoomLevel : Int{
        get{
            Int(round(log2(Double(360 * frame.size.width) / (region.span.longitudeDelta * 128))))
        }
    }
    
    func centerToLocation(_ location: Location,regionRadius: CLLocationDistance) {
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
    
}
