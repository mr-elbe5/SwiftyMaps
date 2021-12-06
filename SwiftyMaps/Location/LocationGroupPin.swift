/*
 SwiftyMaps
 App for display and use of OSM maps without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */

import UIKit

class LocationGroupPin : Pin{
    
    static var mapPinDefaultImage = UIImage(named: "mappin.group.green")
    static var mapPinPhotoImage = UIImage(named: "mappin.group.red")
    static var mapPinTrackImage = UIImage(named: "mappin.group.blue")
    static var mapPinPhotoTrackImage = UIImage(named: "mappin.group.purple")
    
    var locationGroup : LocationGroup
    
    init(locationGroup: LocationGroup){
        self.locationGroup = locationGroup
        super.init(frame: Pin.baseFrame)
        updateImage()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateImage(){
        let image = hasPhotos ? (hasTracks ? LocationGroupPin.mapPinPhotoTrackImage : LocationGroupPin.mapPinPhotoImage) : (hasTracks ? LocationGroupPin.mapPinTrackImage : LocationGroupPin.mapPinDefaultImage)
        setImage(image, for: .normal)
    }
    
}


