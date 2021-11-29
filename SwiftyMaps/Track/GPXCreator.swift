/*
 SwiftyMaps
 App for display and use of OSM maps without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import CoreLocation

class GPXCreator : NSObject{
    
    func createFile(url: URL, locations: [CLLocation]) -> Bool{
        let s = ""
        if let data = s.data(using: .utf8){
            return FileController.saveFile(data : data, url: url)
        }
        return false
    }
    
}

