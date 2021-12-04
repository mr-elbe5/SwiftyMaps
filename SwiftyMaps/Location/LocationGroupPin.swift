/*
 SwiftyMaps
 App for display and use of OSM maps without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */

import UIKit

class LocationGroupPin : Pin{
    
    var locationGroup : LocationGroup
    
    init(locationGroup: LocationGroup){
        self.locationGroup = locationGroup
        super.init(frame: Pin.baseFrame)
        var img  = MapStatics.mapPinEllipseImage
        let fy = img.size.height / bounds.size.height
        img = img.resize(size: CGSize(width: img.size.width/fy, height: bounds.size.height))
        setImage(img, for: .normal)
        updateColor()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


