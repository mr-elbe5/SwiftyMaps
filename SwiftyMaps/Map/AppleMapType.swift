//
//  AppleMapType.swift
//  SwiftyMaps
//
//  Created by Michael Rönnau on 18.09.21.
//

import Foundation
import MapKit

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

}

class StandardMapType: AppleMapType{
    
    static let instance = StandardMapType()
    
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


