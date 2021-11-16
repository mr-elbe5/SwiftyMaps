//
//  TourCache.swift
//  SwiftyMaps
//
//  Created by Michael Rönnau on 16.11.21.
//

import Foundation
import CoreLocation
import UIKit

class TourCache: Codable{
    
    static var storeKey = "tours"
    
    static var instance : TourCache!
    
    static func loadInstance(){
        if let cache : TourCache = DataController.shared.load(forKey: .tours){
            instance = cache
        }
        else{
            instance = TourCache()
        }
    }
    
    enum CodingKeys: String, CodingKey{
        case tours
    }
    
    var tours : [TourData]
    
    private var lock = DispatchSemaphore(value: 1)
    
    init(){
        tours = [TourData]()
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        tours = try values.decodeIfPresent([TourData].self, forKey: .tours) ?? [TourData]()
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(tours, forKey: .tours)
    }
    
    @discardableResult
    func addTour() -> TourData{
        lock.wait()
        defer{lock.signal()}
        let tour = TourData()
        tours.append(tour)
        return tour
    }
    
    func removeTour(_ tour: TourData){
        lock.wait()
        defer{lock.signal()}
        for idx in 0..<tours.count{
            if tours[idx] == tour{
                tours.remove(at: idx)
                return
            }
        }
    }
    
    func toursInPlanetRect(_ rect: CGRect) -> [TourData]{
        var result = [TourData]()
        for tour in tours{
            //todo
        }
        return result
    }
    
    func save(){
        lock.wait()
        defer{lock.signal()}
        DataController.shared.save(forKey: .tours, value: self)
    }
    
}
