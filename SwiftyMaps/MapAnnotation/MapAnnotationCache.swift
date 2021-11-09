/*
 OSM-Maps
 Project for displaying a map like OSM without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import CoreLocation
import UIKit

class MapAnnotationCache: Codable{
    
    static var storeKey = "annotations"
    
    static var instance : MapAnnotationCache!
    
    static func loadInstance(){
        if let cache : MapAnnotationCache = DataController.shared.load(forKey: .annotations){
            instance = cache
        }
        else{
            instance = MapAnnotationCache()
        }
    }
    
    enum CodingKeys: String, CodingKey{
        case annotations
    }
    
    var annotations : [MapAnnotation]
    
    private var lock = DispatchSemaphore(value: 1)
    
    init(){
        annotations = [MapAnnotation]()
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        annotations = try values.decodeIfPresent([MapAnnotation].self, forKey: .annotations) ?? [MapAnnotation]()
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(annotations, forKey: .annotations)
    }
    
    @discardableResult
    func addAnnotation(coordinate: CLLocationCoordinate2D) -> MapAnnotation{
        lock.wait()
        defer{lock.signal()}
        let ann = MapAnnotation(coordinate: coordinate)
        annotations.append(ann)
        return ann
    }
    
    func removeAnnotation(_ annotation: MapAnnotation){
        lock.wait()
        defer{lock.signal()}
        for idx in 0..<annotations.count{
            if annotations[idx].id == annotation.id{
                annotations.remove(at: idx)
                return
            }
        }
    }
    
    func annotationsInPlanetRect(_ rect: CGRect) -> [MapAnnotation]{
        var result = [MapAnnotation]()
        for ann in annotations{
            if ann.planetPosition.x >= rect.minX && ann.planetPosition.x < rect.minX + rect.width && ann.planetPosition.y >= rect.minY && ann.planetPosition.y < rect.minY + rect.height{
                result.append(ann)
                //print("found annotation at \(ann.planetPosition) in \(rect)")
            }
        }
        return result
    }
    
    func save(){
        DataController.shared.save(forKey: .annotations, value: self)
    }
    
}
