//
//  OverlayMapType.swift
//  SwiftyMaps
//
//  Created by Michael Rönnau on 18.09.21.
//

import Foundation
import MapKit

class OverlayMapType: MapType{
    
    private var _overlay: MapTileOverlay? = nil
    
    var maxZoom : Int{
        get{
            -1
        }
    }
    
    var overlay : MapTileOverlay?{
        get{
            _overlay
        }
        set{
            if let ovrl = newValue{
                ovrl.canReplaceMapContent = true
                ovrl.maximumZ = maxZoom
                ovrl.renderer = MKTileOverlayRenderer(tileOverlay: ovrl)
                ovrl.mapType = self.name.rawValue
                _overlay = ovrl
            }
            else{
                _overlay = nil
            }
        }
    }
    
    var name : MapTypeName{
        get{
            .carto
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
    
    static let instance = OpenStreetMapType()
    
    override init(){
        super.init()
        overlay = MapTileOverlay(urlTemplate: Statics.cartoUrl)
    }
    
    
    override var maxZoom : Int{
        get{
            18
        }
    }
    
    override var zoomRange : MKMapView.CameraZoomRange{
        get{
            MKMapView.CameraZoomRange(minCenterCoordinateDistance: 1500, maxCenterCoordinateDistance: 15000000)!
        }
    }
    
}

class OpenTopoMapType: OverlayMapType{
    
    static let instance = OpenTopoMapType()
    
    override init(){
        super.init()
        overlay = MapTileOverlay(urlTemplate: Statics.topoUrl)
    }
    
    override var maxZoom : Int{
        get{
            17
        }
    }
    
    override var name : MapTypeName{
        get{
            .topo
        }
    }
    
    override var zoomRange : MKMapView.CameraZoomRange{
        get{
            MKMapView.CameraZoomRange(minCenterCoordinateDistance: 3000, maxCenterCoordinateDistance: 15000000)!
        }
    }
    
}

