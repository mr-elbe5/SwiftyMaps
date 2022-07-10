/*
 SwiftyMaps
 App for display and use of OSM maps without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import CoreLocation

class GPXParser : XMLParser{
    
    static func parseFile(url: URL) -> [Position]?{
        if let data = FileController.readFile(url: url){
            let parser = GPXParser(data: data)
            guard parser.parse() else { return nil }
            return parser.positions
        }
        return nil
    }
    
    override init(data: Data){
        super.init(data: data)
        delegate = self
    }
    
    var positions = [Position]()
    
    private var currentPosition : Position? = nil
    private var currentElement : String? = nil
    
}

extension GPXParser : XMLParserDelegate{
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        if elementName == "trkpt" || elementName == "wpt"{
            guard let latString = attributeDict["lat"], let lonString = attributeDict["lon"] else { return }
            guard let lat = Double(latString), let lon = Double(lonString) else { return }
            guard let latDegrees = CLLocationDegrees(exactly: lat), let lonDegrees = CLLocationDegrees(exactly: lon) else { return }
            currentPosition = Position(coordinate: CLLocationCoordinate2D(latitude: latDegrees, longitude: lonDegrees))
        }
        currentElement = elementName
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if currentPosition != nil{
            switch currentElement{
            case "time":
                currentPosition!.timestamp = string.ISO8601Date()!
            case "ele":
                currentPosition!.altitude = CLLocationDistance(string) ?? 0
            default:
                break
            }
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "trkpt" || elementName == "wpt", let pos = currentPosition{
            positions.append(pos)
            currentPosition = nil
        }
        currentElement = nil
    }
    
}
