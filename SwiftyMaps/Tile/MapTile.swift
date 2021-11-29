/*
 SwiftyMaps
 App for display and use of OSM maps without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import UIKit

class MapTile{
    
    var x: Int
    var y: Int
    var zoom: Int
    
    var image : UIImage? = nil
    
    init(zoom: Int, x: Int, y: Int){
        self.zoom = zoom
        self.x = x
        self.y = y
    }
    
    var id : String{
        "\(zoom)-\(x)-\(y)"
    }
        
}
