//
// Created by Michael Rönnau on 14.09.21.
//

import Foundation
import MapKit

enum MapTypeName: String{
    case standard
    case osm
    case topo
    case satellite
    
    func getMapType() -> MapType{
        switch self{
        case .standard: return StandardMapType.instance
        case .osm: return OpenStreetMapType.instance
        case .topo: return OpenTopoMapType.instance
        case .satellite: return SatelliteMapType.instance
        }
    }
}

protocol MapType{
    var name : MapTypeName {get}
    var mkMapType : MKMapType {get}
    var showsAppleLabel : Bool {get}
    var zoomRange : MKMapView.CameraZoomRange {get}
    var usesTileOverlay : Bool {get}
    func getTileOverlay() -> MKTileOverlay?
    func getTileOverlayRenderer(overlay: MKTileOverlay) -> MKTileOverlayRenderer?
}

class AppleMapType : MapType{
    
    var mkMapType: MKMapType{
        get{
            .standard
        }
    }
    
    var name: MapTypeName{
        get{
            .standard
        }
    }
    
    
    var showsAppleLabel: Bool{
        get{
            true
        }
    }
    
    var zoomRange: MKMapView.CameraZoomRange{
        get{
            MKMapView.CameraZoomRange(minCenterCoordinateDistance: -1, maxCenterCoordinateDistance: -1)!
        }
    }
    
    var usesTileOverlay : Bool {
        false
    }
    
    func getTileOverlay() -> MKTileOverlay?{
        nil
    }
    
    func getTileOverlayRenderer(overlay: MKTileOverlay) -> MKTileOverlayRenderer?{
        nil
    }
}

class StandardMapType: AppleMapType{
    
    static let instance = StandardMapType()
    
}

class OpenStreetMapType: MapType{
    
    static let instance = OpenStreetMapType()
    
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
            MKMapView.CameraZoomRange(minCenterCoordinateDistance: 350, maxCenterCoordinateDistance: 15000000)!
        }
    }
    
    var usesTileOverlay : Bool {
        true
    }
    
    func getTileOverlay() -> MKTileOverlay?{
        let overlay =  OpenStreetMapOverlay(urlTemplate: Statics.cartoUrl)
        overlay.canReplaceMapContent = true
        overlay.maximumZ = 19
        return overlay
    }
    
    func getTileOverlayRenderer(overlay: MKTileOverlay) -> MKTileOverlayRenderer?{
        OpenStreetMapOverlayRenderer(tileOverlay: overlay)
    }
    
    class OpenStreetMapOverlay : MKTileOverlay{
        
    }
    
    class OpenStreetMapOverlayRenderer : MKTileOverlayRenderer{
        
    }
    
}

class OpenTopoMapType: MapType{
    
    static let instance = OpenTopoMapType()
    
    var name : MapTypeName{
        get{
            .topo
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
            MKMapView.CameraZoomRange(minCenterCoordinateDistance: 1500, maxCenterCoordinateDistance: 15000000)!
        }
    }
    
    var usesTileOverlay : Bool {
        true
    }
    
    func getTileOverlay() -> MKTileOverlay?{
        let overlay =  OpenTopoMapOverlay(urlTemplate: Statics.topoUrl)
        overlay.canReplaceMapContent = true
        overlay.maximumZ = 17
        return overlay
    }
    
    func getTileOverlayRenderer(overlay: MKTileOverlay) -> MKTileOverlayRenderer?{
        OpenTopoMapOverlayRenderer(tileOverlay: overlay)
    }
    
    class OpenTopoMapOverlay : MKTileOverlay{
        
    }
    
    class OpenTopoMapOverlayRenderer : MKTileOverlayRenderer{
        
    }
    
}

class SatelliteMapType: AppleMapType{
    
    static let instance = SatelliteMapType()
    
    override var name : MapTypeName{
        get{
            .satellite
        }
    }
    
    override var mkMapType : MKMapType{
        get{
            .satellite
        }
    }
    
}

