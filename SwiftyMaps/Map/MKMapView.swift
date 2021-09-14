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
    static let cartoZoomRange = MKMapView.CameraZoomRange(minCenterCoordinateDistance: 200, maxCenterCoordinateDistance: 15000000)!
    static let topoZoomRange = MKMapView.CameraZoomRange(minCenterCoordinateDistance: 1500, maxCenterCoordinateDistance: 15000000)!

    func setMapType(_ type: MapType) {
        switch type {
        case .standard:
            mapType = .standard
            setCameraZoomRange(MKMapView.zoomRangeDefault, animated: true)
        case .openStreetMap:
            mapType = .standard
            setCameraZoomRange(MKMapView.cartoZoomRange, animated: true)
        case .openTopoMap:
            mapType = .standard
            setCameraZoomRange(MKMapView.topoZoomRange, animated: true)
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
    
    func setTileOverlay(with urlTemplate: String) -> MKTileOverlay{
        let overlay = MKTileOverlay(urlTemplate: urlTemplate)
        overlay.canReplaceMapContent = true
        addOverlay(overlay, level: .aboveLabels)
        return overlay
    }
    
    func removeTileOverlay(_ overlay: MKTileOverlay){
        removeOverlay(overlay)
    }
    
}
