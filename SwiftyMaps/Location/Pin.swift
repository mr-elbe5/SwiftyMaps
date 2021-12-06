/*
 SwiftyMaps
 App for display and use of OSM maps without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */

import UIKit

class Pin : UIButton{
    
    static var baseFrame = CGRect(x: -MapStatics.mapPinRadius, y: -2*MapStatics.mapPinRadius, width: 2*MapStatics.mapPinRadius, height: 2*MapStatics.mapPinRadius)
    
    var hasPhotos : Bool{
        false
    }
    
    var hasTracks: Bool{
        false
    }
    
    func updatePosition(to pos: CGPoint){
        frame = LocationPin.baseFrame.offsetBy(dx: pos.x, dy: pos.y)
        setNeedsDisplay()
    }
    
    func updateImage(){
    }
    
}


