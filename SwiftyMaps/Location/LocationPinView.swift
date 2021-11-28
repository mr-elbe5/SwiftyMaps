//
//  OSM-Maps
//
//  Created by Michael Rönnau on 02.11.21.
//

import UIKit

class LocationPinView : UIButton{
    
    static var baseFrame = CGRect(x: -MapStatics.mapPinRadius, y: -2*MapStatics.mapPinRadius, width: 2*MapStatics.mapPinRadius, height: 2*MapStatics.mapPinRadius)
    
    static var defaultPinColor = UIColor(red: 1.0, green: 0, blue: 0, alpha: 1)
    static var photoPinColor = UIColor(red: 0.75, green: 0.0, blue: 0.75, alpha: 1)
    
    var location : Location
    
    var image  : UIImage{
        get{
            let col = location.hasPhotos ? LocationPinView.photoPinColor : LocationPinView.defaultPinColor
            var img : UIImage!
            if location.hasTracks{
                img = MapStatics.mapPinEllipseImage.withTintColor(col, renderingMode: .alwaysOriginal)
            }
            else{
                img = MapStatics.mapPinImage.withTintColor(col, renderingMode: .alwaysOriginal)
            }
            let fy = img.size.height / bounds.size.height
            img = img.resize(size: CGSize(width: img.size.width/fy, height: bounds.size.height))
            return img
        }
    }
    
    init(location: Location){
        self.location = location
        super.init(frame: LocationPinView.baseFrame)
        updateImage()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updatePosition(to pos: CGPoint){
        frame = LocationPinView.baseFrame.offsetBy(dx: pos.x, dy: pos.y)
        setNeedsDisplay()
    }
    
    func updateImage(){
        print("update image")
        setImage(image, for: .normal)
    }
    
}


