//
//  OverlayMapType.swift
//  SwiftyMaps
//
//  Created by Michael Rönnau on 18.09.21.
//

import Foundation
import MapKit

class OverlayMapType: MapType{
    
    var name : MapTypeName{
        get{
            .osm
        }
    }
    
    var mkMapType: MKMapType{
        get{
            .standard
        }
    }
    
    var showsAppleLabel : Bool{
        get{
            false
        }
    }
    
    var zoomRange : MKMapView.CameraZoomRange{
        get{
            MKMapView.CameraZoomRange(minCenterCoordinateDistance: -1, maxCenterCoordinateDistance: -1)!
        }
    }
    
    var usesTileOverlay : Bool {
        true
    }
    
    func getTileOverlay() -> MKTileOverlay?{
        nil
    }
    
}

class OpenStreetMapType: OverlayMapType{
    
    static let instance = OpenStreetMapType()
    
    override var zoomRange : MKMapView.CameraZoomRange{
        get{
            MKMapView.CameraZoomRange(minCenterCoordinateDistance: 100, maxCenterCoordinateDistance: 15000000)!
        }
    }
    
    override func getTileOverlay() -> MKTileOverlay?{
        let overlay =  MapTileOverlay(urlTemplate: Statics.cartoUrl)
        overlay.canReplaceMapContent = true
        overlay.maximumZ = 21
        return overlay
    }
    
}

class OpenTopoMapType: OverlayMapType{
    
    static let instance = OpenTopoMapType()
    
    override var name : MapTypeName{
        get{
            .topo
        }
    }
    
    override var zoomRange : MKMapView.CameraZoomRange{
        get{
            MKMapView.CameraZoomRange(minCenterCoordinateDistance: 1500, maxCenterCoordinateDistance: 15000000)!
        }
    }
    
    override func getTileOverlay() -> MKTileOverlay?{
        let overlay =  MapTileOverlay(urlTemplate: Statics.topoUrl)
        overlay.canReplaceMapContent = true
        overlay.maximumZ = 17
        return overlay
    }
    
}

