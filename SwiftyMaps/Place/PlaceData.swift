/*
 OSM-Maps
 Project for displaying a map like OSM without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import CoreLocation
import UIKit

protocol PlaceDelegate{
    func descriptionChanged(place: PlaceData)
}

class PlaceData : Hashable, Codable{
    
    static func == (lhs: PlaceData, rhs: PlaceData) -> Bool {
        lhs.location == rhs.location
    }
    
    private enum CodingKeys: String, CodingKey {
        case location
        case description
        case photos
    }
    
    var location : Location
    var description : String
    var photos : Array<PhotoData>
    
    var delegate: PlaceDelegate? = nil
    
    var locationString : String{
        location.locationString
    }
    
    var coordinateString : String{
        location.coordinateString
    }
    
    init(coordinate: CLLocationCoordinate2D){
        description = ""
        photos = Array<PhotoData>()
        location = Location(coordinate: coordinate)
        location.delegate = self
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        location = try values.decodeIfPresent(Location.self, forKey: .location) ?? Location()
        description = try values.decodeIfPresent(String.self, forKey: .description) ?? ""
        photos = try values.decodeIfPresent(Array<PhotoData>.self, forKey: .photos) ?? Array<PhotoData>()
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(location, forKey: .location)
        try container.encode(description, forKey: .description)
        try container.encode(photos, forKey: .photos)
    }
    
    func assertDescription(){
        if description.isEmpty{
            description = location.locationString
        }
    }
    
    func addPhoto(photo: PhotoData){
        photos.append(photo)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(location)
    }
    
}

extension PlaceData : LocationDelegate{
    
    func placemarkChanged(location: Location) {
        delegate?.descriptionChanged(place: self)
    }
    
}
