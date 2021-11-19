//
//  GPXParser.swift
//  SwiftyMaps
//
//  Created by Michael Rönnau on 19.11.21.
//

import Foundation
import CoreLocation

class GPXParser : XMLParser{
    
    static func parseFile(url: URL) -> [CLLocation]?{
        if let data = FileController.readFile(url: url){
            let parser = GPXParser(data: data)
            guard parser.parse() else { return nil }
            return parser.locations
        }
        return nil
    }
    
    override init(data: Data){
        super.init(data: data)
        delegate = self
    }
    
    var locations = [CLLocation]()
    
    private var current : TrackPointData? = nil
    private var subElem : String? = nil
    
    struct TrackPointData{
        var coordinate : CLLocationCoordinate2D
        var altitude : CLLocationDistance = 0
        var time : Date? = nil
    }
    
}

extension GPXParser : XMLParserDelegate{
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        switch elementName{
        case "trkpt", "wpt":
            guard let latString = attributeDict["lat"], let lonString = attributeDict["lon"] else { return }
            guard let lat = Double(latString), let lon = Double(lonString) else { return }
            guard let latDegrees = CLLocationDegrees(exactly: lat), let lonDegrees = CLLocationDegrees(exactly: lon) else { return }
            current = TrackPointData(coordinate: CLLocationCoordinate2D(latitude: latDegrees, longitude: lonDegrees))
        case "time":
            subElem = "time"
        case "ele":
            subElem = "ele"
        default:
            subElem = nil
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch subElem{
        case "time":
            current?.time = ISO8601DateFormatter().date(from: string)
        case "ele":
            current?.altitude = CLLocationDistance(string) ?? 0
        default:
            break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "trkpt" || elementName == "wpt", let tp = current{
            locations.append(CLLocation(coordinate: tp.coordinate, altitude: tp.altitude, horizontalAccuracy: 0, verticalAccuracy: 0, timestamp: tp.time ?? Date()))
            current = nil
        }
    }
    
}
