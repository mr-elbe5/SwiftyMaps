/*
 OSM-Maps
 Project for displaying a map like OSM without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import UIKit
import CoreLocation

/*
 wording in method and parameter names:
 pixels: points/pixels in a view
 size: a CGSize object of pixels
 zoom: zoom level from 0 to maxZoom (18 in our case)
 zoomScale: factor for sizing depending on zoom level: 2^zoom
 planet: pixels are relative to the planet size, which is the pixel extent of the deepest/highest zoom level
 scaled: pixels are relative to a scaled planet size, usually from a scaled view
 zoomedPlanet: scaled planet size for a certain zoom level
 coordinate: coordinates in latitude/longitude with latitude from -90° to +90° and longitude from -180° to +180°
 */

struct MapStatics{
    
    static var tilePixels : CGFloat = 256
    static var tileSize = CGSize(width: tilePixels, height: tilePixels)
    static var tileRect = CGRect(x: 0, y: 0, width: tilePixels, height: tilePixels)
    static var maxZoom : Int = 18
    static var startZoom : Int = 10
    static var scrollWidthFactor : CGFloat = 3
    static var planetPixels = MapCalculator.zoomScale(at: maxZoom) * tilePixels
    static var planetSize = CGSize(width: planetPixels, height: planetPixels)
    static var planetRect = CGRect(x: 0, y: 0, width: planetPixels, height: planetPixels)
    static var scrollablePlanetSize = CGSize(width: scrollWidthFactor*planetPixels, height: planetPixels)
    static var scrollablePlanetRect = CGRect(x: 0, y: 0, width: scrollWidthFactor*planetPixels, height: planetPixels)
    
    static var equatorInMeters : CGFloat = 40075.016686 * 1000
    
    static var mapGearImage = UIImage(named: "gear.grey")
    static var mapPinImage = UIImage(named: "mappin")
    static var mapPinBlueImage = UIImage(named: "mappin.blue")
    static var mapPinRadius : CGFloat = 16
    
    static var locationRadius : CGFloat = 16
    
}

