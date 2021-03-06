/*
 SwiftyMaps
 App for display and use of OSM maps without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation

struct SafeMap<K: Hashable,V: AnyObject>{
    
    private var map = Dictionary<K,V>()
    private var lock = DispatchSemaphore(value: 1)
    
    func get(at key: K) -> V?{
        lock.wait()
        defer{ lock.signal()}
        return map[key]
    }
    
    mutating func add(at key: K, _ value: V){
        lock.wait()
        defer{ lock.signal()}
        map[key] = value
    }
    
    mutating func remove(at key: K){
        lock.wait()
        defer{ lock.signal()}
        map[key] = nil
    }
    
    mutating func removeAll(){
        lock.wait()
        defer{ lock.signal()}
        map.removeAll()
    }
    
}
