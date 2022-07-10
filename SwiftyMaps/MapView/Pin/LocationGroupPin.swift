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
    
    override var hasPhotos : Bool{
        locationGroup.hasPhotos
    }
    
    override var hasTracks: Bool{
        locationGroup.hasTracks
    }
    
    init(locationGroup: LocationGroup){
        self.locationGroup = locationGroup
        super.init(frame: .zero)
        updateImage()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateImage(){
        if let image = hasPhotos ? (hasTracks ? LocationGroupPin.mapPinPhotoTrackImage : LocationGroupPin.mapPinPhotoImage) : (hasTracks ? LocationGroupPin.mapPinTrackImage : LocationGroupPin.mapPinDefaultImage){
            baseFrame = CGRect(x: -image.size.width/2, y: -image.size.height*4/5, width: image.size.width, height: image.size.height)
            setImage(image, for: .normal)
        }
    }
    
}


