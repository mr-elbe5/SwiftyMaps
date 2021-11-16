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

struct MapCalculator{
    
    static func zoomScale(at zoom: Int) -> CGFloat{
        pow(2.0, CGFloat(zoom))
    }
    
    static func zoomPixels(at zoom: Int) -> CGFloat{
        zoomScale(at: zoom)*MapStatics.tilePixels
    }
    
    static func zoomLevelFromScale(scale: CGFloat) -> Int{
        Int(round(log2(scale)))
    }
    
    static func scrollShift(x: CGFloat) -> CGFloat{
        var normalizedX = x
        var shift : CGFloat = 0.0
        while normalizedX >= MapStatics.planetSize.width{
            normalizedX -= MapStatics.planetSize.width
            shift += MapStatics.planetSize.width
        }
        return shift
    }
    
    static func normalizedX(x: CGFloat) -> CGFloat{
        var normalizedX = x
        while normalizedX >= MapStatics.planetSize.width{
            normalizedX -= MapStatics.planetSize.width
        }
        return normalizedX
    }
    
    static func zoomScaleToPlanet(from zoom: Int) -> CGFloat{
        zoomScale(at: MapStatics.maxZoom - zoom)
    }
    
    static func zoomScaleFromPlanet(to zoom: Int) -> CGFloat{
        1.0/zoomScaleToPlanet(from: zoom)
    }
    
    static func rectInPlanetFromZoom(rect: CGRect, zoom: Int) -> CGRect{
        let scale = zoomScaleToPlanet(from: zoom)
        let xScale = MapStatics.tilePixels*scale/rect.width
        let yScale = MapStatics.tilePixels*scale/rect.height
        var rect = CGRect(x: rect.minX*xScale, y: rect.minY*yScale, width: MapStatics.tilePixels*scale, height: MapStatics.tilePixels*scale)
        while rect.minX >= MapStatics.planetPixels{
            rect = rect.offsetBy(dx: -MapStatics.planetPixels, dy: 0)
        }
        return rect
    }
    
    static func minimumZoomLevelForViewSize(viewSize: CGSize) -> Int{
        for z in 0..<10{
            let zoomPixels = zoomPixels(at: z)
            if (zoomPixels > viewSize.width) && (zoomPixels > viewSize.height){
                return z
            }
        }
        return 0
    }
    
    static func coordinateFromPointInScaledPlanetSize(point: CGPoint, scaledSize: CGSize) -> CLLocationCoordinate2D{
        var longitude = point.x/scaledSize.width*360.0 - 180.0
        while longitude >= 180{
            longitude -= 360
        }
        let latitude = atan(sinh(.pi - (point.y/scaledSize.height)*2*CGFloat.pi))*(180.0/CGFloat.pi)
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    static func coordinateFromPlanetPoint(point: CGPoint) -> CLLocationCoordinate2D{
        coordinateFromPointInScaledPlanetSize(point: point, scaledSize: MapStatics.planetSize)
    }
    
    static func pointInScaledSize(coordinate: CLLocationCoordinate2D, scaledSize: CGSize) -> CGPoint{
        let x = round((coordinate.longitude + 180)/360.0*scaledSize.width)
        let y = round((1 - log(tan(coordinate.latitude*CGFloat.pi/180.0) + 1/cos(coordinate.latitude*CGFloat.pi/180.0 ))/CGFloat.pi )/2*scaledSize.height)
        return CGPoint(x: x, y: y)
    }
    
    static func planetPointFromCoordinate(coordinate: CLLocationCoordinate2D) -> CGPoint{
        pointInScaledSize(coordinate: coordinate, scaledSize: MapStatics.planetSize)
    }
    
    static func tileCoordinate(latitude: CLLocationDegrees, longitude: CLLocationDegrees, zoom: Int) -> (x: Int, y: Int){
        let scale = zoomScale(at: zoom)
        let x = floor((longitude + 180)/360.0*scale)
        let y = floor((1 - log(tan(latitude*CGFloat.pi/180.0) + 1/cos(latitude*CGFloat.pi/180.0 ))/CGFloat.pi )/2*scale)
        return (x: Int(x), y: Int(y))
    }
    
    static func metersPerPixel(latitude: CGFloat, zoom: Int) -> CGFloat{
        156543.03 * cos(latitude) / zoomScale(at: zoom)
    }
    
    static func distanceBetween(coord1: CLLocationCoordinate2D, coord2: CLLocationCoordinate2D) -> CLLocationDistance{
        let latMid = (coord1.latitude + coord2.latitude) / 2
        let latMetersPerDegree = 111132.954 - 559.822 * cos( 2 * latMid ) + 1.175 * cos( 4 * latMid)
        let lonMetersPerDegree = 111132.954 * cos ( latMid )
        let latDelta = abs(coord1.latitude - coord2.latitude)
        let lonDelta = abs(coord1.longitude - coord2.longitude)
        return sqrt(pow( latDelta * latMetersPerDegree,2) + pow( lonDelta * lonMetersPerDegree,2))
    }
    
}

