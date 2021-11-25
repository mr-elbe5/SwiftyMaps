/*
 OSM-Maps
 Project for displaying a map like OSM without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import CoreLocation
import UIKit

class PlaceData : Hashable, Codable{
    
    static func == (lhs: PlaceData, rhs: PlaceData) -> Bool {
        lhs.location == rhs.location
    }
    
    private enum CodingKeys: String, CodingKey {
        case location
        case description
        case photos
        case isTrackStart
    }
    
    var location : Location
    var description : String
    var photos : Array<PhotoData>
    var isTrackStart : Bool = false
    
    private var lock = DispatchSemaphore(value: 1)
    
    var locationString : String{
        location.locationString
    }
    
    var coordinateString : String{
        location.coordinateString
    }
    
    var hasPhotos : Bool{
        !photos.isEmpty
    }
    
    init(coordinate: CLLocationCoordinate2D){
        description = ""
        photos = Array<PhotoData>()
        location = Location(coordinate: coordinate)
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        location = try values.decodeIfPresent(Location.self, forKey: .location) ?? Location()
        description = try values.decodeIfPresent(String.self, forKey: .description) ?? ""
        photos = try values.decodeIfPresent(Array<PhotoData>.self, forKey: .photos) ?? Array<PhotoData>()
        isTrackStart = try values.decodeIfPresent(Bool.self, forKey: .isTrackStart) ?? false
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(location, forKey: .location)
        try container.encode(description, forKey: .description)
        try container.encode(photos, forKey: .photos)
        try container.encode(isTrackStart, forKey: .isTrackStart)
    }
    
    func assertDescription(){
        if description.isEmpty{
            description = location.locationString
        }
    }
    
    func addPhoto(photo: PhotoData){
        photos.append(photo)
    }
    
    func deletePhoto(photo: PhotoData){
        lock.wait()
        defer{lock.signal()}
        for idx in 0..<photos.count{
            if photos[idx] == photo{
                FileController.deleteFile(url: photo.fileURL)
                photos.remove(at: idx)
                return
            }
        }
    }
    
    func deleteAllPhotos(){
        
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(location)
    }
    
}

