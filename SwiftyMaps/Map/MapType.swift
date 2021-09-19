//
// Created by Michael Rönnau on 14.09.21.
//

import Foundation
import MapKit

enum MapTypeName: String{
    case standard
    case carto
    case topo
    case satellite
    
    func getMapType() -> MapType{
        switch self{
        case .standard: return StandardMapType.instance
        case .carto: return OpenStreetMapType.instance
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
    func getTileOverlay() -> MapTileOverlay?
}
