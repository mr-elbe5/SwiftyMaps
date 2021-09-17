//
//  MKMapView.swift
//
//  Created by Michael Rönnau on 10.08.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit
import MapKit

extension MKMapView {

    func setMkMapType(from type: MapType) {
        mapType = type.mkMapType
        setCameraZoomRange(type.zoomRange, animated: true)
    }

    var zoomLevel : Int{
        get{
            Int(round(log2(Double(360 * frame.size.width) / (region.span.longitudeDelta * 128))))
        }
    }
    
    func centerToLocation(_ location: Location) {
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            span: region.span)
        setRegion(coordinateRegion, animated: true)
    }
    
    func centerToLocation(_ region: MKCoordinateRegion) {
        setRegion(region, animated: true)
    }
    
    func loadLastRegion(animated: Bool = true){
        if let codableRegion : CodableRegion = DataController.shared.load(forKey: .region){
            setRegion(codableRegion.region, animated: animated)
        }
    }
    
    func saveLastRegion(){
        let codableRegion = CodableRegion(region: region)
        codableRegion.save()
    }
    
    class CodableRegion : Codable{
        
        enum CodingKeys: String, CodingKey {
            case latitude
            case longitude
            case latitudeDelta
            case longitudeDelta
        }

        var region : MKCoordinateRegion
        
        init(region: MKCoordinateRegion){
            self.region = region
        }
        
        required init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            if let latidude = try values.decodeIfPresent(Double.self, forKey: .latitude),
               let longitude = try values.decodeIfPresent(Double.self, forKey: .longitude),
               let latitudeDelta = try values.decodeIfPresent(Double.self, forKey: .latitudeDelta),
               let longitudeDelta = try values.decodeIfPresent(Double.self, forKey: .longitudeDelta){
                region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latidude, longitude: longitude),
                    span: MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta))
            }
            else{
                region = MKCoordinateRegion()
            }
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(region.center.latitude, forKey: .latitude)
            try container.encode(region.center.longitude, forKey: .longitude)
            try container.encode(region.span.latitudeDelta, forKey: .latitudeDelta)
            try container.encode(region.span.longitudeDelta, forKey: .longitudeDelta)
        }
        
        func save(){
            DataController.shared.save(forKey: .region, value: self)
        }
        
    }
    
}


