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
    
    static func getMapType(name: MapTypeName) -> MapType{
        switch name{
        case .standard: return StandardMapType.shared
        case .osm: return OpenStreetMapType.shared
        case .topo: return OpenTopoMapType.shared
        case .satellite: return SatelliteMapType.shared
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
}

class StandardMapType: MapType{
    
    static let shared = StandardMapType()
    
    var name : MapTypeName{
        get{
            .standard
        }
    }

    var mkMapType: MKMapType{
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
    
}

class OpenStreetMapType: MapType{
    
    static let shared = OpenStreetMapType()
    
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
            MKMapView.CameraZoomRange(minCenterCoordinateDistance: 200, maxCenterCoordinateDistance: 15000000)!
        }
    }
    
    var usesTileOverlay : Bool {
        true
    }
    
    func getTileOverlay() -> MKTileOverlay?{
        let overlay =  MKTileOverlay(urlTemplate: Statics.cartoUrl)
        overlay.canReplaceMapContent = true
        overlay.maximumZ = 20
        return overlay
    }
    
}

class OpenTopoMapType: MapType{
    
    static let shared = OpenTopoMapType()
    
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
        let overlay =  MKTileOverlay(urlTemplate: Statics.topoUrl)
        overlay.canReplaceMapContent = true
        overlay.maximumZ = 17
        return overlay
    }
    
}

class SatelliteMapType: MapType{
    
    static let shared = SatelliteMapType()
    
    var name : MapTypeName{
        get{
            .satellite
        }
    }
    
    var mkMapType : MKMapType{
        get{
            .satellite
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
    
}

