/*
 SwiftyMaps
 App for display and use of OSM maps without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */

import UIKit
import CoreLocation

extension UIViewController{
    
    func assertLocation(coordinate: CLLocationCoordinate2D, onComplete: ((LocationData) -> Void)? = nil){
        if let nextLocation = LocationPool.locationNextTo(coordinate: coordinate, maxDistance: Preferences.instance.maxLocationMergeDistance){
            var txt = nextLocation.description
            if !txt.isEmpty{
                txt += ", "
            }
            txt += nextLocation.coordinateString
            let alertController = UIAlertController(title: "useLocation".localize(), message: txt, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "no".localize(), style: .default) { action in
                let location = LocationPool.addLocation(coordinate: coordinate)
                LocationPool.save()
                onComplete?(location)
            })
            alertController.addAction(UIAlertAction(title: "yes".localize(), style: .cancel) { action in
                onComplete?(nextLocation)
            })
            self.present(alertController, animated: true)
        }
        else{
            let location = LocationPool.addLocation(coordinate: coordinate)
            LocationPool.save()
            onComplete?(location)
        }
    }
    
}
