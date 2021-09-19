//
//  OverlayMapType.swift
//  SwiftyMaps
//
//  Created by Michael Rönnau on 18.09.21.
//

import Foundation
import MapKit

class OverlayMapType: MapType{
    
    var overlay: MapTileOverlay
    
    init(overlay: MapTileOverlay, maxZoom: Int){
        overlay.canReplaceMapContent = true
        overlay.maximumZ = maxZoom
        overlay.renderer = MKTileOverlayRenderer(tileOverlay: overlay)
        self.overlay = overlay
    }
    
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
    
    func getTileOverlay() -> MapTileOverlay?{
        overlay
    }
    
}

class OpenStreetMapType: OverlayMapType{
    
    static let instance = OpenStreetMapType(overlay: MapTileOverlay(urlTemplate: Statics.cartoUrl), maxZoom: 20)
    
    override var zoomRange : MKMapView.CameraZoomRange{
        get{
            MKMapView.CameraZoomRange(minCenterCoordinateDistance: 100, maxCenterCoordinateDistance: 15000000)!
        }
    }
    
}

class OpenTopoMapType: OverlayMapType{
    
    static let instance = OpenTopoMapType(overlay: MapTileOverlay(urlTemplate: Statics.topoUrl), maxZoom: 17)
    
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
    
}

