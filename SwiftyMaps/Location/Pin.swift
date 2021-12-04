/*
 SwiftyMaps
 App for display and use of OSM maps without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */

import UIKit

class Pin : UIButton{
    
    static var baseFrame = CGRect(x: -MapStatics.mapPinRadius, y: -2*MapStatics.mapPinRadius, width: 2*MapStatics.mapPinRadius, height: 2*MapStatics.mapPinRadius)
    
    static var defaultPinColor = UIColor(red: 1.0, green: 0, blue: 0, alpha: 1)
    static var photoPinColor = UIColor(red: 0.75, green: 0.0, blue: 0.75, alpha: 1)
    static var trackPinColor = UIColor(red: 0.25, green: 0.0, blue: 0.75, alpha: 1)
    static var photoTrackPinColor = UIColor(red: 0.75, green: 0.0, blue: 0.25, alpha: 1)
    
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
    
    func updateColor(){
        tintColor = hasPhotos ? (hasTracks ? Pin.photoTrackPinColor : Pin.photoPinColor) : (hasTracks ? Pin.trackPinColor : Pin.defaultPinColor)
    }
    
}


