/*
 SwiftyMaps
 App for display and use of OSM maps without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */

import UIKit

class LocationPin : Pin{
    
    static var mapPinDefaultImage = UIImage(named: "mappin.green")
    static var mapPinPhotoImage = UIImage(named: "mappin.red")
    static var mapPinTrackImage = UIImage(named: "mappin.blue")
    static var mapPinPhotoTrackImage = UIImage(named: "mappin.purple")
    
    var location : Location
    
    init(location: Location){
        self.location = location
        super.init(frame: Pin.baseFrame)
        updateImage()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateImage(){
        let image = hasPhotos ? (hasTracks ? LocationPin.mapPinPhotoTrackImage : LocationPin.mapPinPhotoImage) : (hasTracks ? LocationPin.mapPinTrackImage : LocationPin.mapPinDefaultImage)
        setImage(image, for: .normal)
    }
    
}


