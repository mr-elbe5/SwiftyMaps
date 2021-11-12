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

class PlaceData : Location{
    
    private enum CodingKeys: String, CodingKey {
        case description
        case photos
    }
    
    var description : String
    var photos : Array<PhotoData>
    
    var delegate: PlaceDelegate? = nil
    
    override init(coordinate: CLLocationCoordinate2D){
        description = ""
        photos = Array<PhotoData>()
        super.init(coordinate: coordinate)
        LocationService.shared.getLocationDescription(coordinate: coordinate){ description in
            self.description = description
            DispatchQueue.main.async {
                self.delegate?.descriptionChanged(place: self)
            }
        }
        
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        description = try values.decodeIfPresent(String.self, forKey: .description) ?? ""
        photos = try values.decodeIfPresent(Array<PhotoData>.self, forKey: .photos) ?? Array<PhotoData>()
        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(description, forKey: .description)
        try container.encode(photos, forKey: .photos)
    }
    
    func addPhoto(photo: PhotoData){
        photos.append(photo)
    }
    
}
